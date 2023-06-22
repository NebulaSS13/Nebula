#define TURRET_WAIT 2
// Base type for rewritten turrets, designed to hopefully be cleaner and more fun to use and fight against.
// Use the subtypes for 'real' turrets.

/obj/machinery/turret
	name = "abstract turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_barrel"
	base_type = /obj/machinery/turret
	anchored = TRUE
	density = TRUE
	idle_power_usage = 500
	active_power_usage = 10 KILOWATTS
	interact_offline = TRUE

	transform_animate_time = 0.2 SECONDS
	uncreated_component_parts = list(/obj/item/stock_parts/power/apc)
	// Visuals.
	var/image/turret_stand = null
	var/image/turret_ray = null
	var/ray_color = "#ffffffff" // Color of the ray, changed by the FSM when switching states.

	var/image/transverse_left // Images for displaying the range of the turret's transverse
	var/image/transverse_right

	// Sounds
	var/turn_on_sound = null // Played when turret goes from off to on.
	var/turn_off_sound = null // The above, in reverse.

	// Shooting
	var/obj/item/gun/installed_gun = /obj/item/gun/energy/laser/practice // Instance of the gun inside the turret.
	var/gun_looting_prob = 25 // If the turret dies and then is disassembled, this is the odds of getting the gun.
	var/reloading_progress = 0
	var/reloading_speed = 50

	// Power
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
	var/default_bearing = null // If no target is found, the turret will return to this bearing automatically.

	// Detection.
	var/datum/proximity_trigger/angle/proximity
	var/vision_range = 7	// How many tiles away the turret can see. Values higher than 7 will let the turret shoot offscreen, which might be unsporting.
							// Higher values may also have a performance cost.

	// Logic
	var/datum/state_machine/turret/state_machine = null
	var/weakref/target = null
	var/list/potential_targets = list()
	var/timer_id = null
	var/decl/hostility/hostility = /decl/hostility/turret

/obj/machinery/turret/Initialize()
	if(ispath(installed_gun))
		installed_gun = new installed_gun(src)
		setup_gun()
	if(ispath(hostility))
		hostility = GET_DECL(hostility)

	state_machine = add_state_machine(src, /datum/state_machine/turret)

	target_bearing = dir2angle(dir)
	set_bearing(target_bearing)
	calculate_traverse()

	proximity = new(src,
		/obj/machinery/turret/proc/on_proximity,
		/obj/machinery/turret/proc/on_changed_turf_visibility,
		vision_range,
		PROXIMITY_EXCLUDE_HOLDER_TURF,
		src,
		leftmost_traverse,
		rightmost_traverse
	)
	proximity.register_turfs()

	update_icon()
	return ..()

/obj/machinery/turret/Destroy()
	remove_state_machine(src, /datum/state_machine/turret)
	deltimer(timer_id)

	QDEL_NULL(state_machine)
	QDEL_NULL(proximity)
	QDEL_NULL(installed_gun)

	turret_stand = null
	turret_ray = null
	transverse_left = null
	transverse_right = null

	target = null
	potential_targets.Cut()

	hostility = null

	return ..()

/obj/machinery/turret/dismantle()
	// If the gun doesn't drop, it will be qdel'd in Destroy()
	if(installed_gun && prob(gun_looting_prob))
		installed_gun.dropInto(loc)
		installed_gun = null

	return ..()

/obj/machinery/turret/physically_destroyed(skip_qdel)
	if(installed_gun && prob(gun_looting_prob))
		installed_gun.dropInto(loc)
		installed_gun = null

	return ..()

// Handles charging the powercell of an installed energy weapon.
/obj/machinery/turret/Process()
	if(istype(installed_gun, /obj/item/gun/energy))
		var/obj/item/gun/energy/energy_gun = installed_gun
		if(energy_gun.power_supply)
			var/obj/item/cell/power_cell = energy_gun.power_supply
			if(!power_cell.fully_charged())
				power_cell.give(active_power_usage*CELLRATE)
				update_use_power(POWER_USE_ACTIVE)
				return

	update_use_power(POWER_USE_IDLE)

/obj/machinery/turret/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/gun))
		if(!installed_gun)
			if(!user.try_unequip(I, src))
				return
			to_chat(user, SPAN_NOTICE("You install \the [I] into \the [src]!"))
			installed_gun = I
			setup_gun()
			return

	if(istype(I, /obj/item/ammo_magazine) || istype(I, /obj/item/ammo_casing))
		var/obj/item/stock_parts/ammo_box/ammo_box = get_component_of_type(/obj/item/stock_parts/ammo_box)
		if(istype(ammo_box))
			ammo_box.attackby(I, user)
			return
	. = ..()

