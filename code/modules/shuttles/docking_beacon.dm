#define MAX_DOCKING_SIZE 30
#define MAX_SHIP_TILES 	400
#define MAX_NAME_LENGTH  30

/obj/machinery/docking_beacon
	name = "magnetic docking beacon"
	desc = "A magnetic docking beacon that coordinates the movement of spacecraft into secure locations. It can additionally be used as a drydock for constructing shuttles."
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "injector0"
	density = TRUE
	anchored = FALSE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = NOPOWER
	base_type = /obj/machinery/docking_beacon
	obj_flags = OBJ_FLAG_ROTATABLE
	var/display_name					 // Display name of the docking beacon, editable on the docking control program.
	var/list/permitted_shuttles = list() // Shuttles that are always permitted by the docking beacon.

	var/locked = TRUE
	var/docking_by_codes = FALSE		 // Whether or not docking by code is permitted.
	var/docking_codes = 0				 // Required code for docking by code.
	var/docking_width = 10
	var/docking_height = 10
	var/projecting = FALSE

	var/construction_mode = FALSE		 // Whether or not the docking beacon is constructing a ship.
	var/ship_name = ""
	var/ship_color = COLOR_WHITE
	var/list/errors

/obj/machinery/docking_beacon/Initialize()
	. = ..()
	set_extension(src, /datum/extension/network_device)

	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)

	display_name = D.network_tag

	SSshuttle.docking_beacons += src

/obj/machinery/docking_beacon/Destroy()
	. = ..()

	SSshuttle.docking_beacons -= src
	permitted_shuttles.Cut()

/obj/machinery/docking_beacon/attackby(obj/item/I, mob/user)
	if(IS_WRENCH(I))
		if(!allowed(user))
			to_chat(user, SPAN_WARNING("The bolts on \the [src] are locked!"))
			return
		playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, SPAN_NOTICE("You [anchored ? "unanchor" : "anchor"] \the [src]."))
		anchored = !anchored
		return

	. = ..()

