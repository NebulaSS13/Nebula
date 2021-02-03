/obj/machinery/computer/ship/ftl
	name = "shunt drive control console"
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	light_color = "#77fff8"
	var/obj/machinery/ftl_shunt/core/linked_core

/obj/machinery/computer/ship/ftl/Initialize()
	. = ..()
	find_core()

/obj/machinery/computer/ship/ftl/proc/find_core()
	if(!linked)
		return

	for(var/obj/machinery/ftl_shunt/core/C in world)
		if(C.z in linked.map_z)
			linked_core = C
			C.ftl_computer = src

/obj/machinery/computer/ship/ftl/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		display_reconnect_dialog(user, "ftl management system")
		return

	var/data[0]

	if(!linked_core)
		find_core()
		return

	data["ftlstatus"] = linked_core.get_status()
	data["shunt_x"] = linked_core.shunt_x
	data["shunt_y"] = linked_core.shunt_y
	data["fuel_joules"] = (linked_core.get_fuel(linked_core.fuel_ports) / 1000)
	data["fuel_joules_bar"] = linked_core.fuelpercentage()
	data["jumpcost"] = ((linked.vessel_mass * JOULES_PER_TON) / 1000)
	data["chargetime"] = round((linked_core.get_charge_time() / 600))
	data["maxfuel"] = linked_core.get_fuel_maximum(linked_core.fuel_ports)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ftl_computer.tmpl", "[linked.name] Shunt Drive Control", 420, 530, src)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/ftl/OnTopic(var/mob/user, var/list/href_list, state)
	if(..())
		return TOPIC_HANDLED

	if (!linked)
		return TOPIC_NOACTION

	if(href_list["set_shunt_x"])
		if(linked_core)
			var/input_x = input(user, "Enter Destination X Coordinates", "FTL Computer", linked_core.shunt_x) as num|null
			if(input_x >= GLOB.using_map.overmap_size)
				to_chat(user, SPAN_WARNING("Input invalid. Must be between 0 and [GLOB.using_map.overmap_size - 1]."))
			else
				linked_core.shunt_x = input_x
			return TOPIC_REFRESH

	if(href_list["set_shunt_y"])
		if(linked_core)
			var/input_y = input(user, "Enter Destination Y Coordinates", "FTL Computer", linked_core.shunt_y) as num|null
			if(input_y >= GLOB.using_map.overmap_size)
				to_chat(user, SPAN_WARNING("Input invalid. Must be between 0 and [GLOB.using_map.overmap_size - 1]."))
			else
				linked_core.shunt_y = input_y
			return TOPIC_REFRESH

	if(href_list["start_shunt"])
		if(linked_core)
			if(linked_core.get_status() != FTL_STATUS_GOOD)
				to_chat(user, SPAN_WARNING("Shunt drive inoperable. Please try again later."))
				return TOPIC_REFRESH

			var/dist = get_dist(locate(linked_core.shunt_x, linked_core.shunt_y, GLOB.using_map.overmap_z), get_turf(linked))
			if(dist > 3) //We are above the safe jump distance, give them a warning.
				var/warning = alert(user, "Current shunt distance is above safe distance! Do you wish to continue?","Jump Safety System", "Yes", "No")
				if(warning == "No")
					return TOPIC_REFRESH

			if(dist >= linked_core.max_jump_distance)
				to_chat(user, SPAN_WARNING("Shunt aborted:Selected jump coordinates beyond maximum range."))
				return TOPIC_REFRESH


			var/feedback = linked_core.start_shunt()
			switch(feedback)
				if(FTL_START_FAILURE_FUEL)
					to_chat(user, SPAN_WARNING("Shunt drive inoperable: verify fuel levels."))
				if(FTL_START_FAILURE_POWER)
					to_chat(user, SPAN_WARNING("Shunt drive inoperable: verify primary power."))
				if(FTL_START_FAILURE_BROKEN)
					to_chat(user, SPAN_WARNING("Shunt drive inoperable: safety interlocks engaged."))
				if(FTL_START_FAILURE_COOLDOWN)
					to_chat(user, SPAN_WARNING("Shunt drive inoperable: cooldown interlocks engaged."))
				if(FTL_START_FAILURE_OTHER)
					to_chat(user, SPAN_WARNING("Shunt drive inoperable: unknown error."))
				if(FTL_START_CONFIRMED)
					to_chat(user, SPAN_WARNING("Shunt drive operational: spooling up."))
			return TOPIC_REFRESH

	if(href_list["cancel_shunt"])
		if(linked_core)
			var/warning = alert(user, "Cancel current shunt?","Jump Safety System", "Yes", "No")
			if(warning == "Yes")
				linked_core.cancel_shunt()
		return TOPIC_REFRESH

