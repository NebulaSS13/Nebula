/decl/material
	var/is_psionic_nullifier

/decl/material/proc/is_psi_null()
	return is_psionic_nullifier

/decl/material/nullglass
	name = "nullglass"
	color = COLOR_NULLGLASS
	conductive = 1
	flags = MAT_FLAG_BRITTLE
	opacity = 0.5
	integrity = 30
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 80
	weight = MAT_VALUE_HEAVY
	door_icon_base = "stone"
	destruction_desc = "shatters"
	destruction_sound = "shatter"
	hitsound = 'sound/effects/Glasshit.ogg'
	is_psionic_nullifier = TRUE
	exoplanet_rarity_plant = MAT_RARITY_EXOTIC
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "solid_nullglass"

/obj/item/shard/nullglass
	material = /decl/material/nullglass

/decl/stack_recipe/tile/nullglass
	result_type = /obj/item/stack/tile/floor_nullglass
	required_material = /decl/material/nullglass
