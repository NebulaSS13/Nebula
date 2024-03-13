/turf/wall/brick
	icon_state = "brick"
	material = /decl/material/solid/stone/sandstone
	girder_material = null

/turf/wall/brick/get_dismantle_stack_type()
	return /obj/item/stack/material/brick

/turf/wall/brick/get_wall_icon()
	return 'icons/turf/walls/brick.dmi'

/turf/wall/brick/get_dismantle_sound()
	return 'sound/foley/wooden_drop.ogg' // todo

// Subtypes.
/turf/wall/brick/sandstone
	color = COLOR_GOLD

/turf/wall/brick/basalt
	material = /decl/material/solid/stone/basalt
	color = COLOR_DARK_GRAY
