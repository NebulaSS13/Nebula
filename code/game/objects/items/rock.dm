/obj/item/rock
	name                = "rock"
	desc                = "The secret is to bang the rocks together, guys."
	icon                = 'icons/obj/items/rock.dmi'
	icon_state          = ICON_STATE_WORLD
	sharp               = TRUE
	edge                = TRUE
	_base_attack_force  = 3
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	w_class             = ITEM_SIZE_SMALL

/obj/item/rock/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool/variable/simple, list(
		TOOL_HATCHET = TOOL_QUALITY_BAD,
		TOOL_SHOVEL = TOOL_QUALITY_WORST
	))

// TODO: craft a flint striker from a flint and a piece of metal
/obj/item/rock/attackby(obj/item/W, mob/user)

	var/decl/material/weapon_material = W.get_striking_material()
	var/decl/material/our_material = get_material()
	if((weapon_material?.ferrous && our_material?.type == /decl/material/solid/stone/flint) || (our_material?.ferrous && weapon_material?.type == /decl/material/solid/stone/flint))
		var/turf/spark_turf = get_turf(src)
		if(loc == user) // held in inventory
			var/turf/front_spark_turf = get_step_resolving_mimic(spark_turf, user.dir)
			if(istype(front_spark_turf) && !front_spark_turf.density && front_spark_turf.ClickCross(global.reverse_dir[user.dir]) && user.Adjacent(front_spark_turf))
				spark_turf = front_spark_turf
		if(spark_turf)
			spark_at(spark_turf, amount = 2, spark_type = /datum/effect/effect/system/spark_spread/non_electrical)
		return TRUE

	. = ..()

/obj/item/rock/basalt
	material = /decl/material/solid/stone/basalt

/obj/item/rock/hematite
	material = /decl/material/solid/hematite

/obj/item/rock/flint
	material = /decl/material/solid/stone/flint

/obj/item/rock/flint/striker
	name    = "striker"
	desc    = "A squared-off, rather worn-down piece of stone."
	icon    = 'icons/obj/items/striker.dmi'
	sharp   = FALSE
	edge    = FALSE
	w_class = ITEM_SIZE_TINY