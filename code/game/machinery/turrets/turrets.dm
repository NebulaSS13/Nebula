// Base type for rewritten turrets, designed to hopefully be cleaner and more fun to use and fight against.
// Use the subtypes for 'real' turrets.

/obj/machinery/turret
	name = "abstract turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_barrel"
	base_type = /obj/machinery/turret
	anchored = TRUE
	idle_power_usage = 500
	active_power_usage = 60 KILOWATTS // This determines how fast the internal cell gets charged.
	interact_offline = TRUE

	transform_animate_time = 0.2 SECONDS

	// Visuals.
	var/image/turret_stand = null
	var/image/turret_ray = null
	var/ray_color = "#ffffffff" // Color of the ray, changed by the FSM when switching states.

	// Sounds
	var/turn_on_sound = null // Played when turret goes from off to on.
	var/turn_off_sound = null // The above, in reverse.

	// Shooting
	var/obj/item/gun/installed_gun = /obj/item/gun/energy/laser/practice // Instance of the gun inside the turret.
	var/gun_looting_prob = 25 // If the turret dies and then is disassembled, this is the odds of getting the gun.

	// Power
	var/obj/item/cell/internal_cell = /obj/item/cell/high // The battery that is used to fire the gun and for the turret to work semi-independantly of the powernet.
	var/can_charge_cell = TRUE // If FALSE, the battery has to be swapped out manually.
	var/can_swap_cell = FALSE // If TRUE, the cell can be replaced with a screwdriver.
	var/cell_looting_prob = 25 // Similar story as the gun looting var.
	var/enabled = TRUE // If false, turret turns off.

	// Angles
	// Remember that in BYOND, NORTH equals 0 absolute degrees, and not 90.
	var/traverse = 180 // Determines how wide the turret can turn to shoot things, in degrees. The 'front' of the turret is determined by it's dir variable.
	var/leftmost_traverse = null // How far left or right the turret can turn. Set automatically using the above variable and the inital dir value.
	var/rightmost_traverse = null
	var/current_bearing = 0 // Current absolute angle the turret has, used to calculate if it needs to turn to try to shoot the target.
	var/target_bearing = 0 // The desired bearing. If the current bearing is too far from this, the turret will turn towards it until within tolerence.
	var/bearing_tolerence = 3 // Degrees that the turret must be within to be able to shoot at the target.
	var/turning_rate = 90 // Degrees per second.

	// Detection.
	var/datum/proximity_trigger/square/proximity = null
	var/vision_range = 7	// How many tiles away the turret can see. Values higher than 7 will let the turret shoot offscreen, which might be unsporting.
							// Higher values may also have a performance cost.
	
	// Logic
	var/datum/state_machine/turret/state_machine = null
	var/weakref/target = null
	var/list/potential_targets = null
	var/timer_id = null
	var/datum/hostility/hostility = /datum/hostility



/obj/machinery/turret/Initialize()
	state_machine = new(src)
	proximity = new(src, 
		/obj/machinery/turret/proc/on_proximity,
		/obj/machinery/turret/proc/on_changed_turf_visibility,
		vision_range,
		PROXIMITY_EXCLUDE_HOLDER_TURF
	)
	proximity.register_turfs()
	
	if(ispath(internal_cell))
		internal_cell = new internal_cell(src)
	if(ispath(installed_gun))
		installed_gun = new installed_gun(src)
		setup_gun()
	if(ispath(hostility))
		hostility = new hostility(src)
	target_bearing = dir2angle(dir)
	set_bearing(target_bearing)
	calculate_traverse()
	update_icon()
	return ..()

/obj/machinery/turret/Destroy()
	QDEL_NULL(state_machine)
	QDEL_NULL(proximity)
	QDEL_NULL(internal_cell)
	QDEL_NULL(installed_gun)
	hostility = null
	return ..()

