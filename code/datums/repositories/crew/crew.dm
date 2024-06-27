var/global/datum/repository/crew/crew_repository = new()

/datum/repository/crew
	var/list/cache_data
	var/list/cache_data_alert
	var/list/modifier_queues
	var/list/modifier_queues_by_type

/datum/repository/crew/New()
	cache_data = list()
	cache_data_alert = list()

	var/datum/priority_queue/general_modifiers = new /datum/priority_queue(/proc/cmp_crew_sensor_modifier)
	var/datum/priority_queue/binary_modifiers = new /datum/priority_queue(/proc/cmp_crew_sensor_modifier)
	var/datum/priority_queue/vital_modifiers = new /datum/priority_queue(/proc/cmp_crew_sensor_modifier)
	var/datum/priority_queue/tracking_modifiers = new /datum/priority_queue(/proc/cmp_crew_sensor_modifier)

	general_modifiers.Enqueue(new/crew_sensor_modifier/general())
	binary_modifiers.Enqueue(new/crew_sensor_modifier/binary())
	vital_modifiers.Enqueue(new/crew_sensor_modifier/vital())
	tracking_modifiers.Enqueue(new/crew_sensor_modifier/tracking())

	modifier_queues = list()
	modifier_queues[general_modifiers]  = VITALS_SENSOR_OFF
	modifier_queues[binary_modifiers]   = VITALS_SENSOR_BINARY
	modifier_queues[vital_modifiers]    = VITALS_SENSOR_VITAL
	modifier_queues[tracking_modifiers] = VITALS_SENSOR_TRACKING

	modifier_queues_by_type = list()
	modifier_queues_by_type[/crew_sensor_modifier/general] = general_modifiers
	modifier_queues_by_type[/crew_sensor_modifier/binary] = binary_modifiers
	modifier_queues_by_type[/crew_sensor_modifier/vital] = vital_modifiers
	modifier_queues_by_type[/crew_sensor_modifier/tracking] = tracking_modifiers

	..()

/datum/repository/crew/proc/health_data(var/z_level)
	var/list/crewmembers = list()
	if(!z_level)
		return crewmembers

	var/datum/cache_entry/cache_entry = cache_data[num2text(z_level)]
	if(!cache_entry)
		cache_entry = new/datum/cache_entry
		cache_data[num2text(z_level)] = cache_entry

	if(world.time < cache_entry.timestamp)
		return cache_entry.data

	cache_data_alert[num2text(z_level)] = FALSE
	var/tracked = scan()
	for(var/obj/item/clothing/sensor/vitals/sensor as anything in tracked)
		var/turf/pos = get_turf(sensor)
		if(!pos || pos.z != z_level || sensor.sensor_mode == VITALS_SENSOR_OFF)
			continue
		var/mob/living/human/H = sensor.loc?.loc
		if(!istype(H))
			continue
		var/obj/item/clothing/uniform = H.get_equipped_item(slot_w_uniform_str)
		if(!istype(uniform) || !(sensor in uniform.accessories))
			continue
		var/list/crewmemberData = list("sensor_type" = sensor.sensor_mode, "stat"=H.stat, "area"="", "x"=-1, "y"=-1, "z"=-1, "ref"="\ref[H]")
		if(!(run_queues(H, sensor, pos, crewmemberData) & MOD_SUIT_SENSORS_REJECTED))
			crewmembers[++crewmembers.len] = crewmemberData
			if (crewmemberData["alert"])
				cache_data_alert[num2text(z_level)] = TRUE

	crewmembers = sortTim(crewmembers, /proc/cmp_list_name_key_asc)

	cache_entry.timestamp = world.time + 5 SECONDS
	cache_entry.data = crewmembers

	cache_data[num2text(z_level)] = cache_entry

	return crewmembers

/datum/repository/crew/proc/has_health_alert(var/z_level)
	. = FALSE
	if(!z_level)
		return
	health_data(z_level) // Make sure cache doesn't get stale
	. = cache_data_alert[num2text(z_level)]

/datum/repository/crew/proc/scan()
	for(var/mob/living/human/H in SSmobs.mob_list)
		var/sensor = H.get_vitals_sensor()
		if(sensor)
			LAZYDISTINCTADD(., sensor)

/datum/repository/crew/proc/run_queues(H, S, pos, crewmemberData)
	for(var/modifier_queue in modifier_queues)
		if(crewmemberData["sensor_type"] >= modifier_queues[modifier_queue])
			. = process_crew_data(modifier_queue, H, S, pos, crewmemberData)
			if(. & MOD_SUIT_SENSORS_REJECTED)
				return

/datum/repository/crew/proc/process_crew_data(var/datum/priority_queue/modifiers, var/mob/living/human/H, var/obj/item/clothing/sensor/vitals/S, var/turf/pos, var/list/crew_data)
	var/current_priority = INFINITY
	var/list/modifiers_of_this_priority = list()

	for(var/crew_sensor_modifier/csm in modifiers.L)
		if(csm.priority < current_priority)
			. = check_queue(modifiers_of_this_priority, H, S, pos, crew_data)
			if(. != MOD_SUIT_SENSORS_NONE)
				return
		current_priority = csm.priority
		modifiers_of_this_priority += csm
	return check_queue(modifiers_of_this_priority, H, S, pos, crew_data)

/datum/repository/crew/proc/check_queue(var/list/modifiers_of_this_priority, H, S, pos, crew_data)
	while(modifiers_of_this_priority.len)
		var/crew_sensor_modifier/pcsm = pick(modifiers_of_this_priority)
		modifiers_of_this_priority -= pcsm
		if(pcsm.may_process_crew_data(H, S, pos))
			. = pcsm.process_crew_data(H, S, pos, crew_data)
			if(. != MOD_SUIT_SENSORS_NONE)
				return
	return MOD_SUIT_SENSORS_NONE

/datum/repository/crew/proc/add_modifier(var/base_type, var/crew_sensor_modifier/csm)
	if(!istype(csm, base_type))
		CRASH("The given crew sensor modifier was not of the given base type.")
	var/datum/priority_queue/pq = modifier_queues_by_type[base_type]
	if(!pq)
		CRASH("The given base type was not a valid base type.")
	if(csm in pq.L)
		CRASH("This crew sensor modifier has already been supplied.")
	pq.Enqueue(csm)
	return TRUE

/datum/repository/crew/proc/remove_modifier(var/base_type, var/crew_sensor_modifier/csm)
	if(!istype(csm, base_type))
		CRASH("The given crew sensor modifier was not of the given base type.")
	var/datum/priority_queue/pq = modifier_queues_by_type[base_type]
	if(!pq)
		CRASH("The given base type was not a valid base type.")
	return pq.Remove(csm)
