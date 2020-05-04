/material
	var/is_psionic_nullifier

/material/proc/is_psi_null()
	return is_psionic_nullifier

/material/nullglass
	is_psionic_nullifier = TRUE

/material/nullglass
	
	icon_colour = COLOR_NULLGLASS
	conductive = 1
	stack_type = /obj/item/stack/material/nullglass
	flags = MAT_FLAG_BRITTLE
	opacity = 0.5
	integrity = 30
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 80
	weight = MAT_VALUE_HEAVY
	door_icon_base = "stone"
	destruction_desc = "shatters"
	hitsound = 'sound/effects/Glasshit.ogg'

/material/nullglass/generate_recipes()
	. = ..()
	. += new /datum/stack_recipe/tile/nullglass(src)

/obj/item/material/shard/nullglass
	material = MAT_NULLGLASS
/datum/stack_recipe/tile/nullglass
	title = "nullglass floor tile"
	result_type = /obj/item/stack/tile/floor_nullglass