// This is called after the gun gets instantiated or slotted in.
/obj/machinery/turret/proc/setup_gun()

// State machine processing steps, called by looping timer
/obj/machinery/turret/proc/process_turning()
	var/distance_from_target_bearing = get_distance_from_target_bearing()

	var/turn_rate = calculate_turn_rate_per_process()

	var/distance_this_step = clamp(distance_from_target_bearing, -turn_rate, turn_rate)

	if(!angle_within_traverse(current_bearing + distance_this_step))
		distance_this_step = 0

	set_bearing(current_bearing + distance_this_step)
	state_machine.evaluate()

/obj/machinery/turret/proc/process_shooting()
	if(operable())
		if(installed_gun && is_valid_target(target?.resolve()))
			var/atom/resolved_target = target.resolve()
			if(istype(resolved_target))
				addtimer(CALLBACK(src, .proc/fire_weapon, resolved_target), 0)
		else
			target = null
	state_machine.evaluate()

/obj/machinery/turret/proc/fire_weapon(atom/resolved_target)
	installed_gun?.Fire(resolved_target, src)

/obj/machinery/turret/proc/process_reloading()
	if(istype(installed_gun, /obj/item/gun/projectile))
		if(reloading_progress >= 100)
			var/obj/item/gun/projectile/proj_gun = installed_gun
			var/obj/item/ammo_magazine/stored_magazine = proj_gun.ammo_magazine

			if(proj_gun.is_jammed)
				proj_gun.is_jammed = FALSE
				playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
				reloading_progress = 0

			else if(stored_magazine && length(stored_magazine.stored_ammo) < stored_magazine.max_ammo)
				var/obj/item/stock_parts/ammo_box/ammo_box = get_component_of_type(/obj/item/stock_parts/ammo_box)
				if(ammo_box?.is_functional() && ammo_box.stored_caliber == proj_gun.caliber)
					var/obj/item/ammo_casing/casing = ammo_box.remove_ammo(stored_magazine)
					if(casing)
						stored_magazine.stored_ammo += casing
						reloading_progress = 0
		else
			reloading_progress += reloading_speed

	state_machine.evaluate()

/obj/machinery/turret/proc/process_idle()
	if(!isnull(default_bearing) && (target_bearing != default_bearing) && angle_within_traverse(default_bearing))
		target_bearing = default_bearing

		state_machine.evaluate()

// Calculates the turret's leftmost and rightmost angles from the turret's direction and traverse.
/obj/machinery/turret/proc/calculate_traverse()
	if(traverse >= 360)
		leftmost_traverse = 0
		rightmost_traverse = 0
	else
		var/half_arc = traverse / 2
		leftmost_traverse = SIMPLIFY_DEGREES(dir2angle(dir) - half_arc)
		rightmost_traverse = SIMPLIFY_DEGREES(dir2angle(dir) + half_arc)

	if(istype(proximity))
		proximity.l_angle_ = leftmost_traverse
		proximity.r_angle_ = rightmost_traverse

		proximity.register_turfs()

	cut_overlay(list(transverse_right, transverse_left))
	transverse_left = null
	transverse_right = null
	update_icon()

// Returns TRUE if the input is within the two angles that determine the traverse.
/obj/machinery/turret/proc/angle_within_traverse(angle)
	if(traverse >= 360)
		return TRUE
	return angle_between_two_angles(leftmost_traverse, angle, rightmost_traverse)

/obj/machinery/turret/set_dir(ndir)
	..()
	calculate_traverse()

// Instantly turns the turret to a specific absolute angle.
/obj/machinery/turret/proc/set_bearing(new_angle)
	current_bearing = SIMPLIFY_DEGREES(new_angle)
	set_rotation(current_bearing) // Turn the sprite.

// Gives a new target bearing, if the turret's capable of turning to it.
/obj/machinery/turret/proc/set_target_bearing(new_angle)
	new_angle = SIMPLIFY_DEGREES(new_angle)
	if(angle_within_traverse(new_angle))
		target_bearing = new_angle

// Turret turning calculations
#define TURN_CLOCKWISE 1
#define TURN_COUNTERCLOCKWISE -1
// Returns the signed distance from the target bearing
/obj/machinery/turret/proc/get_distance_from_target_bearing()
	var/raw_distance = target_bearing - current_bearing
	if(traverse < 360)
		if(SIMPLIFY_DEGREES(target_bearing - current_bearing) <= SIMPLIFY_DEGREES(rightmost_traverse - current_bearing))
			return SIMPLIFY_DEGREES(raw_distance*TURN_CLOCKWISE)
		else if(SIMPLIFY_DEGREES(current_bearing - target_bearing) <= SIMPLIFY_DEGREES(current_bearing - leftmost_traverse))
			return SIMPLIFY_DEGREES(raw_distance*TURN_COUNTERCLOCKWISE)
		return 0

	// The turret can traverse the entire circle, so it must decide which direction is a shorter distance.
	return closer_angle_difference(current_bearing, target_bearing)

