/obj/machinery/mining
	icon = 'icons/obj/mining_drill.dmi'
	anchored = 0
	use_power = POWER_USE_OFF //The drill takes power directly from a cell.
	density = 1
	layer = ABOVE_HUMAN_LAYER //So it draws over mobs in the tile north of it.
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

/obj/machinery/mining/drill
	name = "mining drill head"
	desc = "An enormous drill."
	icon_state = "mining_drill"
	power_channel = LOCAL
	active_power_usage = 10 KILOWATTS
	base_type = /obj/machinery/mining/drill
	var/list/generated_ore = list()
	var/braces_needed = 2
	var/list/supports = list()
	var/supported = 0
	var/active = FALSE
	var/list/resource_field = list()

	//Upgrades
	var/harvest_speed
	var/capacity

	//Flags
	var/need_update_field = 0
	var/need_player_check = 0

/obj/machinery/mining/drill/Process()
	if(need_player_check)
		return

	check_supports()

	if(!active) return

	if(!anchored)
		system_error("system configuration error")
		return

	if(stat & NOPOWER)
		system_error("insufficient charge")
		return

	if(need_update_field)
		get_resource_field()

	if(world.time % 10 == 0)
		update_icon()

	if(!active)
		return

	//Drill through the flooring, if any.
	var/turf/T = get_turf(src)
	if(T)
		T.drill_act()

	while(length(resource_field))
		var/turf/harvesting = pick(resource_field)
		var/datum/extension/buried_resources/resources = get_extension(harvesting, /datum/extension/buried_resources)
		if(!length(resources?.resources))
			if(resources)
				remove_extension(harvesting, /datum/extension/buried_resources)
			resource_field -= harvesting
			continue
		break

	if(!length(resource_field))
		set_active(FALSE)
		need_player_check = 1
		update_icon()
		return

	var/turf/harvesting = pick(resource_field)
	var/datum/extension/buried_resources/resources = get_extension(harvesting, /datum/extension/buried_resources)
	var/harvested = 0
	for(var/metal in resources.resources)

		if(length(generated_ore) >= capacity)
			system_error("insufficient storage space")
			set_active(FALSE)
			need_player_check = 1
			update_icon()
			return

		var/generating_ore = min(capacity - length(generated_ore), resources.resources[metal])
		resources.resources[metal] -= generating_ore
		if(resources.resources[metal] <= 0)
			resources.resources -= metal

		for(var/i=1, i <= generating_ore, i++)
			harvested++
			if(harvested >= harvest_speed)
				break
			generated_ore += new /obj/item/ore(src, metal)
		if(harvested >= harvest_speed)
			break

	if(!length(resources.resources))
		remove_extension(harvesting, /datum/extension/buried_resources)
		resource_field -= harvesting

/obj/machinery/mining/drill/proc/set_active(var/new_active)
	if(active != new_active)
		active = new_active
		update_use_power(active ? POWER_USE_ACTIVE : POWER_USE_OFF)

/obj/machinery/mining/drill/cannot_transition_to(state_path)
	if(active)
		return SPAN_NOTICE("You must turn \the [src] off first.")
	return ..()

/obj/machinery/mining/drill/components_are_accessible(path)
	return !active && ..()

/obj/machinery/mining/drill/physical_attack_hand(mob/user)
	check_supports()
	if(need_player_check)
		if(can_use_power_oneoff(10 KILOWATTS))
			system_error("insufficient charge")
		else if(anchored)
			get_resource_field()
		to_chat(user, "You hit the manual override and reset the drill's error checking.")
		need_player_check = 0
		update_icon()
		return TRUE
	if(supported && !panel_open)
		if(!(stat & NOPOWER))
			set_active(!active)
			if(active)
				visible_message("<span class='notice'>\The [src] lurches downwards, grinding noisily.</span>")
				need_update_field = 1
			else
				visible_message("<span class='notice'>\The [src] shudders to a grinding halt.</span>")
		else
			to_chat(user, "<span class='notice'>The drill is unpowered.</span>")
	else
		to_chat(user, "<span class='notice'>Turning on a piece of industrial machinery without sufficient bracing or wires exposed is a bad idea.</span>")

	update_icon()
	return TRUE

