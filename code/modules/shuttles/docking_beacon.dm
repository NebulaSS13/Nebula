#define MAX_DOCKING_SIZE 30

/obj/machinery/docking_beacon
	name = "magnetic docking beacon"
	desc = "A magnetic docking beacon that coordinates the movement of spacecraft into secure locations."
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "injector0"
	density = 1
	anchored = FALSE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = NOPOWER
	base_type = /obj/machinery/docking_beacon
	var/display_name					 // Display name of the docking beacon, editable on the docking control program.
	var/list/permitted_shuttles = list() // Shuttles that are always permitted by the docking beacon.
	
	var/locked = TRUE
	var/docking_by_codes = FALSE		 // Whether or not docking by code is permitted.
	var/docking_codes = 0				 // Required code for docking by code.
	var/docking_width = 10
	var/docking_height = 10
	var/projecting = FALSE

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
	if(isWrench(I))
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

/obj/machinery/docking_beacon/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, datum/topic_state/state = GLOB.default_state)
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
			docking_width = Clamp(newwidth, 0, MAX_DOCKING_SIZE)
			docking_height = Clamp(newheight, 0, MAX_DOCKING_SIZE)
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
		for(var/turf/T in get_area())
			new /obj/effect/temporary(T, 5 SECONDS,'icons/effects/alphacolors.dmi', "green")
			projecting = TRUE
			addtimer(CALLBACK(src, .proc/allow_projection), 10 SECONDS) // No spamming holograms.

	if(href_list["settings"])
		D.ui_interact(user)
		return TOPIC_HANDLED

/obj/machinery/docking_beacon/proc/allow_projection()
	projecting = FALSE

/obj/machinery/docking_beacon/proc/check_permission(var/shuttle_tag, var/codes)
	. = FALSE
	if(!locked)
		return TRUE
	if(docking_by_codes && docking_codes == codes)
		return TRUE
	if(shuttle_tag in permitted_shuttles)
		return TRUE

/obj/machinery/docking_beacon/proc/get_area()
	switch(dir)
		if(NORTH)
			return block(locate(x-((docking_width-1)/2), y+docking_height+1, z), locate(x+((docking_width-1)/2), y+1, z))
		if(SOUTH)
			return block(locate(x-((docking_width-1)/2), y-docking_height-1, z), locate(x+((docking_width-1)/2), y-1, z))
		if(EAST)
			return block(locate(x+docking_height+1, y-((docking_width-1)/2), z), locate(x+1, y+((docking_width-1)/2), z))
		if(WEST)
			return block(locate(x-docking_height-1, y-((docking_width-1)/2), z), locate(x-1, y+((docking_width-1)/2), z))

#undef MAX_DOCKING_SIZE