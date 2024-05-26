var/global/list/all_waypoints = list()

/datum/computer_file/data/waypoint
	var/list/fields = list()

/datum/computer_file/data/waypoint/New()
	global.all_waypoints += src

/datum/computer_file/data/waypoint/Destroy()
	. = ..()
	global.all_waypoints -= src

var/global/list/overmap_helm_computers
/obj/machinery/computer/ship/helm
	name = "helm control console"
	icon_keyboard = "teleport_key"
	icon_screen = "helm"
	light_color = "#7faaff"
	core_skill = SKILL_PILOT

	var/autopilot = 0
	var/list/known_sectors = list()
	var/dx		//desitnation
	var/dy		//coordinates
	var/speedlimit = 1/(20 SECONDS) //top speed for autopilot, 5
	var/accellimit = 1 //manual limiter for acceleration
	/// The mob currently operating the helm - The last one to click one of the movement buttons and be on the overmap screen. Set to `null` for autopilot or when the mob isn't in range.
	var/weakref/current_operator
	var/obj/compass_holder/overmap/compass

/obj/machinery/computer/ship/helm/Initialize()
	. = ..()
	LAZYADD(global.overmap_helm_computers, src)
	for(var/obj/effect/overmap/visitable/sector as anything in global.known_overmap_sectors)
		add_known_sector(sector)

/obj/machinery/computer/ship/helm/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	. = ..()
	if(linked)
		if(!compass)
			compass = new(src)
	else
		if(compass)
			QDEL_NULL(compass)

/obj/machinery/computer/ship/helm/Destroy()
	. = ..()
	QDEL_NULL(compass)
	LAZYREMOVE(global.overmap_helm_computers, src)

/obj/machinery/computer/ship/helm/proc/add_known_sector(var/obj/effect/overmap/visitable/sector)
	var/datum/computer_file/data/waypoint/R = new
	R.fields["name"] = sector.name
	R.fields["x"] =    sector.x
	R.fields["y"] =    sector.y
	known_sectors[sector.name] = R

/obj/machinery/computer/ship/helm/Process()
	..()

	var/datum/overmap/overmap = global.overmaps_by_name[overmap_id]
	var/mob/current_operator_actual = current_operator?.resolve()
	if (current_operator_actual)
		if (!linked)
			to_chat(current_operator_actual, SPAN_DANGER("\The [src]'s controls lock up with an error flashing across the screen: Connection to vessel lost!"))
			set_operator(null, TRUE)
		else if (!Adjacent(current_operator_actual) || CanUseTopic(current_operator_actual) != STATUS_INTERACTIVE || !viewing_overmap(current_operator_actual))
			set_operator(null)

	if (autopilot && dx && dy)
		var/turf/T = locate(dx, dy, overmap.assigned_z)
		if(linked.loc == T)
			if(linked.is_still())
				autopilot = 0
			else
				linked.decelerate()
		else
			var/brake_path = linked.get_brake_path()
			var/direction = get_dir(linked.loc, T)
			var/acceleration = min(linked.get_delta_v(), accellimit)
			var/speed = linked.get_speed()
			var/heading = linked.get_heading_dir()

			// Destination is current grid or speedlimit is exceeded
			if ((get_dist(linked.loc, T) <= brake_path) || speed > speedlimit)
				linked.decelerate()
			// Heading does not match direction
			else if (heading & ~direction)
				linked.accelerate(turn(heading & ~direction, 180), accellimit)
			// All other cases, move toward direction
			else if (speed + acceleration <= speedlimit)
				linked.accelerate(direction, accellimit)

		// Re-resolve as the above set_operator() calls may have nullified or changed this.
		current_operator_actual = current_operator?.resolve()
		if (current_operator_actual)
			to_chat(current_operator_actual, SPAN_DANGER("\The [src]'s autopilot is active and wrests control from you!"))
			set_operator(null, TRUE, TRUE)

	if(compass)
		compass.recalculate_heading(FALSE)
		compass.rebuild_overlay_lists(TRUE)