// This should be called after the gun gets instantiated or slotted in.
/obj/machinery/turret/proc/setup_gun()
	if(istype(installed_gun, /obj/item/gun/energy))
		var/obj/item/gun/energy/E = installed_gun
		E.use_external_power = TRUE
		if(!E.self_recharge)
			E.self_recharge = TRUE
			START_PROCESSING(SSobj, E)

/obj/machinery/turret/set_dir(ndir)
	..()
	calculate_traverse()

/obj/machinery/turret/Process()
	process_power()

//	state_machine.evaluate()
//	var/decl/state/turret/turret_state = state_machine.current_state
//	if(turret_state.type == /decl/state/turret/turning) // TODO remove after test.
//		process_turning()
//	else if(turret_state.type == /decl/state/turret/engaging)
//		process_shooting()

/obj/machinery/turret/proc/process_power()
	// If the turret is dead or turned off, don't draw any power.
	if((stat & BROKEN) || !internal_cell)
		update_use_power(POWER_USE_OFF)
		// TODO Consider making turret stop processing later.
		return
	
	// Draw idle power from cell if the area has no regular power.
	else if(stat & NOPOWER)
		// See if the turret should lose power.
		if(!internal_cell.check_charge(idle_power_usage * CELLRATE))
			update_use_power(POWER_USE_OFF)
		//	set_state(TURRET_DEPOWERED)
			// TODO ditto
			return
		else
			internal_cell.use(idle_power_usage * CELLRATE)

	// Charge the cell if possible.
	else if(can_charge_cell && !internal_cell.fully_charged())
		var/power_to_give = active_power_usage * CELLRATE
	//	var/multiplier = time_per_process() / SSobj.wait // This is used so when the turret is using SSfastprocess it doesn't get supercharged.
		var/multiplier = SSfastprocess.wait / SSmachines.wait // TODO remove
		internal_cell.give(power_to_give * multiplier)
		update_use_power(POWER_USE_ACTIVE)
	// Draw idle power from APC.
	else
		update_use_power(POWER_USE_IDLE)

/obj/machinery/turret/proc/is_powered()
	if(!enabled)
		return FALSE
	if(stat & NOPOWER)
		return internal_cell?.check_charge(idle_power_usage * CELLRATE)
	return TRUE

#define TURN_CLOCKWISE 1
#define TURN_COUNTERCLOCKWISE -1

/obj/machinery/turret/proc/process_turning()
	var/distance_from_target_bearing = abs(target_bearing - current_bearing) * get_direction_to_target_bearing()
	var/distance_this_step = min(calculate_turn_rate_per_process(), abs(distance_from_target_bearing)) 
	var/adjustment = distance_this_step * SIGN(distance_from_target_bearing)

	if(!angle_within_traverse(current_bearing + adjustment))
		adjustment = 0

	set_bearing(current_bearing + adjustment)
	state_machine.evaluate()

/obj/machinery/turret/proc/get_direction_to_target_bearing()
	if(SIMPLIFY_DEGREES(target_bearing - current_bearing) <= SIMPLIFY_DEGREES(rightmost_traverse - current_bearing))
		return TURN_CLOCKWISE
	else if(SIMPLIFY_DEGREES(current_bearing - target_bearing) <= SIMPLIFY_DEGREES(current_bearing - leftmost_traverse))
		return TURN_COUNTERCLOCKWISE
	return 0

#undef TURN_CLOCKWISE
#undef TURN_COUNTERCLOCKWISE


/obj/machinery/turret/proc/calculate_turn_rate_per_process()
	return turning_rate / (1 SECOND / SSfastprocess.wait)


/obj/machinery/turret/proc/process_shooting()
	if(installed_gun && is_valid_target(target?.resolve()))
		var/atom/real_target = target.resolve()
		if(istype(real_target))
			spawn(0)
				installed_gun.Fire(real_target, src)
	else
		target = null
	state_machine.evaluate()

