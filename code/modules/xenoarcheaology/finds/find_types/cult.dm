

/decl/archaeological_find/cult
	item_type = "garments"
	responsive_reagent = /decl/material/solid/potassium
	possible_types = list(
		/obj/item/clothing/head/culthood,
		/obj/item/clothing/head/culthood/magus,
		/obj/item/clothing/head/culthood/alt,
		/obj/item/clothing/head/helmet/space/cult
	)
	modification_flags = XENOFIND_APPLY_PREFIX | XENOFIND_APPLY_DECOR

/decl/archaeological_find/cult/sword
	item_type = "blade"
	modification_flags = 0
	possible_types = list(/obj/item/sword/cultblade)
	engraving_chance = 10

//Override adding soulstone
/decl/archaeological_find/crystal
	possible_types = list(
		/obj/item = 4,
		/obj/item/soulstone
		)