/obj/machinery/mining/drill/on_update_icon()
	if(need_player_check)
		icon_state = "mining_drill_error"
	else if(active)
		var/status = Clamp(round( (length(generated_ore) / capacity) * 4 ), 0, 3)
		icon_state = "mining_drill_active[status]"
	else if(supported)
		icon_state = "mining_drill_braced"
	else
		icon_state = "mining_drill"
	return

/obj/machinery/mining/drill/RefreshParts()
	..()
	harvest_speed = Clamp(total_component_rating_of_type(/obj/item/stock_parts/micro_laser), 0, 10)
	capacity = 200 * Clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 10)
	var/charge_multiplier = Clamp(total_component_rating_of_type(/obj/item/stock_parts/capacitor), 0.1, 10)
	change_power_consumption(initial(active_power_usage) / charge_multiplier, POWER_USE_ACTIVE)

/obj/machinery/mining/drill/proc/check_supports()

	anchored = initial(anchored)
	if(length(supports) <= 0)
		set_active(FALSE)
	else
		anchored = TRUE

	var/last_supported = supported
	supported = (length(supports) >= braces_needed)
	if(supported != last_supported && !supported && can_fall())
		fall()

	update_icon()

/obj/machinery/mining/drill/can_fall()
	. = (length(supports) <= 0)

/obj/machinery/mining/drill/proc/system_error(var/error)

	if(error)
		src.visible_message("<span class='notice'>\The [src] flashes a '[error]' warning.</span>")
	need_player_check = 1
	set_active(FALSE)
	update_icon()

/obj/machinery/mining/drill/proc/get_resource_field()

	resource_field = list()
	need_update_field = 0

	var/turf/T = get_turf(src)
	if(!istype(T)) return

	var/tx = T.x - 2
	var/ty = T.y - 2
	var/turf/mine_turf
	for(var/iy = 0,iy < 5, iy++)
		for(var/ix = 0, ix < 5, ix++)
			mine_turf = locate(tx + ix, ty + iy, T.z)
			if(mine_turf && has_extension(mine_turf, /datum/extension/buried_resources))
				resource_field += mine_turf

	if(!resource_field.len)
		system_error("resources depleted")

/obj/machinery/mining/drill/verb/unload()
	set name = "Unload Drill"
	set category = "Object"
	set src in oview(1)

	if(usr.stat) return

	var/obj/structure/ore_box/B = locate() in orange(1)
	if(B)
		for(var/obj/item/ore/O in generated_ore)
			O.forceMove(B)
		generated_ore.Cut()
		to_chat(usr, "<span class='notice'>You unload the drill's storage cache into the ore box.</span>")
	else
		to_chat(usr, "<span class='notice'>You must move an ore box up to the drill before you can unload it.</span>")


/obj/machinery/mining/brace
	name = "mining drill brace"
	desc = "A machinery brace for an industrial drill. It looks easily two feet thick."
	icon_state = "mining_brace"
	obj_flags = OBJ_FLAG_ROTATABLE
	interact_offline = 1

	var/obj/machinery/mining/drill/connected

/obj/machinery/mining/brace/cannot_transition_to(state_path)
	if(connected && connected.active)
		return SPAN_NOTICE("You can't work with the brace of a running drill!")
	return ..()

/obj/machinery/mining/brace/attackby(obj/item/W, mob/user)
	if(connected && connected.active)
		to_chat(user, "<span class='notice'>You can't work with the brace of a running drill!</span>")
		return TRUE
	if(component_attackby(W, user))
		return TRUE
	if(isWrench(W))

		if(isspaceturf(get_turf(src)))
			to_chat(user, "<span class='notice'>You can't anchor something to empty space. Idiot.</span>")
			return

		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "un" : ""]anchor the brace.</span>")

		anchored = !anchored
		if(anchored)
			connect()
		else
			disconnect()

/obj/machinery/mining/brace/proc/connect()

	var/turf/T = get_step(get_turf(src), src.dir)

	for(var/thing in T.contents)
		if(istype(thing, /obj/machinery/mining/drill))
			connected = thing
			break

	if(!connected)
		return

	if(!connected.supports)
		connected.supports = list()

	icon_state = "mining_brace_active"

	connected.supports += src
	connected.check_supports()

/obj/machinery/mining/brace/proc/disconnect()

	if(!connected) return

	if(!connected.supports) connected.supports = list()

	icon_state = "mining_brace"

	connected.supports -= src
	connected.check_supports()
	connected = null

/obj/machinery/mining/brace/dismantle()
	if(connected)
		disconnect()
	..()