/obj/machinery/turret/update_icon()
	if(!turret_stand)
		turret_stand = image(icon, "turretCover")
		turret_stand.layer = src.layer - 0.01
		turret_stand.appearance_flags = KEEP_APART|RESET_TRANSFORM|TILE_BOUND|PIXEL_SCALE 
		add_overlay(turret_stand)
	
	if(!turret_ray)
		turret_ray = image(icon, "turret_ray")
		turret_ray.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		turret_ray.appearance_flags = KEEP_APART|RESET_COLOR|TILE_BOUND|PIXEL_SCALE
		turret_ray.mouse_opacity = FALSE
	
		var/matrix/M = matrix(turret_ray.transform)
		// Offset away from the parent, so that when the parent rotates, this rotates with it correctly.
		M.Translate(0, (1 * WORLD_ICON_SIZE * 0.50)+4)
		M.Scale(1, 4)
		turret_ray.transform = M
		add_overlay(turret_ray)

	// Changes the ray color based on state.
	cut_overlay(turret_ray)
	turret_ray.color = ray_color
	add_overlay(turret_ray)

	..()

/obj/machinery/turret/proc/calculate_traverse()
	if(traverse >= 360)
		return

	var/half_arc = traverse / 2
	leftmost_traverse = SIMPLIFY_DEGREES(dir2angle(dir) - half_arc)
	rightmost_traverse = SIMPLIFY_DEGREES(dir2angle(dir) + half_arc)

// Instantly turns the turret to a specific absolute angle.
/obj/machinery/turret/proc/set_bearing(new_angle)
	current_bearing = SIMPLIFY_DEGREES(new_angle)
	set_rotation(current_bearing) // Turn the sprite.

// Gives a new target bearing, if the turret's capable of turning to it.
/obj/machinery/turret/proc/set_target_bearing(new_angle)
	new_angle = SIMPLIFY_DEGREES(new_angle)
	if(angle_within_traverse(new_angle))
		target_bearing = new_angle

/obj/machinery/turret/proc/on_proximity(atom/movable/AM)
	to_world("Turret [src] detected [AM] in proximity.")
//	set_target(AM)
	if(target?.resolve() == AM)
		track_target()
	else
		add_target(AM)
	if(!target && istype(AM, /obj/item) && !istype(AM, /obj/item/projectile))
		set_target_bearing(Get_Angle(src, AM)) // Ooo shiny!
		state_machine.evaluate()

/obj/machinery/turret/proc/on_changed_turf_visibility(list/prior_turfs, list/current_turfs)

/obj/machinery/turret/proc/within_bearing()
	var/distance_from_target_bearing = closer_angle_difference(current_bearing, target_bearing)
	return abs(distance_from_target_bearing) <= bearing_tolerence

// Returns TRUE if the input is within the two angles that determine the traverse.
/obj/machinery/turret/proc/angle_within_traverse(angle)
	if(traverse >= 360)
		return TRUE
	return angle_between_two_angles(leftmost_traverse, angle, rightmost_traverse)

/obj/machinery/turret/proc/can_be_hostile_to(atom/potential_target)
	return hostility?.can_target(potential_target)

/obj/machinery/turret/proc/set_target(atom/new_target)
	if(is_valid_target(new_target))
		target = weakref(new_target)
		set_target_bearing(Get_Angle(src, target.resolve()))

/obj/machinery/turret/proc/is_valid_target(atom/A)
	if(!istype(A))
		return FALSE
	if(!angle_within_traverse(Get_Angle(src, A)))
		return FALSE
	if(!can_be_hostile_to(A))
		return FALSE
	if(get_dist(src, A) > vision_range)
		return FALSE
//	if(!(get_turf(A) in proximity.turfs_in_range)) // This might be expensive. // and also doesn't work
//		return FALSE
	return TRUE

