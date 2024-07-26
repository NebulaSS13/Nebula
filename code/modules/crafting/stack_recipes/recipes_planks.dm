/decl/stack_recipe/planks
	abstract_type          = /decl/stack_recipe/planks
	craft_stack_types      = /obj/item/stack/material/plank

/decl/stack_recipe/planks/sandals
	result_type            = /obj/item/clothing/shoes/sandal

/decl/stack_recipe/planks/crossbowframe
	result_type            = /obj/item/crossbowframe
	difficulty             = MAT_VALUE_VERY_HARD_DIY
	category               = "weapons"

/decl/stack_recipe/planks/beehive_assembly
	result_type            = /obj/item/beehive_assembly
	category               = "furniture"

/decl/stack_recipe/planks/beehive_frame
	result_type            = /obj/item/honey_frame

/decl/stack_recipe/planks/zipgunframe
	result_type            = /obj/item/zipgunframe
	difficulty             = MAT_VALUE_VERY_HARD_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	category               = "weapons"

/decl/stack_recipe/planks/coilgun
	result_type            = /obj/item/coilgun_assembly
	difficulty             = MAT_VALUE_VERY_HARD_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/planks/fishing_rod
	result_type = /obj/item/fishing_rod

/decl/stack_recipe/planks/stick
	result_type            = /obj/item/stick
	difficulty             = MAT_VALUE_EASY_DIY

/decl/stack_recipe/planks/bucket
	result_type            = /obj/item/chems/glass/bucket/wood
	difficulty             = MAT_VALUE_EASY_DIY

/decl/stack_recipe/planks/bolt
	result_type            = /obj/item/stack/material/bow_ammo/bolt
	difficulty             = MAT_VALUE_EASY_DIY

/decl/stack_recipe/planks/arrow
	result_type            = /obj/item/stack/material/bow_ammo/arrow
	difficulty             = MAT_VALUE_HARD_DIY

/decl/stack_recipe/planks/bow
	result_type            = /obj/item/gun/launcher/bow/crafted
	difficulty             = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/planks/bow/fancy
	name                   = "decorated bow"
	result_type            = /obj/item/gun/launcher/bow/fancy/crafted

/decl/stack_recipe/planks/noticeboard
	result_type            = /obj/structure/noticeboard
	on_floor               = TRUE
	difficulty             = MAT_VALUE_HARD_DIY
	set_dir_on_spawn       = FALSE

/decl/stack_recipe/planks/cup
	result_type            = /obj/item/chems/glass/handmade/cup

/decl/stack_recipe/planks/mug
	result_type            = /obj/item/chems/glass/handmade/mug

/decl/stack_recipe/planks/bowl
	result_type            = /obj/item/chems/glass/handmade/bowl

/decl/stack_recipe/planks/noticeboard/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat, paint_color, spent_type, spent_amount = 1)
	. = ..()
	if(user)
		for(var/obj/structure/noticeboard/board in .)
			board.set_dir(global.reverse_dir[user.dir])

/decl/stack_recipe/planks/prosthetic
	abstract_type          = /decl/stack_recipe/planks/prosthetic
	difficulty             = MAT_VALUE_EASY_DIY
	category               = "prosthetics"
	var/prosthetic_species = SPECIES_HUMAN
	var/prosthetic_model   = /decl/bodytype/prosthetic/wooden

/decl/stack_recipe/planks/prosthetic/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat, paint_color, spent_type, spent_amount = 1)
	. = ..()
	for(var/obj/item/organ/external/limb in .)
		limb.set_species(prosthetic_species)
		limb.set_bodytype(prosthetic_model, override_material = (required_material != MATERIAL_FORBIDDEN ? mat?.type : null))
		limb.status |= ORGAN_CUT_AWAY

/decl/stack_recipe/planks/prosthetic/left_arm
	result_type            = /obj/item/organ/external/arm