/obj/machinery/docking_beacon/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/docking_beacon/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, datum/topic_state/state = global.default_topic_state)
	var/list/data = list()
	data["size"] = "[docking_width] x [docking_height]"
	data["locked"] = locked
	data["display_name"] = display_name
	data["allow_codes"] = docking_by_codes
	if(allowed(user))
		data["permitted"] = permitted_shuttles
		data["codes"] = docking_codes
	else
		data["permitted"] = list("ACCESS DENIED")
		data["codes"] = "*******"

	data["construction_mode"] = construction_mode
	data["errors"] = errors
	data["ship_name"] = ship_name
	data["ship_color"] = ship_color

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui = new(user, src, ui_key, "docking_beacon.tmpl", "Docking Beacon Settings", 540, 400, state = state)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/docking_beacon/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return

	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)

	if(href_list["edit_codes"])
		var/newcode = sanitize(input("Input new docking codes:", "Docking codes", docking_codes) as text|null)
		if(!CanInteract(usr,state))
			return TOPIC_NOACTION
		if(newcode)
			docking_codes = uppertext(newcode)
			D?.add_log("Docking codes of Docking Beacon [display_name] were changed.")
			return TOPIC_REFRESH

	if(href_list["edit_display_name"])
		var/newname = sanitize(input("Input new display name:", "Display name", display_name) as text|null)
		if(!CanInteract(usr,state))
			return TOPIC_NOACTION
		if(newname)
			display_name = newname
			D?.add_log("Display name of Docking Beacon [display_name] was changed to [newname].")
			return TOPIC_REFRESH
		return TOPIC_HANDLED

	if(href_list["edit_size"])
		var/newwidth = input("Input new docking width for beacon:", "Docking size", docking_width) as num|null
		var/newheight = input("Input new docking height for beacon:", "Docking size", docking_height) as num|null
		if(!CanInteract(usr,state))
			return TOPIC_NOACTION
		if(newwidth && newheight)
			docking_width = clamp(newwidth, 0, MAX_DOCKING_SIZE)
			docking_height = clamp(newheight, 0, MAX_DOCKING_SIZE)
			D?.add_log("Docking size of Docking Beacon [display_name] was changed to [newwidth], [newheight].")
			return TOPIC_REFRESH
		return TOPIC_HANDLED

	if(href_list["toggle_lock"])
		locked = !locked
		D?.add_log("Docking was [locked ? "locked" : "unlocked"] for Docking Beacon [display_name].")
		return TOPIC_REFRESH

	if(href_list["toggle_codes"])
		docking_by_codes = !docking_by_codes
		D?.add_log("Docking by codes was [docking_by_codes ? "enabled" : "disabled"] for Docking Beacon [display_name].")
		return TOPIC_REFRESH

	if(href_list["edit_permitted_shuttles"])
		var/shuttle = sanitize(input(usr,"Enter the ID of the shuttle you wish to permit/unpermit for this beacon:", "Enter ID") as text|null)
		if(shuttle)
			if(shuttle in permitted_shuttles)
				permitted_shuttles -= shuttle
				D?.add_log("Docking Beacon [display_name] had [shuttle] removed from its permitted shuttle list.")
				return TOPIC_REFRESH
			else if(shuttle in SSshuttle.shuttles)
				permitted_shuttles += shuttle
				D?.add_log("Docking Beacon [display_name] had [shuttle] added to its permitted shuttle list.")
				return TOPIC_REFRESH
		return TOPIC_HANDLED

	if(href_list["project"])
		if(projecting)
			return
		visible_message(SPAN_NOTICE("\The [src] projects a hologram of its effective landing area."))
		for(var/turf/T in get_turfs())
			new /obj/effect/temporary(T, 5 SECONDS,'icons/effects/alphacolors.dmi', "green")
			projecting = TRUE
			addtimer(CALLBACK(src, PROC_REF(allow_projection)), 10 SECONDS) // No spamming holograms.

	if(href_list["settings"])
		D.ui_interact(user)
		return TOPIC_HANDLED

	if(href_list["toggle_construction"])
		construction_mode = !construction_mode
		LAZYCLEARLIST(errors)
		return TOPIC_REFRESH

	if(href_list["change_color"])
		var/new_color = input(user, "Choose a color.", "\the [src]", ship_color) as color|null
		if(!CanInteract(usr,state))
			return TOPIC_NOACTION
		if(new_color && new_color != ship_color)
			ship_color = new_color
			to_chat(user, SPAN_NOTICE("You set \the [src] to create a ship with <font color='[ship_color]'>this color</font>."))
			return TOPIC_HANDLED

	if(href_list["change_ship_name"])
		var/new_ship_name = sanitize(input(user, "Enter a new name for the ship:", "Change ship name.") as null|text)
		if(!CanInteract(usr,state))
			return TOPIC_NOACTION
		if(!new_ship_name)
			return TOPIC_HANDLED
		if(length(new_ship_name) > MAX_NAME_LENGTH)
			to_chat(user, SPAN_WARNING("That name is too long!"))
			return TOPIC_HANDLED
		ship_name = new_ship_name
		return TOPIC_REFRESH

	if(href_list["check_validity"])
		if(!construction_mode)
			return TOPIC_HANDLED
		check_ship_validity(get_areas())
		return TOPIC_REFRESH

	if(href_list["finalize"])
		if(!construction_mode)
			return TOPIC_HANDLED
		var/confirm = alert(user, "This will permanently finalize the ship, are you sure?", "Ship finalization", "No", "Yes")
		if(!CanInteract(usr,state))
			return TOPIC_NOACTION
		if(confirm == "Yes")
			if(create_ship())
				construction_mode = FALSE
				ship_name = ""
				LAZYCLEARLIST(errors)
			else
				to_chat(usr, SPAN_WARNING("Could not finalize the construction of the ship!"))
		return TOPIC_REFRESH

/obj/machinery/docking_beacon/proc/allow_projection()
	projecting = FALSE

/obj/machinery/docking_beacon/proc/check_permission(var/shuttle_tag, var/codes)
	. = FALSE
	if(construction_mode)
		return
	if(!locked)
		return TRUE
	if(docking_by_codes && docking_codes == codes)
		return TRUE
	if(shuttle_tag in permitted_shuttles)
		return TRUE

/obj/machinery/docking_beacon/proc/get_turfs()
	switch(dir)
		if(NORTH)
			return block(x-((docking_width-1)/2), y+docking_height+1, z, x+((docking_width-1)/2), y+1, z)
		if(SOUTH)
			return block(x-((docking_width-1)/2), y-docking_height-1, z, x+((docking_width-1)/2), y-1, z)
		if(EAST)
			return block(x+docking_height+1, y-((docking_width-1)/2), z, x+1, y+((docking_width-1)/2), z)
		if(WEST)
			return block(x-docking_height-1, y-((docking_width-1)/2), z, x-1, y+((docking_width-1)/2), z)

/obj/machinery/docking_beacon/proc/get_areas()
	. = list()
	for(var/turf/T in get_turfs())
		var/area/A = T.loc
		// Ignore space or other background areas.
		if(A.area_flags & AREA_FLAG_IS_BACKGROUND)
			continue
		if(A in SSshuttle.shuttle_areas)
			continue
		. |= A

