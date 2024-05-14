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

/turf/wall/log/update_strings()
	if(reinf_material)
		SetName("reinforced [material.solid_name] log wall")
		desc = "A log wall made of [material.solid_name] and reinforced with [reinf_material.solid_name]."
	else
		SetName("[material.solid_name] log wall")
		desc = "A log wall made of [material.solid_name]."

// Subtypes.
/turf/wall/log/ebony
	icon_state = "wood"
	material = /decl/material/solid/organic/wood/ebony
	color = WOOD_COLOR_BLACK
