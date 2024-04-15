/turf/wall/log
	icon_state = "log"
	material = /decl/material/solid/organic/wood
	girder_material = null

/turf/wall/log/get_dismantle_stack_type()
	return /obj/item/stack/material/log

/turf/wall/log/get_wall_icon()
	return 'icons/turf/walls/log.dmi'

/turf/wall/log/get_dismantle_sound()
	return 'sound/foley/wooden_drop.ogg'

// Subtypes.
/turf/wall/log/ebony
	icon_state = "wood"
	material = /decl/material/solid/organic/wood/ebony
	color = WOOD_COLOR_BLACK
