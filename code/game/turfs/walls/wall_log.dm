/turf/wall/log
	icon_state = "log"
	material = /decl/material/solid/organic/wood
	color = WOOD_COLOR_GENERIC
	// color = TYPE_INITIAL(/decl/material/solid/organic/wood, color)
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
/* Uncomment when 515 is the minimum version.
#define LOG_WALL_SUBTYPE(material_name) \
/turf/wall/log/##material_name { \
	material = /decl/material/solid/organic/wood/##material_name; \
	color = TYPE_INITIAL(/decl/material/solid/organic/wood/##material_name, color); \
}

LOG_WALL_SUBTYPE(fungal)
LOG_WALL_SUBTYPE(ebony)
LOG_WALL_SUBTYPE(walnut)
LOG_WALL_SUBTYPE(maple)
LOG_WALL_SUBTYPE(mahogany)
LOG_WALL_SUBTYPE(bamboo)
LOG_WALL_SUBTYPE(yew)

#undef LOG_WALL_SUBTYPE
*/

/turf/wall/log/fungal
	material = /decl/material/solid/organic/wood/fungal
	color = "#e6d8dd"

/turf/wall/log/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = WOOD_COLOR_BLACK

/turf/wall/log/walnut
	material = /decl/material/solid/organic/wood/walnut
	color = WOOD_COLOR_CHOCOLATE

/turf/wall/log/maple
	material = /decl/material/solid/organic/wood/maple
	color = WOOD_COLOR_PALE

/turf/wall/log/mahogany
	material = /decl/material/solid/organic/wood/mahogany
	color = WOOD_COLOR_RICH

/turf/wall/log/bamboo
	material = /decl/material/solid/organic/wood/bamboo
	color = WOOD_COLOR_PALE2

/turf/wall/log/yew
	material = /decl/material/solid/organic/wood/yew
	color = WOOD_COLOR_YELLOW