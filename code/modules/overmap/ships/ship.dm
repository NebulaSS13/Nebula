var/const/OVERMAP_SPEED_CONSTANT = (1 SECOND)

#define KM_OVERMAP_RATE		100
#define SHIP_MOVE_RESOLUTION 0.00001
#define MOVING(speed) abs(speed) >= min_speed
#define SANITIZE_SPEED(speed) SIGN(speed) * Clamp(abs(speed), 0, max_speed)
#define CHANGE_SPEED_BY(speed_var, v_diff) \
	v_diff = SANITIZE_SPEED(v_diff);\
	if(!MOVING(speed_var + v_diff)) \
		{speed_var = 0};\
	else \
		{speed_var = round(SANITIZE_SPEED((speed_var + v_diff) / (1 + speed_var * v_diff / (max_speed ** 2))), SHIP_MOVE_RESOLUTION)}
// Uses Lorentzian dynamics to avoid going too fast.

/obj/effect/overmap/visitable/ship
	name = "generic ship"
	desc = "Space faring vessel."
	icon_state = "ship"

	var/moving_state = "ship_moving"
	var/list/consoles

	var/vessel_mass = 10000             // metric tonnes, very rough number, affects acceleration provided by engines
	var/vessel_size = SHIP_SIZE_LARGE	// arbitrary number, affects how likely are we to evade meteors
	var/max_speed = 1/(1 SECOND)        // "speed of light" for the ship, in turfs/tick.
	var/min_speed = 1/(2 MINUTES)       // Below this, we round speed to 0 to avoid math errors.

	var/list/speed = list(0,0)          // speed in x,y direction
	var/list/position = list(0,0)       // position within a tile.
	var/last_burn = 0                   // worldtime when ship last acceleated
	var/burn_delay = 1 SECOND           // how often ship can do burns
	var/fore_dir = NORTH                // what dir ship flies towards for purpose of moving stars effect procs

	var/list/engines = list()			// /datum/extension/ship_engine list of all engines.
	var/halted = 0        //admin halt or other stop.
	var/skill_needed = SKILL_ADEPT  //piloting skill needed to steer it without going in random dir
	var/operator_skill

	var/needs_dampers = FALSE
	var/list/inertial_dampers = list()
	var/damping_strength = null
	
/obj/effect/overmap/visitable/ship/Initialize()
	. = ..()
	glide_size = world.icon_size
	min_speed = round(min_speed, SHIP_MOVE_RESOLUTION)
	max_speed = round(max_speed, SHIP_MOVE_RESOLUTION)
	SSshuttle.ships += src
	START_PROCESSING(SSobj, src)

/obj/effect/overmap/visitable/ship/Destroy()
	STOP_PROCESSING(SSobj, src)
	SSshuttle.ships -= src
	if(LAZYLEN(consoles))
		for(var/obj/machinery/computer/ship/machine in consoles)
			if(machine.linked == src)
				machine.linked = null
		consoles = null
	. = ..()

/obj/effect/overmap/visitable/ship/proc/set_thrust_limit(var/thrust_limit)
	for(var/datum/extension/ship_engine/E in engines)
		E.thrust_limit = Clamp(thrust_limit, 0, 1)

/obj/effect/overmap/visitable/ship/proc/set_engine_power(var/engine_power)
	for(var/datum/extension/ship_engine/E in engines)
		if(engine_power != E.is_on())
			E.toggle()

/obj/effect/overmap/visitable/ship/proc/get_engine_power()
	for(var/datum/extension/ship_engine/E in engines)
		if(E.is_on())
			return TRUE

/obj/effect/overmap/visitable/ship/proc/get_thrust_limit()
	for(var/datum/extension/ship_engine/E in engines)
		if(E.thrust_limit > 0 && E.thrust_limit < .)
			. = E.thrust_limit


/obj/effect/overmap/visitable/ship/relaymove(mob/user, direction, accel_limit)
	operator_skill = user.get_skill_value(SKILL_PILOT)
	accelerate(direction, accel_limit)

/obj/effect/overmap/visitable/ship/proc/is_still()
	return !MOVING(speed[1]) && !MOVING(speed[2])

/obj/effect/overmap/visitable/ship/get_scan_data(mob/user)
	. = ..()
	if(!is_still())
		. += "<br>Heading: [dir2angle(get_heading())], speed [get_speed() * KM_OVERMAP_RATE]"

/obj/effect/overmap/visitable/ship/proc/get_speed()
	return round(sqrt(speed[1] ** 2 + speed[2] ** 2), SHIP_MOVE_RESOLUTION)

/obj/effect/overmap/visitable/ship/proc/get_heading()
	var/res = 0
	if(MOVING(speed[1]))
		if(speed[1] > 0)
			res |= EAST
		else
			res |= WEST
	if(MOVING(speed[2]))
		if(speed[2] > 0)
			res |= NORTH
		else
			res |= SOUTH
	return res

/obj/effect/overmap/visitable/ship/proc/adjust_speed(n_x, n_y)
	CHANGE_SPEED_BY(speed[1], n_x)
	CHANGE_SPEED_BY(speed[2], n_y)
	var/magnitude = norm(n_x, n_y)
	var/inertia_dir = magnitude >= 0 ? turn(fore_dir, 180) : fore_dir
	var/inertia_strength = magnitude * 1e3
	if(needs_dampers && damping_strength < inertia_strength)
		var/list/areas_by_name = area_repository.get_areas_by_z_level()
		for(var/area_name in areas_by_name)
			var/area/A = areas_by_name[area_name]
			if(area_belongs_to_zlevels(A, map_z))
				A.throw_unbuckled_occupants(inertia_strength+2, inertia_strength, inertia_dir)
	for(var/zz in map_z)
		if(is_still())
			toggle_move_stars(zz)
		else
			toggle_move_stars(zz, fore_dir)
	update_icon()

