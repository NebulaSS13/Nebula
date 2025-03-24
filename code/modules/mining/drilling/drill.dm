/obj/machinery/mining_drill
	name = "mining drill head"
	desc = "An enormous drill."
	icon = 'icons/obj/mining_drill.dmi'
	icon_state = "mining_drill_off"
	layer = ABOVE_HUMAN_LAYER
	anchored = FALSE
	density = TRUE
	use_power = POWER_USE_OFF
	power_channel = LOCAL
	active_power_usage = 10 KILOWATTS
	idle_power_usage = 500
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	base_type = /obj/machinery/mining_drill
	z_flags = ZMM_WIDE_LOAD

	/// The drill's FSM, keeping track of which state the drill is currently in.
	var/datum/state_machine/drill/state_machine = null

	/// Ore that is presently inside of the drill, ready to be extracted.
	var/list/contained_ore = list()

	/// Drill supports presently connected to the drill head.
	var/list/supports = list()

	/// How many braces are required for the drill to operate.
	var/const/MINIMUM_SUPPORT_NUMBER = 2

	/// List of turfs that the drill will attempt to mine.
	var/list/turfs_to_mine = list()

	/// The turf that the drill is presently mining.
	var/turf/current_turf = null

	//Upgrades
	/// The radius for the drill to use when populating `turfs_to_mine`. Upgraded with scanning modules.
	var/drill_radius = 2

	/// The ore capacity for the drill. The drill will stop mining if it gets full. Upgraded with matter bins.
	var/ore_capacity = 200

	/// How fast the drill mines out the ore contained within `turfs_to_mine`. Faster speed requires more power. Upgraded with micro lasers.
	var/mining_speed = 1

	/// Modifies how much energy is required to extract one piece of ore, with diminishing returns for higher values. Upgraded with capacitors.
	var/efficiency_rating = 1

	/// Determines how much less energy each capacitor rating reduces. Every capacitor after the first reduces the power draw by this amount each time.
	var/const/EFFICIENCY_EXPONENT = 0.8 // Raise this closer to 1 to make capacitors less powerful.

/obj/machinery/mining_drill/Initialize()
	state_machine = add_state_machine(src, /datum/state_machine/drill)
	return ..()

/obj/machinery/mining_drill/Destroy()
	remove_state_machine(src, /datum/state_machine/drill)
	turfs_to_mine.Cut()
	current_turf = null
	QDEL_NULL_LIST(contained_ore)
	for(var/thing in supports)
		var/obj/structure/drill_brace/B = thing
		B.disconnect_from_drill()
	return ..()

/obj/machinery/mining_drill/Process()
	state_machine.evaluate()
	var/decl/state/drill/current_state = state_machine.current_state
	current_state.process(src)

/obj/machinery/mining_drill/physical_attack_hand(mob/user)
	if(!panel_open)
		var/on = use_power ? TRUE : FALSE
		on = !on
		if(on)
			update_use_power(POWER_USE_IDLE)
		else
			update_use_power(POWER_USE_OFF)
		playsound(src, "button", 60)
		to_chat(user, SPAN_NOTICE("You turn \the [src] [use_power ? "on" : "off"]."))
		state_machine.evaluate()
		return TRUE
	return FALSE

/obj/machinery/mining_drill/on_update_icon()
	icon_state = "mining_drill_[use_power == POWER_USE_ACTIVE ? "on" : "off"]"
	z_flags &= ~ZMM_MANGLE_PLANES
	cut_overlays()
	var/decl/state/drill/current_state = state_machine.current_state
	if(current_state.light_icon_state)
		add_overlay(emissive_overlay(icon, current_state.light_icon_state, src, SOUTH, current_state.light_color))
		z_flags |= ZMM_MANGLE_PLANES
		set_light(2, 0.4, current_state.light_color)
	else
		set_light(0)
	return ..()

/obj/machinery/mining_drill/proc/handle_supports()
	state_machine.evaluate()
	anchored = length(supports) >= 1 ? TRUE : FALSE
	if(can_fall())
		fall()


/obj/machinery/mining_drill/proc/reset_drill()
	turfs_to_mine.Cut()
	current_turf = null

/obj/machinery/mining_drill/cannot_transition_to(state_path)
	if(use_power != POWER_USE_OFF)
		return SPAN_NOTICE("You must turn \the [src] off first.")
	return ..()