/obj/machinery/turret/proc/find_target()
	if(is_valid_target(target?.resolve()))
		return target
	
	else if(LAZYLEN(potential_targets))
		while(LAZYLEN(potential_targets))
			var/weakref/W = LAZYACCESS(potential_targets, 1)
			LAZYREMOVE(potential_targets, W)
			if(is_valid_target(W.resolve()))
				target = W
				track_target()
				return W
	
	target = null
	return null

/obj/machinery/turret/proc/add_target(atom/A)
	if(is_valid_target(A))
		if(!target)
			target = weakref(A)
			track_target()
		else
			LAZYDISTINCTADD(potential_targets, weakref(A))

/obj/machinery/turret/proc/track_target()
	set_target_bearing(Get_Angle(src, target.resolve()))
	state_machine.evaluate()


/obj/machinery/turret/emag_act(remaining_charges, mob/user, emag_source)
	if(!emagged)
		emagged = TRUE
		to_chat(user, SPAN_WARNING("You short out \the [src]'s threat assessment circuits."))
		visible_message("\The [src] hums oddly...")
		enabled = FALSE
		addtimer(CALLBACK(src, .proc/emagged_targeting), 6 SECONDS)
		state_machine.evaluate()

/obj/machinery/turret/proc/emagged_targeting()
	QDEL_NULL(hostility)
	hostility = new /datum/hostility(src) // Shoots almost everyone.
	enabled = TRUE
	state_machine.evaluate()


/obj/machinery/turret/power_change()
	..()
	state_machine.evaluate()

/obj/machinery/turret/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/turret/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = TRUE)
	var/data[0]
	data["enabled"] = enabled
	data["cellCharge"] = internal_cell ? internal_cell.percent() : null
	data["weaponName"] = installed_gun ? installed_gun.name : null
	data["currentBearing"] = current_bearing
	data["weaponHasFiremodes"] = installed_gun ? LAZYLEN(installed_gun.firemodes) : 0

//	data["access"] = !isLocked(user)
//	data["locked"] = locked
//	data["enabled"] = enabled
//	data["is_lethal"] = 1
//	data["lethal"] = lethal

//	if(data["access"])
//		var/settings[0]
//		settings[++settings.len] = list("category" = "Neutralize All Non-Synthetics", "setting" = "check_synth", "value" = check_synth)
//		settings[++settings.len] = list("category" = "Check Weapon Authorization", "setting" = "check_weapons", "value" = check_weapons)
//		settings[++settings.len] = list("category" = "Check Security Records", "setting" = "check_records", "value" = check_records)
//		settings[++settings.len] = list("category" = "Check Arrest Status", "setting" = "check_arrest", "value" = check_arrest)
//		settings[++settings.len] = list("category" = "Check Access Authorization", "setting" = "check_access", "value" = check_access)
//		settings[++settings.len] = list("category" = "Check misc. Lifeforms", "setting" = "check_anomalies", "value" = check_anomalies)
//		data["settings"] = settings

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/turret/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(href_list["set_enabled"])
		enabled = text2num(href_list["set_enabled"])
		state_machine.evaluate()
		return TOPIC_REFRESH

	if(href_list["adjust_bearing"])
		var/amount = text2num(href_list["adjust_bearing"])
		if(!amount)
			return TOPIC_NOACTION
		set_target_bearing(target_bearing + amount)
		state_machine.evaluate()
		return TOPIC_REFRESH

	if(href_list["set_bearing"])
		var/amount = input(user, "Input an angle between [leftmost_traverse] and [rightmost_traverse] degrees.", "Set Bearing", target_bearing) as null|num
		if(!isnull(amount))
			set_target_bearing(amount)
			state_machine.evaluate()
			return TOPIC_REFRESH
	
	if(href_list["manual_fire"])
		if(installed_gun)
			var/turf/T = get_turf_from_angle(x, y, z, current_bearing, vision_range)
			if(!T)
				return TOPIC_NOACTION
			installed_gun.Fire(T, src)
			return TOPIC_REFRESH
