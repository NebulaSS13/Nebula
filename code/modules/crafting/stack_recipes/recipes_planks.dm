/decl/stack_recipe/planks
	abstract_type          = /decl/stack_recipe/planks
	craft_stack_types      = /obj/item/stack/material/plank
	validation_material    = /decl/material/solid/organic/wood/oak

/decl/stack_recipe/planks/sandals
	result_type            = /obj/item/clothing/shoes/sandal

/decl/stack_recipe/planks/crossbowframe
	result_type            = /obj/item/crossbowframe
	difficulty             = MAT_VALUE_VERY_HARD_DIY
	category               = "weapons"

/decl/stack_recipe/planks/zipgunframe
	result_type            = /obj/item/zipgunframe
	difficulty             = MAT_VALUE_VERY_HARD_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	category               = "weapons"

/decl/stack_recipe/planks/coilgun
	result_type            = /obj/item/coilgun_assembly
	difficulty             = MAT_VALUE_VERY_HARD_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/planks/stick
	result_type            = /obj/item/stick
	difficulty             = MAT_VALUE_EASY_DIY

/decl/stack_recipe/planks/staff
	result_type            = /obj/item/staff
	difficulty             = MAT_VALUE_NORMAL_DIY

/decl/stack_recipe/planks/cane
	result_type            = /obj/item/cane
	difficulty             = MAT_VALUE_NORMAL_DIY

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

/decl/stack_recipe/planks/buckler
	result_type            = /obj/item/shield_base/buckler

/decl/stack_recipe/planks/fancy
	abstract_type          = /decl/stack_recipe/planks/fancy
	difficulty             = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/planks/fancy/decanter
	result_type            = /obj/item/chems/glass/handmade/fancy/decanter

/decl/stack_recipe/planks/fancy/goblet
	result_type            = /obj/item/chems/glass/handmade/fancy/goblet

/decl/stack_recipe/planks/fancy/bowl
	result_type            = /obj/item/chems/glass/handmade/fancy/bowl

/decl/stack_recipe/planks/fancy/vase
	result_type            = /obj/item/chems/glass/handmade/fancy/vase

/decl/stack_recipe/planks/fancy/vase_fluted
	name                   = "vase, fluted"
	result_type            = /obj/item/chems/glass/handmade/fancy/vase/fluted

/decl/stack_recipe/planks/noticeboard/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat, paint_color, spent_type, spent_amount = 1)
	. = ..()
	if(user)
		for(var/obj/structure/noticeboard/board in .)
			board.set_dir(global.reverse_dir[user.dir])

/decl/stack_recipe/planks/prosthetic
	abstract_type          = /decl/stack_recipe/planks/prosthetic
	difficulty             = MAT_VALUE_EASY_DIY
	category               = "prosthetics"
	var/prosthetic_species = /decl/species/human::uid
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

/decl/stack_recipe/planks/furniture/filter_stand
	result_type            = /obj/structure/filter_stand

/decl/stack_recipe/planks/furniture/produce_bin
	result_type            = /obj/structure/produce_bin

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
	result_type            = /obj/structure/chair/wood
	category               = "seating"

/decl/stack_recipe/planks/furniture/chair/fancy
	result_type            = /obj/structure/chair/wood/wings

/decl/stack_recipe/planks/furniture/chest
	result_type            = /obj/structure/closet/crate/chest

/decl/stack_recipe/planks/furniture/meathook
	result_type            = /obj/structure/meat_hook

/decl/stack_recipe/planks/furniture/meathook/improvised
	result_type            = /obj/structure/meat_hook/improvised
	difficulty             = MAT_VALUE_EASY_DIY

/decl/stack_recipe/planks/furniture/spinning_wheel
	result_type            = /obj/structure/working/spinning_wheel
	difficulty             = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/planks/furniture/loom
	result_type            = /obj/structure/working/loom
	difficulty             = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/planks/furniture/twisting_bench
	result_type            = /obj/structure/working/spinning_wheel/twisting_bench
	difficulty             = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/planks/furniture/butter_churn
	result_type            = /obj/structure/working/butter_churn
	difficulty             = MAT_VALUE_HARD_DIY

/decl/stack_recipe/planks/furniture/cabinet
	result_type            = /obj/structure/closet/cabinet/wooden
	difficulty             = MAT_VALUE_HARD_DIY

/decl/stack_recipe/planks/furniture/barrel
	result_type            = /obj/structure/reagent_dispensers/barrel/crafted
	difficulty             = MAT_VALUE_HARD_DIY

/decl/stack_recipe/planks/furniture/barrel/cask
	result_type            = /obj/structure/reagent_dispensers/barrel/cask/crafted

/decl/stack_recipe/planks/furniture/barrel/cask_rack
	result_type            = /obj/structure/cask_rack

/decl/stack_recipe/planks/furniture/barrel/large_cask_rack
	name                   = "cask rack, large"
	result_type            = /obj/structure/cask_rack/large

/decl/stack_recipe/planks/furniture/table_frame
	result_type            = /obj/structure/table/frame
	category               = "furniture"
	difficulty             = MAT_VALUE_HARD_DIY

/decl/stack_recipe/planks/furniture/gravemarker
	result_type            = /obj/item/gravemarker
	difficulty             = MAT_VALUE_NORMAL_DIY

/decl/stack_recipe/planks/furniture/divider
	result_type            = /obj/structure/divider
	difficulty             = MAT_VALUE_HARD_DIY

/decl/stack_recipe/planks/furniture/armor_stand
	result_type            = /obj/structure/armor_stand
	difficulty             = MAT_VALUE_NORMAL_DIY

/decl/stack_recipe/planks/furniture/target_stake
	result_type            = /obj/structure/target_stake
	difficulty             = MAT_VALUE_NORMAL_DIY

/decl/stack_recipe/planks/furniture/fence
	result_type            = /obj/structure/fence/plank
	difficulty             = MAT_VALUE_NORMAL_DIY

/decl/stack_recipe/planks/furniture/fence_door
	result_type            = /obj/structure/fence/door/plank
	difficulty             = MAT_VALUE_NORMAL_DIY
