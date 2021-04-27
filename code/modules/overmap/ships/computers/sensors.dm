/obj/machinery/computer/ship/sensors
	name = "sensors console"
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	light_color = "#77fff8"
	extra_view = 4
	var/weakref/sensor_ref
	var/list/last_scan
	var/working_sound = 'sound/machines/sensors/dradis.ogg'
	var/datum/sound_token/sound_token
	var/sound_id

/obj/machinery/computer/ship/sensors/proc/get_sensors()
	var/obj/machinery/shipsensors/sensors = sensor_ref?.resolve()
	if(!istype(sensors) || QDELETED(sensors))
		sensor_ref = null
	return sensors

/obj/machinery/computer/ship/sensors/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	if(!(. = ..()))
		return
	find_sensors()

/obj/machinery/computer/ship/sensors/proc/find_sensors()
	if(!linked)
		return
	for(var/obj/machinery/shipsensors/S in SSmachines.machinery)
		if(linked.check_ownership(S))
			sensor_ref = weakref(S)
			break

/obj/machinery/computer/ship/sensors/proc/update_sound()
	if(!working_sound)
		return
	if(!sound_id)
		sound_id = "[type]_[sequential_id(/obj/machinery/computer/ship/sensors)]"

	var/obj/machinery/shipsensors/sensors = get_sensors()
	if(sensors && linked && sensors.use_power ** sensors.powered())
		var/volume = 10
		if(!sound_token)
			sound_token = play_looping_sound(src, sound_id, working_sound, volume = volume, range = 10)
		sound_token.SetVolume(volume)
	else if(sound_token)
		QDEL_NULL(sound_token)

/obj/machinery/computer/ship/sensors/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		display_reconnect_dialog(user, "sensors")
		return

	var/data[0]

	var/obj/machinery/shipsensors/sensors = get_sensors()
	data["viewing"] = viewing_overmap(user)
	if(sensors)
		data["on"] = sensors.use_power
		data["range"] = sensors.range
		data["heat"] = sensors.heat
		data["critical_heat"] = sensors.critical_heat
		if(sensors.is_broken())
			data["status"] = "DESTROYED"
		else if(!sensors.powered())
			data["status"] = "NO POWER"
		else if(!sensors.in_vacuum())
			data["status"] = "VACUUM SEAL BROKEN"
		else
			data["status"] = "OK"
		var/list/contacts = list()

		var/list/potential_contacts = list()

		for(var/obj/effect/overmap/nearby in view(7,linked))
			if(nearby.requires_contact) // Some ships require.
				continue
			potential_contacts |= nearby

		// Effects that require contact are only added to the contacts if they have been identified.
		// Allows for coord tracking out of range of the player's view.
		for(var/obj/effect/overmap/visitable/identified_contact in contact_datums)
			potential_contacts |= identified_contact

		for(var/obj/effect/overmap/O in potential_contacts)
			if(linked == O)
				continue
			if(!O.scannable)
				continue
			var/bearing = round(90 - Atan2(O.x - linked.x, O.y - linked.y),5)
			if(bearing < 0)
				bearing += 360
			contacts.Add(list(list("name"=O.name, "color"= O.color, "ref"="\ref[O]", "bearing"=bearing)))
		if(contacts.len)
			data["contacts"] = contacts
		data["last_scan"] = last_scan
	else
		data["status"] = "MISSING"
		data["range"] = "N/A"
		data["on"] = 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "shipsensors.tmpl", "[linked.name] Sensors Control", 420, 530, src)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/sensors/OnTopic(var/mob/user, var/list/href_list, state)
	if(..())
		return TOPIC_HANDLED

	if (!linked)
		return TOPIC_NOACTION

	if (href_list["viewing"])
		if(user && !isAI(user))
			viewing_overmap(user) ? unlook(user) : look(user)
		return TOPIC_REFRESH

	if (href_list["link"])
		find_sensors()
		return TOPIC_REFRESH

	var/obj/machinery/shipsensors/sensors = get_sensors()
	if(sensors)
		if (href_list["range"])
			var/nrange = input("Set new sensors range", "Sensor range", sensors.range) as num|null
			if(!CanInteract(user,state))
				return TOPIC_NOACTION
			if (nrange)
				sensors.set_range(Clamp(nrange, 1, world.view))
			return TOPIC_REFRESH
		if (href_list["toggle"])
			sensors.toggle()
			return TOPIC_REFRESH

	if (href_list["scan"])
		var/obj/effect/overmap/O = locate(href_list["scan"])
		if(istype(O) && !QDELETED(O))
			if((O in view(7,linked))|| (O in contact_datums))
				playsound(loc, "sound/effects/ping.ogg", 50, 1)
				LAZYSET(last_scan, "data", O.get_scan_data(user))
				LAZYSET(last_scan, "location", "[O.x],[O.y]")
				LAZYSET(last_scan, "name", "[O]")
				to_chat(user, SPAN_NOTICE("Successfully scanned [O]."))
				return TOPIC_HANDLED

		to_chat(user, SPAN_WARNING("Could not get a scan!"))
		return TOPIC_HANDLED

	if (href_list["print"])
		playsound(loc, "sound/machines/dotprinter.ogg", 30, 1)
		new/obj/item/paper/(get_turf(src), last_scan["data"], "paper (Sensor Scan - [last_scan["name"]])")
		return TOPIC_HANDLED

