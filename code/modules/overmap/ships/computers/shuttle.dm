//Shuttle controller computer for shuttles going between sectors
/obj/machinery/computer/shuttle_control/explore
	name = "general shuttle control console"
	ui_template = "shuttle_control_console_exploration.tmpl"
	base_type = /obj/machinery/computer/shuttle_control/explore

/obj/machinery/computer/shuttle_control/explore/Initialize()
	. = ..()
	set_extension(src, /datum/extension/eye/landing)

/obj/machinery/computer/shuttle_control/explore/get_ui_data(var/datum/shuttle/autodock/overmap/shuttle)
	. = ..()
	if(istype(shuttle))
		var/delta_v
		var/delta_v_budget

		var/obj/effect/overmap/visitable/ship/ship = SSshuttle.get_ship_by_shuttle(shuttle)
		if(istype(ship))
			delta_v = ship.get_delta_v()
			delta_v_budget = ship.get_delta_v_budget(shuttle.next_location)

		var/fuel_span = "good"
		if(delta_v < delta_v_budget * 1.4)
			fuel_span = "bad"

		. += list(
			"destination_name" = shuttle.get_destination_name(),
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
			"delta_v_budget" = delta_v_budget,
			"delta_v" = delta_v,
			"total_delta_v" = delta_v * 10,
			"fuel_span" = fuel_span,
			"is_ship" = istype(ship)
		)

/obj/machinery/computer/shuttle_control/explore/handle_topic_href(var/datum/shuttle/autodock/overmap/shuttle, var/list/href_list, var/mob/user)
	shuttle.operator_skill = user.get_skill_value(SKILL_PILOT)

	if((. = ..()) != null)
		return

	if(href_list["pick"])
		var/list/possible_d = shuttle.get_possible_destinations()
		var/D
		if(possible_d.len)
			D = input("Choose shuttle destination", "Shuttle Destination") as null|anything in possible_d
		else
			to_chat(usr, SPAN_WARNING("No valid landing sites in range."))
		possible_d = shuttle.get_possible_destinations()
		if(CanInteract(usr, GLOB.default_state) && (D in possible_d))
			shuttle.set_destination(possible_d[D])
		return TOPIC_REFRESH
	if(href_list["manual_landing"])
		var/datum/extension/eye/landing_eye = get_extension(src, /datum/extension/eye)
		if(!landing_eye)
			to_chat(user, SPAN_WARNING("Could not begin landing procedure!"))
			return
		if(user.skill_check(SKILL_PILOT, SKILL_PROF))
			if(landing_eye.current_looker && landing_eye.current_looker != user)
				to_chat(user, SPAN_WARNING("Someone is already performing a landing maneuver!"))
				return TOPIC_HANDLED
			else
				start_landing(user, shuttle)
			return TOPIC_REFRESH
		to_chat(usr, SPAN_WARNING("The manual controls look hopelessly complex to you!"))

/obj/machinery/computer/shuttle_control/explore/proc/start_landing(var/mob/user, var/datum/shuttle/autodock/overmap/shuttle)

	var/obj/effect/overmap/visitable/current_sector = map_sectors["[z]"]
	var/obj/effect/overmap/visitable/target_sector
	if(current_sector && istype(current_sector))

		var/list/available_sectors = list()
		for(var/obj/effect/overmap/visitable/S in range(get_turf(current_sector), shuttle.range))
			if(S.free_landing)
				available_sectors += S

		if(LAZYLEN(available_sectors))
			target_sector = input("Choose sector to land in.", "Sectors") as null|anything in available_sectors
		else
			to_chat(user, SPAN_WARNING("No valid landing sites in range!"))
			return

	if(target_sector && CanInteract(user, GLOB.default_state))
		var/datum/extension/eye/landing_eye = get_extension(src, /datum/extension/eye)
		if(landing_eye)
			if(landing_eye.current_looker) // Double checking in case someone jumped ahead of us.
				to_chat(user, SPAN_WARNING("Someone is already performing a landing maneuver!"))
				return

			var/turf/eye_turf = locate(world.maxx/2, world.maxy/2, target_sector.map_z[target_sector.map_z.len]) // Center of the top z-level of the target sector.
			if(landing_eye.look(user, list(shuttle_tag), eye_turf)) // Placement of the eye was successful
				landing_eye.extension_eye.forceMove(eye_turf)
				return
	
	to_chat(user, SPAN_WARNING("You are unable to land!"))
	return

/obj/machinery/computer/shuttle_control/explore/proc/finish_landing(var/mob/user)
	var/datum/extension/eye/landing_eye = get_extension(src, /datum/extension/eye/)

	if(!landing_eye)
		return

	var/turf/lz_turf = landing_eye.get_eye_turf()

	var/obj/effect/overmap/visitable/sector = map_sectors["[lz_turf.z]"]
	if(!sector.free_landing)	// Additional safety check to ensure the sector permits landing.
		to_chat(user, SPAN_WARNING("Invalid landing zone!"))
		landing_eye.unlook()
		return
	var/datum/shuttle/autodock/overmap/shuttle = SSshuttle.shuttles[shuttle_tag]
	var/obj/effect/shuttle_landmark/temporary/lz = new(lz_turf)
	if(lz.is_valid(shuttle))	// Preliminary check that the shuttle fits.
		shuttle.set_destination(lz)
	else
		qdel(lz)
		to_chat(user, SPAN_WARNING("Invalid landing zone!"))
	landing_eye.unlook()

/obj/machinery/computer/shuttle_control/proc/end_landing()
	var/datum/extension/eye/landing_eye = get_extension(src, /datum/extension/eye/)
	if(landing_eye)
		landing_eye.unlook()

/obj/machinery/computer/shuttle_control/explore/power_change()
	. = ..()
	if(. && (stat & (NOPOWER|BROKEN)))
		var/datum/extension/eye/landing_eye = get_extension(src, /datum/extension/eye/)
		if(landing_eye)
			landing_eye.unlook()