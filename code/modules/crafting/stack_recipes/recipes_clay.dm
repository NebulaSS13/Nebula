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

/decl/stack_recipe/soft/stack
	name_plural                 = "bricks"
	result_type                 = /obj/item/stack/material/brick/clay

/decl/stack_recipe/soft/stack/spawn_result(user, location, amount)
	var/obj/item/stack/S = ..()
	if(istype(S))
		S.amount = amount
		if(user)
			S.add_to_stacks(user, 1)
	return S

/decl/stack_recipe/soft/stack/large_lump
	name_plural                 = "large lumps"
	result_type                 = /obj/item/stack/material/lump/large/clay

/decl/stack_recipe/soft/stack/small_lump
	name_plural                 = "lumps"
	result_type                 = /obj/item/stack/material/lump/clay
