//Engine control and monitoring console

/obj/machinery/computer/ship/engines
	name = "engine control console"
	icon_keyboard = "tech_key"
	icon_screen = "engines"
	var/display_state = "status"

/// A stub used for modpacks to modify per-ship readout information.
/// This mutates the UI data list, so it can be used to mask or remove features
/// as well as to add entirely new ones.
/// It does not return a value.
/// While it can access per-engine data, it should be dispreferred for that compared to modify_engine_ui_data().
/obj/machinery/computer/ship/engines/proc/modify_ship_ui_data(list/ui_data)
	return

/// A stub used for modpacks to modify per-engine readout information.
/// This mutates the engine's data list, so it can be used to mask or remove features
/// as well as to add entirely new ones.
/// It does not return a value.
/obj/machinery/computer/ship/engines/proc/modify_engine_ui_data(datum/extension/ship_engine/engine, list/engine_data)
	return

/obj/machinery/computer/ship/engines/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		display_reconnect_dialog(user, "ship control systems")
		return

	var/data[0]
	data["state"] = display_state
	data["global_state"] = linked.get_engine_power()
	data["global_limit"] = round(linked.get_thrust_limit() * 100)
	var/total_thrust = 0

	var/list/enginfo[0]
	for(var/datum/extension/ship_engine/E in linked.engines)
		var/list/rdata[0]
		rdata["eng_type"] = E.engine_type
		rdata["eng_on"] = E.is_on()
		rdata["booting"] = E.next_on && E.next_on > world.time
		rdata["eng_thrust_limiter"] = round(E.thrust_limit * 100)
		rdata["eng_status"] = E.get_status()
		rdata["eng_reference"] = "\ref[E]"
		var/thrust = E.get_exhaust_velocity()
		total_thrust += thrust
		rdata["eng_thrust"] = "[thrust] m/s"
		modify_engine_ui_data(E, rdata)
		enginfo.Add(list(rdata))

	data["engines_info"] = enginfo
	data["total_thrust"] = "[total_thrust] m/s"

	modify_ship_ui_data(data)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "engines_control.tmpl", "[linked.name] Engines Control", 390, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/engines/OnTopic(var/mob/user, var/list/href_list, state)
	if(..())
		return ..()

	if(href_list["state"])
		display_state = href_list["state"]
		return TOPIC_REFRESH

	if(href_list["global_toggle"])
		linked.set_engine_power(!linked.get_engine_power())
		return TOPIC_REFRESH

	if(href_list["set_global_limit"])
		var/newlim = input("Input new thrust limit (0-100%)", "Thrust limit", linked.get_thrust_limit() * 100) as num
		if(!CanInteract(user, state))
			return TOPIC_NOACTION
		var/thrust_limit = clamp(newlim / 100, 0, 1)
		for(var/datum/extension/ship_engine/E in linked.engines)
			E.thrust_limit = thrust_limit
		return TOPIC_REFRESH

	if(href_list["global_limit"])
		var/current_thrust_limit = linked.get_thrust_limit()
		linked.set_thrust_limit(current_thrust_limit + text2num(href_list["global_limit"]))
		return TOPIC_REFRESH

	if(href_list["engine"])
		if(href_list["set_limit"])
			var/datum/extension/ship_engine/E = locate(href_list["engine"])
			var/newlim = input("Input new thrust limit (0-100)", "Thrust limit", E.thrust_limit) as num
			if(!CanInteract(user, state))
				return
			var/limit = clamp(newlim/100, 0, 1)
			if(istype(E))
				E.thrust_limit = limit
			return TOPIC_REFRESH
		if(href_list["limit"])
			var/datum/extension/ship_engine/E = locate(href_list["engine"])
			var/limit = clamp(E.thrust_limit + text2num(href_list["limit"]), 0, 1)
			if(istype(E))
				E.thrust_limit = limit
			return TOPIC_REFRESH

		if(href_list["toggle"])
			var/datum/extension/ship_engine/E = locate(href_list["engine"])
			if(istype(E))
				E.toggle()
			return TOPIC_REFRESH
		return TOPIC_REFRESH
	return TOPIC_NOACTION