/obj/machinery/shipsensors
	name = "sensors suite"
	desc = "Long range gravity scanner with various other sensors, used to detect irregularities in surrounding space. Can only run in vacuum to protect delicate quantum BS elements."
	icon = 'icons/obj/machines/ship_sensors.dmi'
	icon_state = "sensors"
	anchored = 1
	var/critical_heat = 50 // sparks and takes damage when active & above this heat
	var/heat_reduction = 1.5 // mitigates this much heat per tick
	var/heat = 0
	var/range = 1
	var/sensor_strength //used for detecting ships via contacts
	idle_power_usage = 5000
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = NOSCREEN | NOINPUT
	frame_type = /obj/machinery/constructable_frame
	base_type = /obj/machinery/shipsensors

/obj/machinery/shipsensors/proc/in_vacuum()
	var/turf/T=get_turf(src)
	if(istype(T))
		var/datum/gas_mixture/environment = T.return_air()
		if(environment && environment.return_pressure() > MINIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND)
			return 0
	return 1

/obj/machinery/shipsensors/on_update_icon()
	if(use_power)
		icon_state = "sensors"
	else
		icon_state = "sensors_off"

/obj/machinery/shipsensors/proc/toggle()
	if(!use_power && (is_broken() || !in_vacuum()))
		return // No turning on if broken or misplaced.
	if(!use_power) //need some juice to kickstart
		use_power_oneoff(idle_power_usage*5)
	update_use_power(!use_power)

/obj/machinery/shipsensors/Process()
	if(use_power) //can't run in non-vacuum
		if(!in_vacuum())
			toggle()
		if(heat > critical_heat)
			src.visible_message("<span class='danger'>\The [src] violently spews out sparks!</span>")
			spark_at(src, cardinal_only = TRUE)
			take_damage(10, BURN)
			toggle()
		heat += idle_power_usage/15000

	if (heat > 0)
		heat = max(0, heat - heat_reduction)

/obj/machinery/shipsensors/power_change()
	. = ..()
	if(use_power && !powered())
		toggle()

/obj/machinery/shipsensors/proc/set_range(nrange)
	range = nrange
	change_power_consumption(1500 * (range**2), POWER_USE_IDLE) //Exponential increase, also affects speed of overheating

/obj/machinery/shipsensors/emp_act(severity)
	if(!use_power)
		return
	toggle()
	..()

/obj/machinery/shipsensors/RefreshParts()
	..()
	sensor_strength = Clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 0, 5)

/obj/machinery/shipsensors/weak
	heat_reduction = 0.2
	desc = "Miniturized gravity scanner with various other sensors, used to detect irregularities in surrounding space. Can only run in vacuum to protect delicate quantum BS elements."
