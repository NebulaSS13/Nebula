/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	color = "#c0c0c0"
	animate_movement = NO_STEPS

	var/scannable                       // if set to TRUE will show up on ship sensors for detailed scans, and will ping when detected by scanners.

	var/requires_contact = FALSE        // whether or not the effect must be identified by ship sensors before being seen.
	var/instant_contact  = FALSE        // do we instantly identify ourselves to any ship in sensors range?
	var/halted = FALSE
	var/can_move = FALSE
	var/sensor_visibility = 10          // how likely it is to increase identification process each scan.

	var/vessel_mass = 10000             // metric tonnes, very rough number, affects acceleration provided by engines

	var/max_speed = 1/(1 SECOND)        // "speed of light" for the ship, in turfs/tick.
	var/min_speed = 1/(2 MINUTES)       // Below this, we round speed to 0 to avoid math errors.

	var/list/speed = list(0,0)          // speed in x,y direction
	var/list/position = list(0,0)       // position within a tile.
	var/last_burn = 0                   // worldtime when ship last acceleated
	var/burn_delay = 1 SECOND           // how often ship can do burns

//Overlay of how this object should look on other skyboxes
/obj/effect/overmap/proc/get_skybox_representation()
	return

/obj/effect/overmap/proc/get_scan_data(mob/user)
	return desc

/obj/effect/overmap/Initialize()
	. = ..()

	if(!global.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL

	if(requires_contact)
		invisibility = INVISIBILITY_OVERMAP // Effects that require identification have their images cast to the client via sensors.
	update_icon()

/obj/effect/overmap/Crossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/Uncrossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		SSskybox.rebuild_skyboxes(other.map_z)
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/on_update_icon()
	filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1,x = 0, y = 0)

/obj/effect/overmap/proc/handle_wraparound()
	var/nx = x
	var/ny = y
	var/low_edge = 1
	var/high_edge = global.using_map.overmap_size

	if((dir & WEST) && x == low_edge)
		nx = high_edge - 1
	else if((dir & EAST) && x == high_edge)
		nx = low_edge + 1
	if((dir & SOUTH)  && y == low_edge)
		ny = high_edge - 1
	else if((dir & NORTH) && y == high_edge)
		ny = low_edge + 1
	if((x == nx) && (y == ny))
		return //we're not flying off anywhere

	var/turf/T = locate(nx,ny,z)
	if(T)
		forceMove(T)

/obj/effect/overmap/proc/is_still()
	return !MOVING(speed[1], min_speed) && !MOVING(speed[2], min_speed)

/obj/effect/overmap/proc/get_speed()
	return round(sqrt(speed[1] ** 2 + speed[2] ** 2), SHIP_MOVE_RESOLUTION)

/obj/effect/overmap/proc/get_heading()
	var/res = 0
	if(MOVING(speed[1], min_speed))
		if(speed[1] > 0)
			res |= EAST
		else
			res |= WEST
	if(MOVING(speed[2], min_speed))
		if(speed[2] > 0)
			res |= NORTH
		else
			res |= SOUTH
	return res

/obj/effect/overmap/proc/adjust_speed(n_x, n_y)
	CHANGE_SPEED_BY(speed[1], n_x, min_speed)
	CHANGE_SPEED_BY(speed[2], n_y, min_speed)
	update_icon()

/obj/effect/overmap/proc/can_burn()
	if(halted)
		return FALSE
	if (world.time < last_burn + burn_delay)
		return FALSE
	else
		return TRUE

/obj/effect/overmap/Process()
	if(!halted && !is_still() && can_move)
		var/list/deltas = list(0,0)
		for(var/i = 1 to 2)
			if(MOVING(speed[i], min_speed))
				position[i] += speed[i] * OVERMAP_SPEED_CONSTANT
				if(position[i] < 0)
					deltas[i] = CEILING(position[i])
				else if(position[i] > 0)
					deltas[i] = FLOOR(position[i])
				if(deltas[i] != 0)
					position[i] -= deltas[i]
					position[i] += (deltas[i] > 0) ? -1 : 1

		update_icon()
		var/turf/newloc = locate(x + deltas[1], y + deltas[2], z)
		if(newloc && loc != newloc)
			Move(newloc)
			handle_wraparound()
	handle_overmap_pixel_movement()

/obj/effect/overmap/proc/accelerate(var/direction, var/accel_limit)
	var/actual_accel_limit = accel_limit / KM_OVERMAP_RATE
	if(can_burn())
		last_burn = world.time
		var/delta_v = get_delta_v() / KM_OVERMAP_RATE
		var/partial_power = Clamp(actual_accel_limit / delta_v, 0, 1)
		var/acceleration = min(get_delta_v(TRUE, partial_power) / KM_OVERMAP_RATE, actual_accel_limit)
		if(direction & EAST)
			adjust_speed(acceleration, 0)
		if(direction & WEST)
			adjust_speed(-acceleration, 0)
		if(direction & NORTH)
			adjust_speed(0, acceleration)
		if(direction & SOUTH)
			adjust_speed(0, -acceleration)


/obj/effect/overmap/proc/decelerate()
	if(((speed[1]) || (speed[2])) && can_burn())
		if (speed[1])
			var/partial_power = Clamp(speed[1] / (get_delta_v() / KM_OVERMAP_RATE), 0, 1)
			var/delta_v = get_delta_v(TRUE, partial_power) / KM_OVERMAP_RATE
			adjust_speed(-SIGN(speed[1]) * min(delta_v, abs(speed[1])), 0)
		if (speed[2])
			var/partial_power = Clamp(speed[2] / (get_delta_v() / KM_OVERMAP_RATE), 0, 1)
			var/delta_v = get_delta_v(TRUE, partial_power) / KM_OVERMAP_RATE
			adjust_speed(0, -SIGN(speed[2]) * min(delta_v, abs(speed[2])))
		last_burn = world.time

/obj/effect/overmap/proc/handle_overmap_pixel_movement()
	pixel_x = position[1] * (world.icon_size/2)
	pixel_y = position[2] * (world.icon_size/2)

/obj/effect/overmap/proc/get_delta_v()
	return