/obj/machinery/computer/ship/helm/relaymove(var/mob/user, direction)
	if(viewing_overmap(user) && linked)
		if(prob(user.skill_fail_chance(SKILL_PILOT, 50, linked.skill_needed, factor = 1)))
			direction = turn(direction,pick(90,-90))
		linked.relaymove(user, direction, accellimit)
		set_operator(user)
		return 1

/obj/machinery/computer/ship/helm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	if(!linked)
		display_reconnect_dialog(user, "helm")
	else
		var/turf/T = get_turf(linked)
		var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

		data["sector"] = current_sector ? current_sector.name : "Deep Space"
		data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
		data["landed"] = linked.get_landed_info()
		data["s_x"] = linked.x
		data["s_y"] = linked.y
		data["dest"] = dy && dx
		data["d_x"] = dx
		data["d_y"] = dy
		data["speedlimit"] = speedlimit ? speedlimit : "Halted"
		data["accel"] = min(round(linked.get_delta_v(), 0.01),accellimit)
		data["heading"] = linked.get_heading_angle()
		data["autopilot"] = autopilot
		data["manual_control"] = viewing_overmap(user)
		data["canburn"] = linked.can_burn()
		data["accellimit"] = accellimit

		var/speed = round(linked.get_speed() * KM_OVERMAP_RATE, 0.01) // type abused
		if(speed < SHIP_SPEED_SLOW)
			speed = "<span class='good'>[speed]</span>"
		else if(speed > SHIP_SPEED_FAST)
			speed = "<span class='average'>[speed]</span>"
		data["speed"] = speed

		if(linked.get_speed())
			data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
		else
			data["ETAnext"] = "N/A"

		var/list/locations[0]
		for (var/key in known_sectors)

			var/datum/computer_file/data/waypoint/R = known_sectors[key]
			var/list/rdata[0]
			rdata["name"] =      R.fields["name"]
			rdata["x"] =         R.fields["x"]
			rdata["y"] =         R.fields["y"]
			rdata["tracking"] =  R.fields["tracking"]
			rdata["reference"] = "\ref[R]"

			locations.Add(list(rdata))

		data["locations"] = locations

		ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, "helm.tmpl", "[linked.name] Helm Control", 565, 545, nref = src)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/obj/machinery/computer/ship/helm/OnTopic(var/mob/user, var/list/href_list, state)
	if(..())
		return TOPIC_HANDLED

	if(!linked)
		return TOPIC_HANDLED

	if (href_list["add"])
		var/datum/computer_file/data/waypoint/R = new()
		var/sec_name = input("Input naviation entry name", "New navigation entry", "Sector #[length(known_sectors)]") as text
		if(!CanInteract(user,state))
			return TOPIC_NOACTION
		if(!sec_name)
			sec_name = "Sector #[length(known_sectors)]"
		R.fields["name"] = sec_name
		if(sec_name in known_sectors)
			to_chat(user, "<span class='warning'>Sector with that name already exists, please input a different name.</span>")
			return TOPIC_REFRESH
		switch(href_list["add"])
			if("current")
				R.fields["x"] = linked.x
				R.fields["y"] = linked.y
			if("new")
				var/newx = input("Input new entry x coordinate", "Coordinate input", linked.x) as num
				if(!CanInteract(user,state))
					return TOPIC_REFRESH
				var/newy = input("Input new entry y coordinate", "Coordinate input", linked.y) as num
				if(!CanInteract(user,state))
					return TOPIC_NOACTION
				R.fields["x"] = clamp(newx, 1, world.maxx)
				R.fields["y"] = clamp(newy, 1, world.maxy)
		known_sectors[sec_name] = R
		compass.set_waypoint("\ref[R]", R.fields["name"], R.fields["x"], R.fields["y"], 1, R.fields["color"] || COLOR_CYAN)
		compass.hide_waypoint("\ref[R]")

	if (href_list["remove"])
		var/datum/computer_file/data/waypoint/R = locate(href_list["remove"])
		if(R)
			known_sectors.Remove(R.fields["name"])
			compass.clear_waypoint("\ref[R]")
			qdel(R)

	if(href_list["toggle_wp_tracking"])
		var/datum/computer_file/data/waypoint/R = locate(href_list["toggle_wp_tracking"])
		if(R && (R.fields["name"] in known_sectors))
			R.fields["tracking"] = !R.fields["tracking"]
			to_chat(user, SPAN_NOTICE("[R.fields["name"]] is [R.fields["tracking"] ? "now" : "no longer"] being tracked."))
			if(R.fields["tracking"])
				compass.set_waypoint("\ref[R]", R.fields["name"], R.fields["x"], R.fields["y"], 1, R.fields["color"] || COLOR_CYAN)
				compass.show_waypoint("\ref[R]")
			else
				compass.hide_waypoint("\ref[R]")

	if(href_list["set_wp_color"])
		var/datum/computer_file/data/waypoint/R = locate(href_list["set_wp_color"])
		if(!R || !(R.fields["name"] in known_sectors))
			return TOPIC_NOACTION
		var/new_color = input(user, "Please select the main colour.", "Crayon colour") as color
		if(!CanInteract(user,state) || !R || known_sectors[R.fields["name"]] != R)
			return TOPIC_NOACTION
		R.fields["color"] = new_color
		compass.set_waypoint("\ref[R]", R.fields["name"], R.fields["x"], R.fields["y"], 1, new_color)

	if (href_list["setx"])
		var/newx = input("Input new destiniation x coordinate", "Coordinate input", dx) as num|null
		if(!CanInteract(user,state))
			return TOPIC_NOACTION
		if (newx)
			dx = clamp(newx, 1, world.maxx)

	if (href_list["sety"])
		var/newy = input("Input new destiniation y coordinate", "Coordinate input", dy) as num|null
		if(!CanInteract(user,state))
			return TOPIC_NOACTION
		if (newy)
			dy = clamp(newy, 1, world.maxy)

	if (href_list["x"] && href_list["y"])
		dx = text2num(href_list["x"])
		dy = text2num(href_list["y"])

	if (href_list["reset"])
		dx = 0
		dy = 0

	if (href_list["speedlimit"])
		var/newlimit = input("Input new speed limit for autopilot (0 to brake)", "Autopilot speed limit", speedlimit) as num|null
		if(newlimit)
			speedlimit = clamp(newlimit, 0, 100)
	if (href_list["accellimit"])
		var/newlimit = input("Input new acceleration limit", "Acceleration limit", accellimit) as num|null
		if(newlimit)
			accellimit = max(newlimit, 0)

	if (href_list["move"])
		var/ndir = text2num(href_list["move"])
		if(prob(user.skill_fail_chance(SKILL_PILOT, 50, linked.skill_needed, factor = 1)))
			ndir = turn(ndir,pick(90,-90))
		linked.relaymove(user, ndir, accellimit)

	if (href_list["brake"])
		linked.decelerate()

	if (href_list["apilot"])
		autopilot = !autopilot
		if (autopilot)
			set_operator(null, autopilot = TRUE)
		else if (viewing_overmap(user))
			set_operator(user)

	if (href_list["manual"])
		if(!isliving(user))
			to_chat(user, SPAN_WARNING("You can't use this."))
			return TOPIC_NOACTION
		viewing_overmap(user) ? unlook(user) : look(user)

	add_fingerprint(user)
	updateUsrDialog()