/decl/stack_recipe/planks/prosthetic/right_arm
	result_type            = /obj/item/organ/external/arm/right

/decl/stack_recipe/planks/prosthetic/left_leg
	result_type            = /obj/item/organ/external/leg

/decl/stack_recipe/planks/prosthetic/right_leg
	result_type            = /obj/item/organ/external/leg/right

/decl/stack_recipe/planks/prosthetic/left_hand
	result_type            = /obj/item/organ/external/hand

/decl/stack_recipe/planks/prosthetic/right_hand
	result_type            = /obj/item/organ/external/hand/right

/decl/stack_recipe/planks/prosthetic/left_foot
	result_type            = /obj/item/organ/external/foot

/decl/stack_recipe/planks/prosthetic/right_foot
	result_type            = /obj/item/organ/external/foot/right

/decl/stack_recipe/planks/furniture
	abstract_type          = /decl/stack_recipe/planks/furniture
	one_per_turf           = TRUE
	on_floor               = TRUE
	difficulty             = MAT_VALUE_HARD_DIY
	category               = "furniture"

/decl/stack_recipe/planks/furniture/simple_bed
	result_type = /obj/structure/bed/simple/crafted

/decl/stack_recipe/planks/furniture/compost_bin
	result_type            = /obj/structure/reagent_dispensers/compost_bin

/decl/stack_recipe/planks/furniture/coffin
	result_type            = /obj/structure/closet/coffin/wooden

/decl/stack_recipe/planks/furniture/sofa
	name                   = "sofa, middle"
	result_type            = /obj/structure/bed/sofa/middle/unpadded
	category               = "seating"

/decl/stack_recipe/planks/furniture/sofa/left
	name                   = "sofa, left"
	result_type            = /obj/structure/bed/sofa/left/unpadded

/decl/stack_recipe/planks/furniture/sofa/right
	name                   = "sofa, right"
	result_type            = /obj/structure/bed/sofa/right/unpadded

/decl/stack_recipe/planks/furniture/bookcase
	result_type            = /obj/structure/bookcase

/decl/stack_recipe/planks/furniture/book_cart
	result_type            = /obj/structure/bookcase/cart

/decl/stack_recipe/planks/furniture/chair
	result_type            = /obj/structure/bed/chair/wood
	category               = "seating"

/decl/stack_recipe/planks/furniture/chair/fancy
	result_type            = /obj/structure/bed/chair/wood/wings

/decl/stack_recipe/planks/furniture/chest
	result_type            = /obj/structure/closet/crate/chest

/decl/stack_recipe/planks/furniture/meathook
	result_type            = /obj/structure/meat_hook

/decl/stack_recipe/planks/furniture/meathook/improvised
	result_type            = /obj/structure/meat_hook/improvised
	difficulty             = MAT_VALUE_EASY_DIY

/decl/stack_recipe/planks/furniture/spinning_wheel
	result_type            = /obj/structure/textiles/spinning_wheel
	difficulty             = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/planks/furniture/loom
	result_type            = /obj/structure/textiles/loom
	difficulty             = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/planks/furniture/twisting_bench
	result_type            = /obj/structure/textiles/spinning_wheel/twisting_bench
	difficulty             = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/planks/furniture/cabinet
	result_type            = /obj/structure/closet/cabinet/wooden
	difficulty             = MAT_VALUE_HARD_DIY

/decl/stack_recipe/planks/furniture/barrel
	result_type            = /obj/structure/reagent_dispensers/barrel
	difficulty             = MAT_VALUE_HARD_DIY

/decl/stack_recipe/planks/furniture/table_frame
	result_type            = /obj/structure/table/frame
	category               = "furniture"
	difficulty             = MAT_VALUE_HARD_DIY

/decl/stack_recipe/planks/furniture/gravemarker
	result_type            = /obj/item/gravemarker
	difficulty             = MAT_VALUE_NORMAL_DIY
