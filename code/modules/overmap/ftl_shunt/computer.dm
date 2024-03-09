/obj/machinery/computer/ship/ftl
	name = "superluminal shunt control console"
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	light_color = "#77fff8"

	var/obj/machinery/ftl_shunt/core/linked_core
	var/plotting_jump = FALSE
	var/jump_plot_timer
	var/jump_plotted = FALSE
	var/to_plot_x = 1
	var/to_plot_y = 1

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
	var/obj/effect/overmap/visitable/sector = global.overmap_sectors[num2text(z)]
	if(!istype(sector))
		return INFINITY
	var/jump_dist = get_dist(linked, locate(linked_core.shunt_x, linked_core.shunt_y, sector.z))
	var/jump_cost = ((linked.vessel_mass * JOULES_PER_TON) / 1000) * jump_dist
	return jump_cost

/obj/machinery/computer/ship/ftl/proc/recalc_cost_power()
	if(!linked_core)
		return INFINITY

	var/obj/effect/overmap/visitable/sector = global.overmap_sectors[num2text(z)]
	if(!istype(sector))
		return INFINITY

	var/jump_dist = get_dist(linked, locate(linked_core.shunt_x, linked_core.shunt_y, sector.z))
	var/jump_cost = ((linked.vessel_mass * JOULES_PER_TON) / 1000) * jump_dist
	var/jump_cost_power = jump_cost * REQUIRED_CHARGE_MULTIPLIER
	return jump_cost_power

/obj/machinery/computer/ship/ftl/proc/get_status()
	if(is_jump_unsafe())
		return JUMP_STATUS_DANGEROUS
	if(plotting_jump)
		return JUMP_STATUS_PLOTTING
	if(jump_plotted == FALSE)
		return JUMP_STATUS_NO_PLOT
	else
		return JUMP_STATUS_SAFE

/obj/machinery/computer/ship/ftl/proc/is_jump_unsafe()
	. = FALSE
	var/datum/overmap/overmap = global.overmaps_by_name[overmap_id]
	var/dist = get_dist(locate(linked_core.shunt_x, linked_core.shunt_y, overmap.assigned_z), get_turf(linked))
	if(dist > linked_core.safe_jump_distance)
		. = TRUE

/obj/machinery/computer/ship/ftl/proc/plot_jump(var/x, var/y)
	var/datum/overmap/overmap = global.overmaps_by_name[overmap_id]
	var/jump_dist = get_dist(linked, locate(x, y, overmap.assigned_z))
	var/plot_delay_mult
	var/delay
	if(jump_dist < linked_core.safe_jump_distance)
		plot_delay_mult = 1
	else if(jump_dist < linked_core.moderate_jump_distance)
		plot_delay_mult = 1.5
	else
		plot_delay_mult = 2

	delay = clamp(((jump_dist * BASE_PLOT_TIME_PER_TILE) * plot_delay_mult),1, INFINITY)
	jump_plot_timer = addtimer(CALLBACK(src, PROC_REF(finish_plot), x, y), delay, TIMER_STOPPABLE)
	plotting_jump = TRUE
	jump_plotted = FALSE
	return delay

