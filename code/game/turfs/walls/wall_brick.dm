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

/turf/wall/brick/update_strings()
	if(reinf_material)
		SetName("reinforced [material.solid_name] brick wall")
		desc = "A brick wall made of [material.solid_name] and reinforced with [reinf_material.solid_name]."
	else
		SetName("[material.solid_name] brick wall")
		desc = "A brick wall made of [material.solid_name]."

// Subtypes.
/* Uncomment when 515 is the minimum version.
#define MATERIAL_BRICK_WALL(material_name) \
/turf/wall/brick/##material_name { \
	color = TYPE_INITIAL(/decl/material/solid/stone/##material_name, color); \
	material = /decl/material/solid/stone/##material_name; \
}

MATERIAL_BRICK_WALL(sandstone)
MATERIAL_BRICK_WALL(basalt)
MATERIAL_BRICK_WALL(granite)
MATERIAL_BRICK_WALL(marble)
MATERIAL_BRICK_WALL(pottery)
#undef MATERIAL_BRICK_WALL
*/

/turf/wall/brick/sandstone
	color    = "#d9c179"
	material = /decl/material/solid/stone/sandstone

/turf/wall/brick/basalt
	color    = COLOR_DARK_GRAY
	material = /decl/material/solid/stone/basalt

/turf/wall/brick/granite
	color    = "#615f5f"
	material = /decl/material/solid/stone/granite

/turf/wall/brick/marble
	color    = "#aaaaaa"
	material = /decl/material/solid/stone/marble

/turf/wall/brick/pottery
	color    = "#cd8f75"
	material = /decl/material/solid/stone/pottery