/obj/machinery/turret/proc/within_bearing()
	var/distance_from_target_bearing = closer_angle_difference(current_bearing, target_bearing)
	return abs(distance_from_target_bearing) <= bearing_tolerence

#undef TURN_CLOCKWISE
#undef TURN_COUNTERCLOCKWISE

/obj/machinery/turret/proc/calculate_turn_rate_per_process()
	return turning_rate / (1 SECOND / TURRET_WAIT)

// Turret proximity handling
/obj/machinery/turret/proc/on_proximity(atom/movable/AM)
	if(inoperable()) // Should be handled by the state machine, but just in case.
		return
	if(target?.resolve() == AM)
		track_target()
	else
		add_target(AM)

/obj/machinery/turret/proc/on_changed_turf_visibility(list/prior_turfs, list/current_turfs)
	// When a door opens etc. immediately check the newly visible turfs for targets.

	// Don't perform this check on spawn
	if(!length(prior_turfs))
		return
	if(inoperable() || QDELETED(src))
		return
	var/list/turfs_to_check = current_turfs - prior_turfs
	for(var/turf/T as anything in turfs_to_check)
		for(var/atom/movable/AM in T)
			on_proximity(AM)

// Turret targeting
/obj/machinery/turret/proc/can_be_hostile_to(atom/potential_target)
	return hostility?.can_target(src, potential_target)

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
	if(!(get_turf(A) in proximity.seen_turfs_))
		return FALSE
	return TRUE

/obj/machinery/turret/proc/find_target()
	if(is_valid_target(target?.resolve()))
		set_target_bearing(Get_Angle(src, target.resolve()))
		return target

	else if(length(potential_targets))
		while(length(potential_targets))
			var/weakref/W = potential_targets[1]
			potential_targets -= W
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
			potential_targets |= weakref(A)

		return TRUE
	return FALSE

/obj/machinery/turret/proc/track_target()
	set_target_bearing(Get_Angle(src, target.resolve()))
	state_machine.evaluate()