/obj/machinery/mining_drill/components_are_accessible(path)
	return (use_power == POWER_USE_OFF) && ..()


/obj/machinery/mining_drill/RefreshParts()
	. = ..()
	drill_radius = 1 + total_component_rating_of_type(/obj/item/stock_parts/scanning_module)
	ore_capacity = 200 * total_component_rating_of_type(/obj/item/stock_parts/matter_bin)
	mining_speed = total_component_rating_of_type(/obj/item/stock_parts/micro_laser)
	efficiency_rating = total_component_rating_of_type(/obj/item/stock_parts/capacitor)

	var/efficiency = EFFICIENCY_EXPONENT ** (efficiency_rating - 1)
	change_power_consumption(initial(active_power_usage) * efficiency * mining_speed, POWER_USE_ACTIVE)

/obj/machinery/mining_drill/proc/populate_turfs_to_mine()
	turfs_to_mine.Cut()
	var/list/turf_candidates = RANGE_TURFS(src, drill_radius)
	for(var/thing in turf_candidates)
		var/turf/T = thing
		if(turf_has_ore(T))
			turfs_to_mine += T

/obj/machinery/mining_drill/proc/scan_visuals()
	for(var/thing in RANGE_TURFS(src, drill_radius))
		var/turf/T = thing
		var/delay = (get_dist(get_turf(src), T) + 1) * 3
		addtimer(CALLBACK(src, PROC_REF(scan_visual_tile), T), delay)


/obj/machinery/mining_drill/proc/scan_visual_tile(turf/T)
	var/obj/effect/temporary/temp = new(T, 1 SECOND, 'icons/effects/effects.dmi', "sonar_ping")
	temp.color = "#00ffff77"

/obj/machinery/mining_drill/proc/turf_has_ore(turf/T)
	if(!istype(T) || !has_extension(T, /datum/extension/buried_resources))
		return FALSE
	var/datum/extension/buried_resources/resources = get_extension(T, /datum/extension/buried_resources)
	return length(resources?.resources)

/obj/machinery/mining_drill/proc/mine_ore(turf/T)
	if(!T)
		return
	// Was tempted to add a drilling sound but it was awful.
	var/datum/extension/buried_resources/resources = get_extension(T, /datum/extension/buried_resources)
	for(var/i in 1 to mining_speed)
		if(!length(resources.resources))
			break
		var/material_typepath = pick(resources.resources)
		contained_ore += new /obj/item/stack/material/ore(src, 1, material_typepath)
		resources.resources[material_typepath] -= 1
		if(resources.resources[material_typepath] <= 0)
			// Remove the typepath if it ran out.
			resources.resources -= material_typepath

/obj/machinery/mining_drill/proc/deplete_turf(turf/T)
	if(!turf_has_ore(T) && istype(T))
		turfs_to_mine -= T
		if(has_extension(T, /datum/extension/buried_resources))
			remove_extension(T, /datum/extension/buried_resources)

/obj/machinery/mining_drill/proc/choose_turf_to_mine()
	current_turf = turfs_to_mine[1]

/obj/machinery/mining_drill/verb/unload_verb()
	set name = "Unload Drill"
	set category = "Object"
	set src in oview(1)

	var/obj/structure/ore_box/B = locate() in orange(1)
	if(B)
		unload_into_box(B, usr)

/obj/machinery/mining_drill/proc/unload_into_box(obj/structure/ore_box/box, mob/user)
	if(!CanPhysicallyInteract(user))
		return

	if(box?.Adjacent(src))
		if(!length(contained_ore))
			to_chat(user, SPAN_NOTICE("\The [src]'s storage cache is empty."))
			return
		box.insert_ores(contained_ore, user)
		contained_ore.Cut()
		playsound(src, 'sound/machines/vending_machine.ogg', 60, 1)
		playsound(box, 'sound/effects/rockcrumble.ogg', 60, 1)
		visible_message(
			SPAN_NOTICE("\The [user] unloads \the [src]'s storage cache into \the [box]."),
			SPAN_NOTICE("You unload \the [src]'s storage cache into \the [box]."),
			SPAN_NOTICE("You hear rocks falling into a container.")
		)
	else
		to_chat(user, SPAN_NOTICE("You must move an ore box up to \the [src] before you can unload it."))