/obj/effect/overmap/visitable/ship/proc/get_brake_path()
	if(!get_delta_v())
		return INFINITY
	if(is_still())
		return 0
	if(!burn_delay)
		return 0
	if(!get_speed())
		return 0
	var/num_burns = get_speed() / get_delta_v() + 2 //some padding in case acceleration drops fromm fuel usage
	var/burns_per_grid = 1/ (burn_delay * get_speed())
	return round(num_burns / burns_per_grid)

/obj/effect/overmap/visitable/ship/proc/decelerate()
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

/obj/effect/overmap/visitable/ship/proc/accelerate(direction, accel_limit)
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

/obj/effect/overmap/visitable/ship/Process()
	damping_strength = 0
	for(var/datum/ship_inertial_damper/I in inertial_dampers)
		var/obj/machinery/inertial_damper/ID = I.holder
		damping_strength += ID.get_damping_strength(TRUE)

	if(!halted && !is_still())
		var/list/deltas = list(0,0)
		for(var/i = 1 to 2)
			if(MOVING(speed[i]))
				position[i] += speed[i] * OVERMAP_SPEED_CONSTANT
				if(position[i] < 0)
					deltas[i] = ceil(position[i])
				else if(position[i] > 0)
					deltas[i] = Floor(position[i])
				if(deltas[i] != 0)
					position[i] -= deltas[i]
					position[i] += (deltas[i] > 0) ? -1 : 1

		update_icon()
		var/turf/newloc = locate(x + deltas[1], y + deltas[2], z)
		if(newloc && loc != newloc)
			Move(newloc)
			handle_wraparound()

/obj/effect/overmap/visitable/ship/on_update_icon()

	pixel_x = position[1] * (world.icon_size/2)
	pixel_y = position[2] * (world.icon_size/2)

	if(!is_still())
		icon_state = moving_state
		set_dir(get_heading())
	else
		icon_state = initial(icon_state)

	for(var/obj/machinery/computer/ship/machine in consoles)
		if(machine.z in map_z)
			for(var/weakref/W in machine.viewers)
				var/mob/M = W.resolve()
				if(istype(M) && M.client)
					M.client.pixel_x = pixel_x
					M.client.pixel_y = pixel_y
	..()

/obj/effect/overmap/visitable/ship/proc/burn()
	for(var/datum/extension/ship_engine/E in engines)
		. += E.burn()

/obj/effect/overmap/visitable/ship/proc/can_burn()
	if(halted)
		return 0
	if (world.time < last_burn + burn_delay)
		return 0
	for(var/datum/extension/ship_engine/E in engines)
		. |= E.can_burn()

//deciseconds to next step
/obj/effect/overmap/visitable/ship/proc/ETA()
	. = INFINITY
	for(var/i = 1 to 2)
		if(MOVING(speed[i]))
			. = min(., ((speed[i] > 0 ? 1 : -1) - position[i]) / speed[i])
	. = max(ceil(.),0)

/obj/effect/overmap/visitable/ship/proc/handle_wraparound()
	var/nx = x
	var/ny = y
	var/low_edge = 1
	var/high_edge = GLOB.using_map.overmap_size - 1

	if((dir & WEST) && x == low_edge)
		nx = high_edge
	else if((dir & EAST) && x == high_edge)
		nx = low_edge
	if((dir & SOUTH)  && y == low_edge)
		ny = high_edge
	else if((dir & NORTH) && y == high_edge)
		ny = low_edge
	if((x == nx) && (y == ny))
		return //we're not flying off anywhere

	var/turf/T = locate(nx,ny,z)
	if(T)
		forceMove(T)

/obj/effect/overmap/visitable/ship/proc/halt()
	adjust_speed(-speed[1], -speed[2])
	halted = 1

/obj/effect/overmap/visitable/ship/proc/unhalt()
	if(!SSshuttle.overmap_halted)
		halted = 0

/obj/effect/overmap/visitable/ship/Bump(var/atom/A)
	if(istype(A,/turf/unsimulated/map/edge))
		handle_wraparound()
	..()

/obj/effect/overmap/visitable/ship/proc/get_helm_skill()//delete this mover operator skill to overmap obj
	return operator_skill

/obj/effect/overmap/visitable/ship/populate_sector_objects()
	..()
	for(var/obj/machinery/computer/ship/S in SSmachines.machinery)
		S.attempt_hook_up(src)
	for(var/datum/extension/ship_engine/E in ship_engines)
		if(check_ownership(E.holder))
			engines |= E
	for(var/datum/ship_inertial_damper/I in global.ship_inertial_dampers)
		if(check_ownership(I.holder))
			inertial_dampers |= I
	var/v_mass = recalculate_vessel_mass()
	if(v_mass)
		vessel_mass = v_mass

/obj/effect/overmap/visitable/ship/proc/get_landed_info()
	return "This ship cannot land."

#undef MOVING
#undef SANITIZE_SPEED
#undef CHANGE_SPEED_BY