/turf/wall/brick
	icon_state = "brick"
	material = /decl/material/solid/stone/sandstone
	girder_material = null
	floor_type = null
	min_dismantle_amount = 3
	max_dismantle_amount = 5

/turf/wall/brick/shutter
	shutter_state = FALSE
	icon_state = "brick_shutter"

/turf/wall/brick/get_dismantle_stack_type()
	return /obj/item/stack/material/brick

/turf/wall/brick/get_wall_icon()
	return 'icons/turf/walls/brick.dmi'

/turf/wall/brick/get_dismantle_sound()
	return 'sound/foley/wooden_drop.ogg' // todo

/turf/wall/brick/update_strings()
	if(reinf_material)
		SetName("reinforced [material.solid_name] brick wall")
		desc = "A brick wall made of [material.solid_name] and reinforced with [reinf_material.solid_name]."
	else
		SetName("[material.solid_name] brick wall")
		desc = "A brick wall made of [material.solid_name]."

// Subtypes.
#define MATERIAL_BRICK_WALL(material_name) \
/turf/wall/brick/##material_name { \
	color = /decl/material/solid/stone/##material_name::color; \
	material = /decl/material/solid/stone/##material_name; \
}; \
/turf/wall/brick/##material_name/shutter { \
	shutter_state = FALSE; \
	icon_state = "brick_shutter"; \
}

MATERIAL_BRICK_WALL(sandstone)
MATERIAL_BRICK_WALL(basalt)
MATERIAL_BRICK_WALL(granite)
MATERIAL_BRICK_WALL(marble)
MATERIAL_BRICK_WALL(pottery)
#undef MATERIAL_BRICK_WALL