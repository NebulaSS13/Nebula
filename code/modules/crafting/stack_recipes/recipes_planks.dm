/decl/stack_recipe/planks
	abstract_type = /decl/stack_recipe/planks
	craft_stack_types = /obj/item/stack/material/plank

/decl/stack_recipe/planks/sandals
	name = "sandals"
	result_type = /obj/item/clothing/shoes/sandal

/decl/stack_recipe/planks/crossbowframe
	name = "crossbow frame"
	result_type = /obj/item/crossbowframe
	time = 25
	difficulty = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/planks/beehive_assembly
	name = "beehive assembly"
	result_type = /obj/item/beehive_assembly

/decl/stack_recipe/planks/beehive_frame
	name = "beehive frame"
	result_type = /obj/item/honey_frame

/decl/stack_recipe/planks/zipgunframe
	name = "zip gun frame"
	result_type = /obj/item/zipgunframe
	difficulty = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/planks/coilgun
	name = "coilgun stock"
	result_type = /obj/item/coilgun_assembly
	difficulty = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/planks/stick
	name = "stick"
	result_type = /obj/item/stick
	difficulty = MAT_VALUE_EASY_DIY

/decl/stack_recipe/planks/noticeboard
	name = "noticeboard"
	result_type = /obj/structure/noticeboard
	time = 50
	on_floor = 1
	difficulty = MAT_VALUE_HARD_DIY
	set_dir_on_spawn = FALSE

/decl/stack_recipe/planks/noticeboard/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	var/obj/structure/noticeboard/board = ..()
	if(istype(board) && user)
		board.set_dir(global.reverse_dir[user.dir])
	return board

/decl/stack_recipe/planks/prosthetic
	abstract_type = /decl/stack_recipe/planks/prosthetic
	difficulty = MAT_VALUE_EASY_DIY
	category = "prosthetics"
	var/prosthetic_species = SPECIES_HUMAN
	var/prosthetic_model = /decl/bodytype/prosthetic/wooden

/decl/stack_recipe/planks/prosthetic/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	var/obj/item/organ/external/limb = ..()
	if(limb)
		limb.set_species(prosthetic_species)
		limb.set_bodytype(prosthetic_model, override_material = (required_material != MATERIAL_FORBIDDEN ? mat?.type : null))
		limb.status |= ORGAN_CUT_AWAY
	return limb

/decl/stack_recipe/planks/prosthetic/left_arm
	name = "left arm"
	result_type = /obj/item/organ/external/arm

/decl/stack_recipe/planks/prosthetic/right_arm
	name = "right arm"
	result_type = /obj/item/organ/external/arm/right

/decl/stack_recipe/planks/prosthetic/left_leg
	name = "left leg"
	result_type = /obj/item/organ/external/leg

/decl/stack_recipe/planks/prosthetic/right_leg
	name = "right leg"
	result_type = /obj/item/organ/external/leg/right

/decl/stack_recipe/planks/prosthetic/left_hand
	name = "left hand"
	result_type = /obj/item/organ/external/hand

/decl/stack_recipe/planks/prosthetic/right_hand
	name = "right hand"
	result_type = /obj/item/organ/external/hand/right

/decl/stack_recipe/planks/prosthetic/left_foot
	name = "left foot"
	result_type = /obj/item/organ/external/foot

/decl/stack_recipe/planks/prosthetic/right_foot
	name = "right foot"
	result_type = /obj/item/organ/external/foot/right

/decl/stack_recipe/planks/furniture
	abstract_type = /decl/stack_recipe/planks/furniture
	one_per_turf = TRUE
	on_floor = 1
	difficulty = MAT_VALUE_HARD_DIY
	time = 5

/decl/stack_recipe/planks/furniture/coffin
	name = "coffin"
	result_type = /obj/structure/closet/coffin/wooden
	time = 15

/decl/stack_recipe/planks/furniture/sofa
	name = "sofa, middle"
	result_type = /obj/structure/bed/sofa/middle
	category = "seating"

/decl/stack_recipe/planks/furniture/sofa/left
	name = "sofa, left"
	result_type = /obj/structure/bed/sofa/left

/decl/stack_recipe/planks/furniture/sofa/right
	name = "sofa, right"
	result_type = /obj/structure/bed/sofa/right

/decl/stack_recipe/planks/furniture/bookcase
	name = "book shelf"
	result_type = /obj/structure/bookcase
	time = 15

/decl/stack_recipe/planks/furniture/book_cart
	name = "book cart"
	result_type = /obj/structure/bookcase/cart
	time = 15

/decl/stack_recipe/planks/furniture/chair
	name = "chair"
	result_type = /obj/structure/bed/chair/wood
	category = "seating"

/decl/stack_recipe/planks/furniture/chair/fancy
	name = "winged chair"
	result_type = /obj/structure/bed/chair/wood/wings
