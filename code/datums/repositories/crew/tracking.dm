/* Tracking */
/crew_sensor_modifier/tracking/process_crew_data(var/mob/living/human/H, var/obj/item/clothing/sensor/vitals/S, var/turf/pos, var/list/crew_data)
	if(pos)
		var/area/A = get_area(pos)
		crew_data["area"] = A.proper_name
		crew_data["x"] = pos.x
		crew_data["y"] = pos.y
		crew_data["z"] = pos.z
	return ..()

/* Random */
/crew_sensor_modifier/tracking/jamming
	priority = 5

/crew_sensor_modifier/tracking/jamming/localize/process_crew_data(var/mob/living/human/H, var/obj/item/clothing/sensor/vitals/S, var/turf/pos, var/list/crew_data)
	return ..(H, S, get_turf(holder), crew_data)

/crew_sensor_modifier/tracking/jamming/random
	var/shift_range = 7
	var/x_shift
	var/y_shift
	var/next_shift_change

/crew_sensor_modifier/tracking/jamming/random/moderate
	shift_range = 14

/crew_sensor_modifier/tracking/jamming/random/major
	shift_range = 21

/crew_sensor_modifier/tracking/jamming/random/process_crew_data(var/mob/living/human/H, var/obj/item/clothing/sensor/vitals/S, var/turf/pos, var/list/crew_data)
	if(world.time > next_shift_change)
		next_shift_change = world.time + rand(30 SECONDS, 2 MINUTES)
		x_shift = rand(-shift_range, shift_range)
		y_shift = rand(-shift_range, shift_range)
	if(pos)
		var/new_x = clamp(pos.x + x_shift, 1, world.maxx)
		var/new_y = clamp(pos.y + y_shift, 1, world.maxy)
		pos = locate(new_x, new_y, pos.z)
	return ..(H, S, pos, crew_data)
