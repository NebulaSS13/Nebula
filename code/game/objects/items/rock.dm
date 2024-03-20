/obj/item/rock
	name                = "rock"
	desc                = "The secret is to bang the rocks together, guys."
	icon                = 'icons/obj/items/stacks/rock.dmi'
	icon_state          = "rock"
	sharp               = TRUE
	edge                = TRUE
	force               = 3
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

/obj/item/rock/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool/variable/simple, list(
		TOOL_HATCHET = TOOL_QUALITY_BAD,
		TOOL_SHOVEL = TOOL_QUALITY_WORST
	))

// TODO: craft a flint striker from a flint and a piece of metal
/obj/item/rock/attackby(obj/item/W, mob/user)

	if(W.material?.ferrous && material?.type == /decl/material/solid/stone/flint)
		spark_at(get_turf(src), amount = 2, spark_type = /datum/effect/effect/system/spark_spread/non_electrical)
		return TRUE

	. = ..()

/obj/item/rock/basalt
	material = /decl/material/solid/stone/basalt

/obj/item/rock/hematite
	material = /decl/material/solid/hematite

/obj/item/rock/flint
	name = "striker"
	material = /decl/material/solid/stone/flint