/obj/machinery/docking_beacon/proc/check_ship_validity(var/list/target_areas)
	LAZYCLEARLIST(errors)
	. = TRUE
	if(!ship_name || length(ship_name) < 5)
		LAZYDISTINCTADD(errors, "The ship must have a name.")
		. = FALSE
	else
		// Check if another ship/shuttle has an identical name.
		for(var/shuttle_tag in SSshuttle.shuttles)
			if(ship_name == shuttle_tag)
				LAZYDISTINCTADD(errors, "A ship with an identical name has already been registered.")
				. = FALSE
				break
	if(!length(target_areas))
		LAZYDISTINCTADD(errors, "The ship must have defined areas in the construction zone.")
		return FALSE
	var/list/area_turfs = list()
	for(var/area/A in target_areas)
		for(var/turf/T in A)
			area_turfs |= T
			if(length(area_turfs) > MAX_SHIP_TILES)
				LAZYDISTINCTADD(errors, "The ship is too large.")
				return FALSE // If the ship is too large, skip contiguity checks.

	// Check to make sure all the ships areas are connected.
	. = min(., check_contiguity(area_turfs))
	if(.)
		LAZYDISTINCTADD(errors, "The ship is valid for finalization.")

/obj/machinery/docking_beacon/proc/check_contiguity(var/list/area_turfs)
	if(!area_turfs || !LAZYLEN(area_turfs))
		return FALSE
	var/turf/start_turf = pick(area_turfs) // The last added area is the most likely to be incontiguous.
	var/list/pending_turfs = list(start_turf)
	var/list/checked_turfs = list()

	while(pending_turfs.len)
		var/turf/T = pending_turfs[1]
		pending_turfs -= T
		for(var/dir in global.cardinal)	// Floodfill to find all turfs contiguous with the randomly chosen start_turf.
			var/turf/NT = get_step(T, dir)
			if(!isturf(NT) || !(NT in area_turfs) || (NT in pending_turfs) || (NT in checked_turfs))
				continue
			pending_turfs += NT

		checked_turfs += T

	if(LAZYLEN(area_turfs.Copy()) - LAZYLEN(checked_turfs)) // If there are turfs in area_turfs, not in checked_turfs there are non-contiguous turfs in the selection.
		LAZYDISTINCTADD(errors, "The ship construction is not contiguous.")
		return FALSE
	return TRUE

/obj/machinery/docking_beacon/proc/create_ship()
	var/list/shuttle_areas = get_areas()
	// Double check to ensure the ship is valid.
	if(!check_ship_validity(shuttle_areas))
		return FALSE


	// Locate the base area by stepping towards the edge of the map in the direction the beacon is facing.
	var/area/base_area
	var/turf/area_turf = get_step(src, dir)

	while(area_turf)
		var/area/A = area_turf.loc
		if(A && (A.area_flags & AREA_FLAG_IS_BACKGROUND))
			base_area = A
			break
		area_turf = get_step(area_turf, dir)

	// Otherwise, use the level or world area.
	if(!base_area)
		var/datum/level_data/LD = SSmapping.levels_by_z[z]
		if(istype(LD))
			base_area = LD.get_base_area_instance()
		else
			base_area = locate(world.area)

	var/turf/center_turf
	switch(dir)
		if(NORTH)
			center_turf = locate(x, (y+docking_height/2)+1, z)
		if(SOUTH)
			center_turf = locate(x, (y-docking_height/2)-1, z)
		if(EAST)
			center_turf = locate(x+(docking_height/2)+1, y, z)
		if(WEST)
			center_turf = locate(x-(docking_height/2)-1, y, z)
	if(!center_turf)
		return FALSE
	var/obj/effect/shuttle_landmark/temporary/construction/landmark = new(get_turf(src), base_area, get_base_turf(z))
	var/list/shuttle_args = list(landmark, shuttle_areas.Copy(), ship_name)
	SSshuttle.initialize_shuttle(/datum/shuttle/autodock/overmap/created, null, shuttle_args)

	new /obj/effect/overmap/visitable/ship/landable/created(get_turf(src), ship_name, ship_color, global.reverse_dir[dir])
	permitted_shuttles |= ship_name
	return TRUE

/obj/effect/shuttle_landmark/temporary/construction
	flags = 0

/obj/effect/shuttle_landmark/temporary/construction/Initialize(var/mapload, var/area/b_area, var/turf/b_turf)
	base_area = b_area
	base_turf = b_turf
	. = ..(mapload)

#undef MAX_DOCKING_SIZE
#undef MAX_SHIP_TILES
#undef MAX_NAME_LENGTH