/obj/machinery/computer/ship/helm/unlook(mob/user)
	. = ..()
	if (current_operator?.resolve() == user)
		set_operator(null)
	if(user.client && compass)
		user.client.screen -= compass

/obj/machinery/computer/ship/helm/look(mob/user)
	. = ..()
	if (!autopilot)
		set_operator(user)
	if(user.client && compass)
		user.client.screen |= compass

/**
 * Updates `current_operator` to the new user, or `null` and ejects the old operator from the overmap view - Only one person on a helm at a time!
 * Will call `display_operator_change_message()` if `silent` is `FALSE`.
 * `autopilot` will prevent ejection from the overmap (You want to monitor your autopilot right?) and by passed on to `display_operator_change_message()`.
 * Skips ghosts and observers to prevent accidental external influencing of flight.
 */
/obj/machinery/computer/ship/helm/proc/set_operator(mob/user, silent, autopilot)
	var/mob/current_operator_actual = current_operator?.resolve()
	if (isobserver(user) || user == current_operator_actual)
		return

	var/mob/old_operator = current_operator_actual
	current_operator_actual = user
	current_operator = weakref(current_operator_actual)
	linked.update_operator_skill(current_operator_actual)
	if (!autopilot && old_operator && viewing_overmap(old_operator))
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/computer/ship, unlook), old_operator), 0) // Workaround for linter SHOULD_NOT_SLEEP checks.

	log_debug("HELM CONTROL: [current_operator_actual ? current_operator_actual : "NO PILOT"] taking control of [src] from [old_operator ? old_operator : "NO PILOT"] in [get_area_name(src)]. [autopilot ? "(AUTOPILOT MODE)" : null]")

	if (!silent)
		display_operator_change_message(old_operator, current_operator_actual, autopilot)


