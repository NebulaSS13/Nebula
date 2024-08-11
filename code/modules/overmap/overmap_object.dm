/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	color = "#c0c0c0"
	animate_movement = NO_STEPS
	is_spawnable_type = FALSE

	var/scannable                       // if set to TRUE will show up on ship sensors for detailed scans, and will ping when detected by scanners.
	var/unknown_id                      // A unique identifier used when this entity is scanned. Assigned in Initialize().
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

	var/list/comms_masers
	var/list/comms_antennae
	var/can_switch_ident = TRUE
	var/ident_transmitter = TRUE
	var/overmap_id = OVERMAP_ID_SPACE   // Which overmap datum this object expects to be dealing with
	var/adjacency_radius = 0            // draws a circle under the effect scaled to this size, 1 = 1 turf

/obj/effect/overmap/proc/get_heading_angle()
	. = round(Atan2(speed[2], speed[1]))
	if(. < 0) // Speeds can be negative so invert the degree value.
		. += 360

/obj/effect/overmap/touch_map_edge(var/overmap_id)
	return

//Overlay of how this object should look on other skyboxes
/obj/effect/overmap/proc/get_skybox_representation()
	return

/obj/effect/overmap/proc/get_scan_data(mob/user)
	return desc

/obj/effect/overmap/Initialize()
	. = ..()

	if(!length(global.using_map.overmap_ids))
		return INITIALIZE_HINT_QDEL

	if(requires_contact)
		set_invisibility(INVISIBILITY_OVERMAP) // Effects that require identification have their images cast to the client via sensors.

	if(scannable)
		unknown_id = "[pick(global.phonetic_alphabet)]-[random_id(/obj/effect/overmap, 100, 999)]"

	update_moving()

	add_filter("glow", 1, list(type = "drop_shadow", color = color + "F0", size = 2, offset = 1,x = 0, y = 0))
	update_icon()

/obj/effect/overmap/Crossed(atom/movable/AM)
	var/obj/effect/overmap/visitable/other = AM
	if(!istype(other))
		return
	for(var/obj/effect/overmap/visitable/O in loc)
		SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/Uncrossed(atom/movable/AM)
	var/obj/effect/overmap/visitable/other = AM
	if(!istype(other))
		return
	SSskybox.rebuild_skyboxes(other.map_z)
	for(var/obj/effect/overmap/visitable/O in loc)
		SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/on_update_icon()
	. = ..()
	underlays.Cut()
	if(adjacency_radius)
		var/image/radius = image(icon = 'icons/obj/overmap.dmi', icon_state = "radius")
		if(adjacency_radius != 1)
			var/matrix/M = matrix()
			M.Scale(adjacency_radius)
			radius.transform = M
		radius.appearance_flags = (RESET_ALPHA | KEEP_APART)
		radius.alpha = 50
		radius.filters = filter(type="blur", size = 1)
		underlays += radius

/obj/effect/overmap/proc/handle_wraparound()

	var/turf/T = get_turf(src)
	if(!istype(T) || !global.overmaps_by_z["[T.z]"])
		PRINT_STACK_TRACE("Overmap effect handling wraparound on a non-overmap z-level.")

	var/datum/overmap/overmap = global.overmaps_by_z["[T.z]"]
	var/nx = x
	var/ny = y

	var/heading_dir = get_heading_dir()

	if((heading_dir & WEST) && x == 1)
		nx = overmap.map_size_y - 1
	else if((heading_dir & EAST) && x == overmap.map_size_y)
		nx = 2
	if((heading_dir & SOUTH)  && y == 1)
		ny = overmap.map_size_y - 1
	else if((heading_dir & NORTH) && y == overmap.map_size_y)
		ny = 2
	if((x == nx) && (y == ny))
		return //we're not flying off anywhere

	T = locate(nx,ny,z)
	if(T)
		forceMove(T)

/obj/effect/overmap/proc/is_still()
	return !MOVING(speed[1], min_speed) && !MOVING(speed[2], min_speed)

/obj/effect/overmap/proc/get_speed()
	return round(sqrt(speed[1] ** 2 + speed[2] ** 2), SHIP_MOVE_RESOLUTION)

/obj/effect/overmap/proc/get_heading_dir()
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
	update_moving()

/obj/effect/overmap/proc/update_moving()
	if(is_still())
		SSovermap.moving_entities -= src
	else
		SSovermap.moving_entities[src] = TRUE
	update_icon()

/obj/effect/overmap/Destroy()
	STOP_PROCESSING(SSobj, src)
	SSovermap.moving_entities -= src
	speed = list(0, 0)
	position = list(0, 0)
	. = ..()

/obj/effect/overmap/proc/can_burn()
	if(halted)
		return FALSE
	if (world.time < last_burn + burn_delay)
		return FALSE
	else
		return TRUE

/obj/effect/overmap/proc/ProcessOvermap(wait, tick)

	if(halted || is_still())
		return PROCESS_KILL

	if(!can_move)
		return

	var/moved = FALSE
	var/list/deltas = list(0,0)
	for(var/i = 1 to 2)
		if(!MOVING(speed[i], min_speed))
			continue
		// Add speed to this dimension of our position.
		position[i] += clamp((speed[i] * OVERMAP_SPEED_CONSTANT) * (wait / (1 SECOND)), -1, 1)
		if(position[i] < 0)
			deltas[i] = ceil(position[i])
		else if(position[i] > 0)
			deltas[i] = floor(position[i])
		moved = TRUE
		// Delta over 0 means we've moved a turf, so we adjust our position accordingly.
		if(deltas[i] != 0)
			position[i] -= deltas[i]
			// Note for future self when confused: this line offsets the effect within the new turf.
			// Can probably be tidied up at some point but math is spooky.
			position[i] += (deltas[i] > 0) ? -1 : 1

	if(moved)
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
		if(delta_v == 0)
			return
		var/partial_power = clamp(actual_accel_limit / delta_v, 0, 1)
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
	if(!can_burn())
		return

	var/burn = FALSE
	. = list(0, 0)
	for(var/i = 1 to 2)
		var/spd = speed[i]
		var/abs_spd = abs(spd)
		if(abs_spd)
			var/base_delta_v = get_delta_v()
			if(base_delta_v > 0)
				var/partial_power = clamp(abs_spd / (base_delta_v / KM_OVERMAP_RATE), 0, 1)
				var/delta_v = min(get_delta_v(TRUE, partial_power) / KM_OVERMAP_RATE, abs_spd)
				.[i] = -SIGN(spd) * delta_v
				burn = TRUE

	if(burn)
		last_burn = world.time
		adjust_speed(.[1], .[2])

/obj/effect/overmap/proc/handle_overmap_pixel_movement()
	pixel_x = position[1] * (world.icon_size/2)
	pixel_y = position[2] * (world.icon_size/2)

/obj/effect/overmap/proc/get_delta_v()
	return 0

/obj/effect/overmap/proc/get_vessel_mass() //Same as above.
	return vessel_mass
