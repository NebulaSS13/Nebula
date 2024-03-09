/turf/simulated/wall/log
	icon_state = "log"
	material = /decl/material/solid/organic/wood
	girder_material = null

/turf/simulated/wall/log/get_dismantle_stack_type()
	return /obj/item/stack/material/log

/turf/simulated/wall/log/get_wall_icon()
	return 'icons/turf/walls/log.dmi'

/turf/simulated/wall/log/get_dismantle_sound()
	return 'sound/foley/wooden_drop.ogg'

// Subtypes.
/turf/simulated/wall/log/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = WOOD_COLOR_BLACK