/**
 * Displays visible messages indicating a change in operator.
 * `autopilot` will affect the displayed message.
 */
/obj/machinery/computer/ship/helm/proc/display_operator_change_message(mob/old_operator, mob/new_operator, autopilot)
	if (!old_operator)
		new_operator.visible_message(
			SPAN_NOTICE("\The [new_operator] takes \the [src]'s controls."),
			SPAN_NOTICE("You take \the [src]'s controls.")
		)
	else if (!new_operator)
		if (autopilot)
			old_operator.visible_message(
				SPAN_NOTICE("\The [old_operator] engages \the [src]'s autopilot and releases the controls."),
				SPAN_NOTICE("You engage \the [src]'s autopilot and release the controls.")
			)
		else
			old_operator.visible_message(
				SPAN_WARNING("\The [old_operator] releases \the [src]'s controls."),
				SPAN_WARNING("You release \the [src]'s controls.")
			)
	else
		old_operator.visible_message(
			SPAN_WARNING("\The [new_operator] takes \the [src]'s controls from \the [old_operator]."),
			SPAN_DANGER("\The [new_operator] takes \the [src]'s controls from you!")
		)


/obj/machinery/computer/ship/navigation
	name = "navigation console"
	icon_keyboard = "generic_key"
	icon_screen = "helm"

/obj/machinery/computer/ship/navigation/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		display_reconnect_dialog(user, "Navigation")
		return

	var/data[0]


	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

	data["sector"] = current_sector ? current_sector.name : "Deep Space"
	data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
	data["s_x"] = linked.x
	data["s_y"] = linked.y
	data["speed"] = round(linked.get_speed() * KM_OVERMAP_RATE, 0.01)
	data["accel"] = round(linked.get_delta_v(), 0.01)
	data["heading"] = linked.get_heading_angle()
	data["viewing"] = viewing_overmap(user)

	if(linked.get_speed())
		data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
	else
		data["ETAnext"] = "N/A"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "nav.tmpl", "[linked.name] Navigation Screen", 380, 530, nref = src)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/navigation/OnTopic(var/mob/user, var/list/href_list)
	if(..())
		return TOPIC_HANDLED

	if (!linked)
		return TOPIC_NOACTION

	if (href_list["viewing"])
		viewing_overmap(user) ? unlook(user) : look(user)
		return TOPIC_REFRESH

/obj/machinery/computer/ship/navigation/telescreen	//little hacky but it's only used on one ship so it should be okay
	icon_state = "tele_nav"
	density = FALSE

/obj/machinery/computer/ship/navigation/telescreen/on_update_icon()
	if(reason_broken & MACHINE_BROKEN_NO_PARTS || stat & NOPOWER || stat & BROKEN)
		icon_state = "tele_off"
		set_light(0)
	else
		icon_state = "tele_nav"
		set_light(light_range_on, light_power_on, light_color)