/obj/machinery/computer/ship/ftl/proc/finish_plot(var/x, var/y)
	linked_core.shunt_x = x
	linked_core.shunt_y = y
	linked_core.calculate_jump_requirements()
	plotting_jump = FALSE
	jump_plotted = TRUE
	jump_plot_timer = null
	ping("Jump plotting completed!")

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

	data["ftlstatus"] = linked_core.get_status()
	data["shunt_x"] = linked_core.shunt_x
	data["shunt_y"] = linked_core.shunt_y
	data["to_plot_x"] = to_plot_x
	data["to_plot_y"] = to_plot_y
	data["fuel_joules"] = (linked_core.get_fuel(linked_core.fuel_ports) / 1000)
	data["fuel_conversion"] = linked_core.get_total_fuel_conversion_rate()
	data["jumpcost"] = recalc_cost()
	data["powercost"] = recalc_cost_power()
	data["chargetime"] = linked_core.get_charge_time()
	data["chargepercent"] = linked_core.chargepercent
	data["maxfuel"] = linked_core.get_fuel_maximum(linked_core.fuel_ports)
	data["jump_status"] = get_status()
	data["power_input"] = linked_core.allowed_power_usage / 1000
	data["max_power"] = linked_core.max_power_usage / 1000
	data["max_charge"] = linked_core.max_charge / 1000
	data["target_charge"] = linked_core.target_charge / 1000
	data["charging"] = linked_core.charging



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
		if(plotting_jump)
			to_chat(user, SPAN_WARNING("Unable to alter programmed coordinates: Plotting in progress."))
			return TOPIC_REFRESH

		var/input_x = to_plot_x
		var/input_y = to_plot_y
		var/fumble = user.skill_check(SKILL_PILOT, SKILL_ADEPT) ? 0 : rand(-2, 2)

		var/datum/overmap/overmap = global.overmaps_by_name[overmap_id]
		if(href_list["set_shunt_x"])
			input_x = input(user, "Enter Destination X Coordinates", "FTL Computer", to_plot_x) as num|null
			input_x += fumble
			input_x = clamp(input_x, 1, overmap.map_size_x - 1)

		if(href_list["set_shunt_y"])
			input_y = input(user, "Enter Destination Y Coordinates", "FTL Computer", to_plot_y) as num|null
			input_y += fumble
			input_y = clamp(input_y, 1, overmap.map_size_y - 1)

		if(!CanInteract(user, state))
			return TOPIC_NOACTION
		if(fumble)
			to_chat(user, SPAN_WARNING("You fumble the input because of your inexperience!"))
		to_plot_x = input_x
		to_plot_y = input_y
		jump_plotted = FALSE
		return TOPIC_REFRESH

	if(href_list["start_shunt"])
		if(linked_core)
			if(linked_core.jump_timer)
				to_chat(user, SPAN_NOTICE("Superluminal jump warm-up in progress. Please wait for completion of jump!"))
				return TOPIC_REFRESH
			if(linked_core.get_status() != FTL_STATUS_GOOD)
				to_chat(user, SPAN_WARNING("Superluminal shunt inoperable. Please try again later."))
				return TOPIC_REFRESH

			var/datum/overmap/overmap = global.overmaps_by_name[overmap_id]
			var/dist = get_dist(locate(linked_core.shunt_x, linked_core.shunt_y, overmap.assigned_z), get_turf(linked))
			if(is_jump_unsafe()) //We are above the safe jump distance, give them a warning.
				var/warning = alert(user, "Current shunt distance is above safe distance! Do you wish to continue?","Jump Safety System", "Yes", "No")
				if(warning == "No" || !CanInteract(user, state))
					return TOPIC_REFRESH

			if(dist > linked_core.max_jump_distance)
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

	if(href_list["adjust_power"])
		var/input_power
		input_power = input(user, "Enter allowed power input (in kilowatts)", "FTL Computer", (linked_core.allowed_power_usage / 1000)) as num|null
		if(!input_power)
			return

		if(!CanInteract(user, state))
			return TOPIC_NOACTION

		input_power = input_power KILOWATTS
		linked_core.allowed_power_usage = clamp(input_power, 0, linked_core.max_power_usage)
		return TOPIC_REFRESH

	if(href_list["adjust_target"])
		var/target_joules
		target_joules = input(user, "Enter desired capacitor charge level (in megajoules)", "FTL Computer", (linked_core.target_charge / 1000)) as num|null
		if(!target_joules)
			return

		if(!CanInteract(user, state))
			return TOPIC_NOACTION

		target_joules = target_joules KILOWATTS
		linked_core.target_charge = clamp(target_joules, 0, linked_core.max_charge)
		return TOPIC_REFRESH

	if(href_list["toggle_charge"])
		linked_core.charging = !linked_core.charging

	if(href_list["plot_jump"])
		if(jump_plot_timer)
			return // already plotting a jump.
		var/jd = plot_jump(to_plot_x, to_plot_y)
		ping("Jump plotting initiated, ETA [jd/ (1 SECOND)] seconds.")

	if(href_list["cancel_plot"])
		if(jump_plot_timer)
			deltimer(jump_plot_timer)
			jump_plot_timer = null
			plotting_jump = FALSE
			ping("Jump plotting cancelled!")


