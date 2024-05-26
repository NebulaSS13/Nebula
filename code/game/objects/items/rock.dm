/obj/item/rock
	name = "rock"
	icon = 'icons/obj/items/rock.dmi'
	desc = "The secret is to bang the rocks together, guys."
	sharp = TRUE
	edge = TRUE
	force = 3
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	w_class             = ITEM_SIZE_SMALL

/obj/item/rock/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool/variable, list(
		TOOL_HATCHET = TOOL_QUALITY_BAD,
		TOOL_SHOVEL = TOOL_QUALITY_WORST
	))

// TODO: craft a flint striker from a flint and a piece of metal
/obj/item/rock/attackby(obj/item/W, mob/user)
	if(W.material?.ferrous && material?.type == /decl/material/solid/stone/flint)
		spark_at(get_turf(src), amount = 2, spark_type = /datum/effect/effect/system/spark_spread/non_electrical)
		return TRUE
	. = ..()

/obj/item/rock/striker/Initialize(var/ml, var/material_key)
	material_key = /decl/material/solid/hematite
	return ..()
