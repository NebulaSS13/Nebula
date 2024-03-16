/obj/abstract/ramp_sculptor
	name = "ramp sculptor"
	icon_state = "x"
	var/place_dir

/obj/abstract/ramp_sculptor/south
	icon_state = "arrow"
	dir = SOUTH
	place_dir = SOUTH

/obj/abstract/ramp_sculptor/north
	icon_state = "arrow"
	dir = NORTH
	place_dir = NORTH

/obj/abstract/ramp_sculptor/east
	icon_state = "arrow"
	dir = EAST
	place_dir = EAST

/obj/abstract/ramp_sculptor/west
	icon_state = "arrow"
	dir = WEST
	place_dir = WEST

/obj/abstract/ramp_sculptor/Initialize()
	..()
	var/turf/wall/natural/ramp = get_turf(src)
	if(istype(ramp) && !ramp.ramp_slope_direction)
		if(!place_dir || !(place_dir in global.cardinal))
			for(var/checkdir in global.cardinal)
				var/turf/neighbor = get_step(ramp, checkdir)
				if(neighbor && neighbor.density)
					place_dir = global.reverse_dir[checkdir]
					break
		if(place_dir)
			dir = place_dir
			ramp.make_ramp(null, place_dir)
	return INITIALIZE_HINT_QDEL
