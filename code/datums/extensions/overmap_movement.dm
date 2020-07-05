/datum/extension/overmap_movement
	base_type = /datum/extension/overmap_movement

/datum/extension/overmap_movement/New(/obj/effect/overmap/holder)
	..()

/datum/extension/overmap_movement/proc/do_overmap_movement()
	return //this just returns because this is the base extension.

/datum/extension/overmap_movement/proc/accelerate()
	return

/datum/extension/overmap_movement/proc/decelerate()
	return

/datum/extension/overmap_movement/proc/handle_pixel_movement()
	return

//Ship movement below.

/datum/extension/overmap_movement/ship
	base_type = /datum/extension/overmap_movement/ship

/datum/extension/overmap_movement/ship/do_overmap_movement()
	var/obj/effect/overmap/OM = holder

	if(!OM.halted && !OM.is_still())
		var/list/deltas = list(0,0)
		for(var/i = 1 to 2)
			if(MOVING(OM.speed[i], OM.min_speed))
				OM.position[i] += OM.speed[i] * OVERMAP_SPEED_CONSTANT
				if(OM.position[i] < 0)
					deltas[i] = ceil(OM.position[i])
				else if(OM.position[i] > 0)
					deltas[i] = Floor(OM.position[i])
				if(deltas[i] != 0)
					OM.position[i] -= deltas[i]
					OM.position[i] += (deltas[i] > 0) ? -1 : 1

		OM.update_icon()
		var/turf/newloc = locate(OM.x + deltas[1], OM.y + deltas[2], OM.z)
		if(newloc && OM.loc != newloc)
			OM.Move(newloc)
			OM.handle_wraparound()

/datum/extension/overmap_movement/ship/accelerate(var/direction, var/accel_limit)
	var/obj/effect/overmap/OM = holder

	var/actual_accel_limit = accel_limit / KM_OVERMAP_RATE
	if(OM.can_burn())
		OM.last_burn = world.time
		var/delta_v = OM.get_delta_v() / KM_OVERMAP_RATE
		var/partial_power = Clamp(actual_accel_limit / delta_v, 0, 1)
		var/acceleration = min(OM.get_delta_v(TRUE, partial_power) / KM_OVERMAP_RATE, actual_accel_limit)
		if(direction & EAST)
			OM.adjust_speed(acceleration, 0)
		if(direction & WEST)
			OM.adjust_speed(-acceleration, 0)
		if(direction & NORTH)
			OM.adjust_speed(0, acceleration)
		if(direction & SOUTH)
			OM.adjust_speed(0, -acceleration)

/datum/extension/overmap_movement/ship/decelerate()
	var/obj/effect/overmap/OM = holder

	if(((OM.speed[1]) || (OM.speed[2])) && OM.can_burn())
		if (OM.speed[1])
			var/partial_power = Clamp(OM.speed[1] / (OM.get_delta_v() / KM_OVERMAP_RATE), 0, 1)
			var/delta_v = OM.get_delta_v(TRUE, partial_power) / KM_OVERMAP_RATE
			OM.adjust_speed(-SIGN(OM.speed[1]) * min(delta_v, abs(OM.speed[1])), 0)
		if (OM.speed[2])
			var/partial_power = Clamp(OM.speed[2] / (OM.get_delta_v() / KM_OVERMAP_RATE), 0, 1)
			var/delta_v = OM.get_delta_v(TRUE, partial_power) / KM_OVERMAP_RATE
			OM.adjust_speed(0, -SIGN(OM.speed[2]) * min(delta_v, abs(OM.speed[2])))
		OM.last_burn = world.time

/datum/extension/overmap_movement/ship/handle_pixel_movement()
	var/obj/effect/overmap/OM = holder

	OM.pixel_x = OM.position[1] * (world.icon_size/2)
	OM.pixel_y = OM.position[2] * (world.icon_size/2)

	for(var/obj/machinery/computer/ship/machine in OM.consoles)
		if(machine.z in OM.map_z)
			for(var/weakref/W in machine.viewers)
				var/mob/M = W.resolve()
				if(istype(M) && M.client)
					M.client.pixel_x = OM.pixel_x
					M.client.pixel_y = OM.pixel_y



