/obj/machinery/computer/ship/comms
	name = "ship communication console"
	icon_keyboard = "generic_key"
	icon_screen = "helm"
	light_color = "#7faaff"
	core_skill = SKILL_DEVICES

// TODO: add enabling or disabling comms transponder to hide transmission location
// TODO: use comms console to target a specific entity with a specific maser rather than targetting everyone in range
/obj/machinery/computer/ship/comms/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(!linked)
		display_reconnect_dialog(user, "Communication")
		return

	var/data[0]

	var/list/printing_entities = list()
	var/list/entities = list()
	var/list/broadcasters = list()
	var/list/receivers = list()

	for(var/obj/machinery/shipcomms/comms in linked.comms_masers)
		var/functional = !(comms.stat & (BROKEN|NOPOWER))
		broadcasters += list(list(
			"name" = comms.name,
			"coords" = "[comms.x],[comms.y],[comms.z]",
			"desc" = (functional ? "active" : "inactive")
		))
		if(functional)
			for(var/obj/effect/overmap/entity in comms.get_nearby_entities())
				if(entity == linked)
					continue
				if(entity in printing_entities)
					continue
				printing_entities += entity
				var/has_receiver = FALSE
				for(var/obj/machinery/shipcomms/receiver/antenna in entity.comms_antennae)
					if(!(antenna.stat & (BROKEN|NOPOWER)))
						has_receiver = TRUE
				if(!has_receiver)
					continue
				var/has_broadcaster = FALSE
				for(var/obj/machinery/shipcomms/broadcaster/maser in entity.comms_masers)
					if(!(maser.stat & (BROKEN|NOPOWER)))
						has_broadcaster = TRUE
				entities += list(list(
					"name" = entity.name,
					"coords" = "[entity.x],[entity.y]",
					"desc" = entity.desc,
					"status" = ((has_broadcaster && has_receiver) ? "Responding to comms pings." : "Not responding to comms pings.")
				))

	for(var/obj/machinery/shipcomms/comms in linked.comms_antennae)
		receivers += list(list(
			"name" = comms.name,
			"coords" = "[comms.x],[comms.y],[comms.z]",
			"desc" = ((comms.stat & (BROKEN|NOPOWER)) ? "inactive" : "active")
		))

	if(!length(entities))
		entities += list(list(
			"name" = "None.",
			"coords" = "-,-",
			"desc" = "-",
			"status" = "No local entities responding to comms ping."
		))
	if(!length(broadcasters))
		broadcasters += list(list(
			"name" = "None.",
			"coords" = "-,-,-",
			"desc" = "No broadcasters available."
		))
	if(!length(receivers))
		receivers += list(list(
			"name" = "None.",
			"coords" = "-,-,-",
			"desc" = "No receivers available."
		))

	data["allow_ident_change"] = linked.can_switch_ident
	data["ident_enabled"] =      linked.ident_transmitter

	data["entities"] =     entities
	data["broadcasters"] = broadcasters
	data["receivers"] =    receivers

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "shipcomms.tmpl", "[linked.name] Communication Screen", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/comms/OnTopic(var/mob/user, var/list/href_list)
	if(..())
		return TOPIC_HANDLED
	if (!linked)
		return TOPIC_NOACTION
	if(href_list["toggle_comms_visibility"])
		if(linked.can_switch_ident)
			linked.ident_transmitter = !linked.ident_transmitter
			. = TOPIC_REFRESH

/obj/machinery/shipcomms
	density = TRUE
	anchored = TRUE
	idle_power_usage = 1000
	req_access = list(access_tcomsat)
	icon = 'icons/obj/machines/tcomms/comms.dmi'
	var/effective_range = 1 // TODO: upgrade with components.
	var/enabled = TRUE

/obj/machinery/shipcomms/proc/toggle()
	if((stat & BROKEN) || use_power != POWER_USE_OFF)
		update_use_power(POWER_USE_OFF)
	else
		update_use_power(POWER_USE_IDLE)

/obj/machinery/shipcomms/proc/refresh_overmap_registration()
	var/turf/T = get_turf(src)
	if(!T)
		return
	var/obj/effect/overmap/O = global.overmap_sectors["[z]"]
	if(!O)
		return
	if(stat & (BROKEN|NOPOWER))
		unregister(O)
	else
		register(O)

/obj/machinery/shipcomms/Initialize()
	..()
	. = INITIALIZE_HINT_LATELOAD

/obj/machinery/shipcomms/proc/register(var/obj/effect/overmap/O)
	return

