/turf/space/transit
	var/push_direction // push things that get caught in the transit tile this direction

//Overwrite because we dont want people building rods in space.
/turf/space/transit/attackby(obj/O, mob/user)
	return

/turf/space/transit/Initialize()
	. = ..()
	toggle_transit(global.reverse_dir[push_direction])

/turf/space/transit/north // moving to the north
	icon_state = "arrow-north"
	push_direction = SOUTH  // south because the space tile is scrolling south

/turf/space/transit/south // moving to the south
	icon_state = "arrow-south"
	push_direction = SOUTH  // south because the space tile is scrolling south

/turf/space/transit/east // moving to the east
	icon_state = "arrow-east"
	push_direction = WEST

/turf/space/transit/west // moving to the west
	icon_state = "arrow-west"
	push_direction = WEST

