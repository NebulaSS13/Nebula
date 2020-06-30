/datum/extension/overmap_movement
	base_type = /datum/extension/overmap_movement

/datum/extension/overmap_movement/New(/obj/effect/overmap/holder)
	..()

/datum/extension/overmap_movement/proc/do_overmap_movement()
	return //this just returns because this is the base extension.

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