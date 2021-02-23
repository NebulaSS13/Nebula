/obj/machinery/computer/ship/ftl
	name = "superluminal shunt control console"
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	light_color = "#77fff8"
	var/obj/machinery/ftl_shunt/core/linked_core
	var/cost = 0

/obj/machinery/computer/ship/ftl/Initialize()
	. = ..()
	find_core()

/obj/machinery/computer/ship/ftl/Destroy()
	. = ..()
	if(linked_core)
		linked_core.ftl_computer = null
		linked_core = null

/obj/machinery/computer/ship/ftl/proc/recalc_cost()
	if(!linked_core)
		return INFINITY
	var/jump_dist = get_dist(linked, locate(linked_core.shunt_x, linked_core.shunt_y, GLOB.using_map.overmap_z))
	var/jump_cost = ((linked.vessel_mass * JOULES_PER_TON) / 1000) * jump_dist
	return jump_cost

/obj/machinery/computer/ship/ftl/proc/find_core()
	if(!linked)
		return

	if(linked_core)
		linked_core.ftl_computer = null
		linked_core = null

	for(var/obj/machinery/ftl_shunt/core/C in SSmachines.machinery)
		if(C.z in linked.map_z)
			linked_core = C
			C.ftl_computer = src
			break

/obj/machinery/computer/ship/ftl/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		display_reconnect_dialog(user, "superluminal shunt management system")
		return

	var/data[0]

	if(!linked_core)
		find_core()
		if(!linked_core)
			to_chat(user, SPAN_WARNING("Unable to establish connection to superluminal shunt."))
			return
	recalc_cost()

	data["ftlstatus"] = linked_core.get_status()
	data["shunt_x"] = linked_core.shunt_x
	data["shunt_y"] = linked_core.shunt_y
	data["fuel_joules"] = (linked_core.get_fuel(linked_core.fuel_ports) / 1000)
	data["jumpcost"] = recalc_cost()
	data["chargetime"] = round((linked_core.get_charge_time() / 600))
	data["chargepercent"] = linked_core.chargepercent
	data["maxfuel"] = linked_core.get_fuel_maximum(linked_core.fuel_ports)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ftl_computer.tmpl", "[linked.name] Superluminal Shunt Control", 420, 530, src)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/ftl/OnTopic(var/mob/user, var/list/href_list, state)
	. = ..()
	if(.)
		return

	if (!linked)
		return TOPIC_NOACTION

	if(href_list["set_shunt_x"] || href_list["set_shunt_y"])
		if(!linked_core)
			return TOPIC_NOACTION

		var/input_x = linked_core.shunt_x
		var/input_y = linked_core.shunt_y
		var/fumble = user.skill_check(SKILL_PILOT, SKILL_ADEPT) ? 0 : rand(-2, 2)

		if(href_list["set_shunt_x"])
			input_x = input(user, "Enter Destination X Coordinates", "FTL Computer", input_x) as num|null
			input_x += fumble
			input_x = Clamp(input_x, 1, GLOB.using_map.overmap_size - 1)

		if(href_list["set_shunt_y"])
			input_y = input(user, "Enter Destination Y Coordinates", "FTL Computer", input_y) as num|null
			input_y += fumble
			input_y = Clamp(input_y, 1, GLOB.using_map.overmap_size - 1)

		if(!CanInteract(user, state))
			return TOPIC_NOACTION
		if(fumble)
			to_chat(user, SPAN_WARNING("You fumble the input because of your inexperience!"))
		linked_core.shunt_x = input_x
		linked_core.shunt_y = input_y
		return TOPIC_REFRESH

	if(href_list["start_shunt"])
		if(linked_core)
			if(linked_core.charging)
				to_chat(user, SPAN_NOTICE("Superluminal jump charge in progress. Please wait for completion of jump!"))
				return TOPIC_REFRESH
			if(linked_core.get_status() != FTL_STATUS_GOOD)
				to_chat(user, SPAN_WARNING("Superluminal shunt inoperable. Please try again later."))
				return TOPIC_REFRESH

			var/dist = get_dist(locate(linked_core.shunt_x, linked_core.shunt_y, GLOB.using_map.overmap_z), get_turf(linked))
			if(dist > 3) //We are above the safe jump distance, give them a warning.
				var/warning = alert(user, "Current shunt distance is above safe distance! Do you wish to continue?","Jump Safety System", "Yes", "No")
				if(warning == "No" || !CanInteract(user, state))
					return TOPIC_REFRESH

			if(dist >= linked_core.max_jump_distance)
				to_chat(user, SPAN_WARNING("Shunt aborted: Selected jump coordinates beyond maximum range."))
				return TOPIC_REFRESH


			var/feedback = linked_core.start_shunt()
			switch(feedback)
				if(FTL_START_FAILURE_FUEL)
					to_chat(user, SPAN_WARNING("Superluminal shunt inoperable: verify fuel levels."))
				if(FTL_START_FAILURE_POWER)
					to_chat(user, SPAN_WARNING("Superluminal shunt inoperable: verify primary power."))
				if(FTL_START_FAILURE_BROKEN)
					to_chat(user, SPAN_WARNING("Superluminal shunt inoperable: safety interlocks engaged."))
				if(FTL_START_FAILURE_COOLDOWN)
					to_chat(user, SPAN_WARNING("Superluminal shunt inoperable: cooldown interlocks engaged."))
				if(FTL_START_FAILURE_OTHER)
					to_chat(user, SPAN_WARNING("Superluminal shunt inoperable: unknown error."))
				if(FTL_START_CONFIRMED)
					to_chat(user, SPAN_NOTICE("Superluminal shunt operational: spooling up."))
			return TOPIC_REFRESH

	if(href_list["cancel_shunt"])
		if(linked_core)
			var/warning = alert(user, "Cancel current shunt?","Jump Safety System", "Yes", "No")
			if(warning == "Yes" && CanInteract(user, state))
				linked_core.cancel_shunt(FALSE)
			else
				return TOPIC_REFRESH
		return TOPIC_REFRESH