// Returns whether the turret should reload at the moment. If a valid target is in sight, only reloads the minimum amount to shoot again.
/obj/machinery/turret/proc/should_reload()
	if(istype(installed_gun, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/proj_gun = installed_gun
		if(proj_gun.load_method & MAGAZINE)
			var/obj/item/stock_parts/ammo_box/ammo_box = get_component_of_type(/obj/item/stock_parts/ammo_box)
			if(!ammo_box || !ammo_box.is_functional())
				return FALSE
			// Since the ammo boxes caliber is null if it is unloaded, this also checks for an empty ammo box.
			if(ammo_box.stored_caliber != proj_gun.caliber)
				return FALSE
			if(proj_gun.is_jammed)
				return TRUE
			if(proj_gun.ammo_magazine)
				var/ammo_remaining = proj_gun.getAmmo() // Counts ammo in the chamber as well.
				// Only reload the magazine if we're completely out of ammo or we don't have a target.
				if(ammo_remaining == 0)
					return TRUE
				if(!is_valid_target(target?.resolve()) && length(proj_gun.ammo_magazine.stored_ammo) != proj_gun.ammo_magazine.max_ammo)
					return TRUE
		else
			return FALSE

/obj/machinery/turret/emag_act(remaining_charges, mob/user, emag_source)
	if(!emagged)
		emagged = TRUE
		to_chat(user, SPAN_WARNING("You short out \the [src]'s threat assessment circuits."))
		visible_message("\The [src] hums oddly...")
		enabled = FALSE
		addtimer(CALLBACK(src, .proc/emagged_targeting), 6 SECONDS)
		state_machine.evaluate()

/obj/machinery/turret/proc/emagged_targeting()
	hostility = GET_DECL(/decl/hostility) // Shoots almost everyone.
	enabled = TRUE
	state_machine.evaluate()

/obj/machinery/turret/power_change()
	..()
	state_machine.evaluate()

/obj/machinery/turret/on_component_failure()
	..()
	state_machine.evaluate()

/obj/machinery/turret/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/turret/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = TRUE)
	var/data[0]
	data["enabled"] = enabled
	data["weaponName"] = installed_gun ? installed_gun.name : null
	data["currentBearing"] = current_bearing

	if(LAZYLEN(installed_gun?.firemodes))
		var/fm_index = 1
		var/list/fm_data = list()
		for(var/datum/firemode/fm in installed_gun.firemodes)
			fm_data.Add(list(list(
				"name" = fm.name,
				"index" = fm_index,
				"selected" = installed_gun.sel_mode == fm_index
				)))
			fm_index += 1
		data["firemodes"] = fm_data
	data["weaponHasFiremodes"] = installed_gun ? LAZYLEN(installed_gun.firemodes) : 0
	data["defaultBearing"] = isnull(default_bearing) ? "None" : default_bearing

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/turret/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(href_list["set_enabled"])
		toggle_enabled()
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

	if(href_list["set_default"])
		var/amount = input(user, "Input an angle between [leftmost_traverse] and [rightmost_traverse] degrees. Click cancel to disable default.", "Set Default Bearing", default_bearing) as null|num
		if(isnum(amount))
			default_bearing = clamp(amount, leftmost_traverse, rightmost_traverse)
		else
			default_bearing = null

		return TOPIC_REFRESH

	if(href_list["manual_fire"])
		if(installed_gun)
			var/turf/T = get_turf_from_angle(x, y, z, current_bearing, vision_range)
			if(!T)
				return TOPIC_NOACTION
			installed_gun.Fire(T, src)
			return TOPIC_REFRESH

	if(href_list["switch_firemode"])

		if(change_firemode(text2num(href_list["switch_firemode"])))
			return TOPIC_REFRESH
		return TOPIC_HANDLED

	if(href_list["eject_gun"])
		if(installed_gun)
			if(!CanPhysicallyInteractWith(user, src))
				to_chat(user, SPAN_WARNING("You cannot eject the weapon from \the [src] remotely!"))
				return TOPIC_HANDLED
			installed_gun.forceMove(get_turf(src))
			installed_gun = null

		return TOPIC_REFRESH

/obj/machinery/turret/proc/toggle_enabled()
	enabled = !enabled
	state_machine.evaluate()
	return TRUE

/obj/machinery/turret/proc/change_firemode(firemode_index)
	if(!installed_gun || !LAZYLEN(installed_gun.firemodes))
		return FALSE
	if(firemode_index > LAZYLEN(installed_gun.firemodes) || firemode_index == installed_gun.sel_mode)
		return FALSE

	installed_gun.switch_firemodes(firemode_index)
	return TRUE

/obj/machinery/turret/on_update_icon()
	if(!turret_stand)
		turret_stand = image(icon, "turretCover")
		turret_stand.layer = src.layer - 0.02
		turret_stand.appearance_flags = KEEP_APART|RESET_TRANSFORM|TILE_BOUND|PIXEL_SCALE
		add_overlay(turret_stand)

	if(!turret_ray)
		turret_ray = image(icon, "turret_ray")
		turret_ray.plane = ABOVE_LIGHTING_PLANE
		turret_ray.appearance_flags = KEEP_APART|RESET_COLOR|TILE_BOUND|PIXEL_SCALE
		turret_ray.mouse_opacity = FALSE

		var/matrix/M = matrix(turret_ray.transform)
		// Offset away from the parent, so that when the parent rotates, this rotates with it correctly.
		M.Translate(0, (1 * WORLD_ICON_SIZE * 0.50)+4)
		M.Scale(1, 4)
		turret_ray.transform = M
		add_overlay(turret_ray)

	if(!transverse_left && leftmost_traverse)
		transverse_left = image(icon, "transverse_indicator_left")
		transverse_left.layer = src.layer - 0.01
		transverse_left.appearance_flags = KEEP_APART|RESET_TRANSFORM|TILE_BOUND|PIXEL_SCALE

		// Rotate according to transverse
		var/matrix/M = matrix(transverse_left.transform)
		M.Turn(leftmost_traverse)
		transverse_left.transform = M
		add_overlay(transverse_left)

	if(!transverse_right && rightmost_traverse)
		transverse_right = image(icon, "transverse_indicator_right")
		transverse_right.layer = src.layer - 0.01
		transverse_right.appearance_flags = KEEP_APART|RESET_TRANSFORM|TILE_BOUND|PIXEL_SCALE

		// Rotate according to transverse
		var/matrix/M = matrix(transverse_right.transform)
		M.Turn(rightmost_traverse)
		transverse_right.transform = M
		add_overlay(transverse_right)

	// Changes the ray color based on state.
	cut_overlay(turret_ray)
	turret_ray.color = ray_color
	add_overlay(turret_ray)
	return ..()