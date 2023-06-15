/turf/exterior/open/sky
	name = "sky"
	desc = "Hope you don't have a fear of heights..."
	icon = 'icons/turf/exterior/sky_static.dmi'
	z_flags = ZM_PARTITION_STACK

// No matter what, the sky will never be 'inside'.
/turf/exterior/open/sky/is_outside()
	return TRUE // you can't take the sky from meee

/turf/exterior/open/sky/north
	dir = NORTH

/turf/exterior/open/sky/south
	dir = SOUTH

/turf/exterior/open/sky/west
	dir = WEST

/turf/exterior/open/sky/east
	dir = EAST

/turf/exterior/open/sky/moving
	icon = 'icons/turf/exterior/sky_slow.dmi'

/turf/exterior/open/sky/moving/north
	dir = NORTH

/turf/exterior/open/sky/moving/south
	dir = SOUTH

/turf/exterior/open/sky/moving/west
	dir = WEST

/turf/exterior/open/sky/moving/east
	dir = EAST