/obj/machinery/shipcomms/proc/unregister(var/obj/effect/overmap/O)
	return

/obj/machinery/shipcomms/proc/get_nearby_entities()
	. = list()
	var/obj/effect/overmap/O = global.overmap_sectors["[z]"]
	if(!O)
		return
	var/turf/origin = get_turf(O)
	if(!origin)
		return
	for(var/turf/T in RANGE_TURFS(origin, effective_range))
		for(var/obj/effect/overmap/other in get_turf(T))
			. |= other

/obj/machinery/shipcomms/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(!. && href_list["toggle"])
		toggle()
		. = TOPIC_HANDLED

/obj/machinery/shipcomms/LateInitialize()
	. = ..()
	refresh_overmap_registration()

/obj/machinery/shipcomms/power_change()
	. = ..()
	if(.)
		refresh_overmap_registration()

/obj/machinery/shipcomms/set_broken(new_state, cause)
	. = ..()
	if(.)
		refresh_overmap_registration()

/obj/machinery/shipcomms/Destroy()
	var/turf/T = get_turf(src)
	if(istype(T))
		var/obj/effect/overmap/O = global.overmap_sectors["[T.z]"]
		if(O)
			unregister(O)
	. = ..()

/obj/machinery/shipcomms/update_power_on_move(atom/movable/mover, atom/old_loc, atom/new_loc)
	..()
	if(istype(old_loc) && old_loc != new_loc && (!istype(new_loc) || new_loc.z != old_loc.z))
		var/obj/effect/overmap/lastsector = global.overmap_sectors["[old_loc.z]"]
		var/obj/effect/overmap/currentsector = istype(new_loc) && global.overmap_sectors["[new_loc.z]"]
		if(istype(lastsector) && lastsector != currentsector)
			unregister(lastsector.comms_masers)
		refresh_overmap_registration()

/obj/machinery/shipcomms/proc/get_available_z_levels()
	. = list()

/obj/machinery/shipcomms/proc/has_clear_adjacent_turf()
	var/turf/T = loc
	if(!istype(T))
		return FALSE
	for(var/turf/neighbor in RANGE_TURFS(T, 1))
		if(istype(neighbor, /turf/space) || istype(neighbor, /turf/exterior))
			return TRUE
	return FALSE

/obj/machinery/shipcomms/on_update_icon()
	cut_overlays()
	if(stat & (BROKEN|NOPOWER))
		set_light(0)
	else
		var/image/I = emissive_overlay(icon, "[icon_state]_on")
		I.color = COLOR_CYAN
		add_overlay(I)
		set_light(0.8, 1, 6, l_color = COLOR_CYAN)

/obj/machinery/shipcomms/broadcaster
	name = "communications maser"
	desc = "A large maser emitter intended for tight-beam inter-ship communication."
	icon_state = "maser"
	construct_state = /decl/machine_construction/default/panel_closed
	base_type = /obj/machinery/shipcomms/broadcaster

/obj/machinery/shipcomms/broadcaster/register(var/obj/effect/overmap/O)
	LAZYDISTINCTADD(O.comms_masers, src)

/obj/machinery/shipcomms/broadcaster/unregister(var/obj/effect/overmap/O)
	LAZYREMOVE(O.comms_masers, src)

/obj/machinery/shipcomms/broadcaster/get_available_z_levels()
	. = ..()
	if(!(stat & (BROKEN|NOPOWER)) && has_clear_adjacent_turf())
		for(var/obj/effect/overmap/other in get_nearby_entities())
			for(var/obj/machinery/shipcomms/receiver/antenna in other.comms_antennae)
				. |= antenna.get_available_z_levels()

/obj/machinery/shipcomms/receiver
	name = "communications antenna"
	desc = "A tall antenna designed to receive comms maser bursts from nearby ships or stations."
	icon_state = "antenna"
	construct_state = /decl/machine_construction/default/panel_closed
	base_type = /obj/machinery/shipcomms/receiver

/obj/machinery/shipcomms/receiver/register(var/obj/effect/overmap/O)
	LAZYDISTINCTADD(O.comms_antennae, src)

/obj/machinery/shipcomms/receiver/unregister(var/obj/effect/overmap/O)
	LAZYREMOVE(O.comms_antennae, src)

/obj/machinery/shipcomms/receiver/get_available_z_levels()
	. = ..()
	if(!(stat & (BROKEN|NOPOWER)) && has_clear_adjacent_turf())
		. = SSmapping.get_connected_levels(z)