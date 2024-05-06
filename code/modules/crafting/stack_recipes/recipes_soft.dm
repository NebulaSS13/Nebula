/decl/stack_recipe/soft
	time                        = 1 SECOND
	abstract_type               = /decl/stack_recipe/soft
	craft_stack_types           = null
	forbidden_craft_stack_types = null
	required_min_hardness       = 0
	required_max_hardness       = MAT_VALUE_MALLEABLE
	crafting_extra_cost_factor  = 1 // No wastage for just resculpting materials.

/decl/stack_recipe/soft/teapot
	result_type                 = /obj/item/chems/glass/pottery/teapot

/decl/stack_recipe/soft/cup
	result_type                 = /obj/item/chems/glass/pottery/cup

/decl/stack_recipe/soft/mug
	result_type                 = /obj/item/chems/glass/pottery/mug

/decl/stack_recipe/soft/vase
	result_type                 = /obj/item/chems/glass/pottery/vase

/decl/stack_recipe/soft/bowl
	result_type                 = /obj/item/chems/glass/pottery/bowl

/decl/stack_recipe/soft/jar
	result_type                 = /obj/item/chems/glass/pottery/jar

/decl/stack_recipe/soft/bottle
	result_type                 = /obj/item/chems/glass/pottery/bottle

/decl/stack_recipe/soft/bottle_wide
	result_type                 = /obj/item/chems/glass/pottery/bottle/wide

/decl/stack_recipe/soft/bottle_tall
	result_type                 = /obj/item/chems/glass/pottery/bottle/tall

/decl/stack_recipe/soft/stack
	name                        = "brick"
	name_plural                 = "bricks"
	result_type                 = /obj/item/stack/material/brick
	test_result_type            = /obj/item/stack/material/brick/clay

/decl/stack_recipe/soft/stack/spawn_result(user, location, amount)
	var/obj/item/stack/S = ..()
	if(istype(S))
		S.amount = amount
		if(user)
			S.add_to_stacks(user, 1)
	return S

/decl/stack_recipe/soft/stack/large_lump
	name                        = "large lump"
	name_plural                 = "large lumps"
	result_type                 = /obj/item/stack/material/lump/large
	test_result_type            = /obj/item/stack/material/lump/large/clay

/decl/stack_recipe/soft/stack/small_lump
	name                        = "small lump"
	name_plural                 = "small lumps"
	result_type                 = /obj/item/stack/material/lump
	test_result_type            = /obj/item/stack/material/lump/clay

/decl/stack_recipe/soft/crucible
	result_type = /obj/item/chems/crucible

/decl/stack_recipe/soft/mould
	name = "mould, blank"
	result_type = /obj/item/chems/mould
	category = "moulds"

/decl/stack_recipe/soft/mould/crucible
	name = "mould, crucible"
	result_type = /obj/item/chems/mould/crucible

/decl/stack_recipe/soft/mould/rod
	name = "mould, rod"
	result_type = /obj/item/chems/mould/rod

/decl/stack_recipe/soft/mould/ingot
	name = "mould, ingot"
	result_type = /obj/item/chems/mould/ingot
