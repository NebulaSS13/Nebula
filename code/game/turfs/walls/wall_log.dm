/turf/wall/log
	icon_state = "log"
	material = /decl/material/solid/organic/wood
	color = /decl/material/solid/organic/wood::color
	girder_material = null
	floor_type = null
	min_dismantle_amount = 3
	max_dismantle_amount = 5

/turf/wall/log/shutter
	shutter_state = FALSE
	icon_state = "log_shutter"

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
#define LOG_WALL_SUBTYPE(material_name) \
/turf/wall/log/##material_name { \
	material = /decl/material/solid/organic/wood/##material_name; \
	color = /decl/material/solid/organic/wood/##material_name::color; \
}; \
/turf/wall/log/##material_name/shutter { \
	shutter_state = FALSE; \
	icon_state = "log_shutter"; \
}

LOG_WALL_SUBTYPE(fungal)
LOG_WALL_SUBTYPE(ebony)
LOG_WALL_SUBTYPE(walnut)
LOG_WALL_SUBTYPE(maple)
LOG_WALL_SUBTYPE(mahogany)
LOG_WALL_SUBTYPE(bamboo)
LOG_WALL_SUBTYPE(yew)

#undef LOG_WALL_SUBTYPE