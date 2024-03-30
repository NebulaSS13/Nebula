/decl/stack_recipe/clay
	time                        = 1 SECOND
	abstract_type               = /decl/stack_recipe/clay
	required_material           = /decl/material/solid/clay
	craft_stack_types           = null
	forbidden_craft_stack_types = null

/decl/stack_recipe/clay/teapot
	result_type                 = /obj/item/chems/glass/pottery/teapot

/decl/stack_recipe/clay/cup
	result_type                 = /obj/item/chems/glass/pottery/cup

/decl/stack_recipe/clay/mug
	result_type                 = /obj/item/chems/glass/pottery/mug

/decl/stack_recipe/clay/vase
	result_type                 = /obj/item/chems/glass/pottery/vase

/decl/stack_recipe/clay/bowl
	result_type                 = /obj/item/chems/glass/pottery/bowl

/decl/stack_recipe/clay/brick
	name_plural                 = "bricks"
	result_type                 = /obj/item/stack/material/brick/clay

/decl/stack_recipe/clay/brick/spawn_result(user, location, amount)
	var/obj/item/stack/S = ..()
	if(istype(S))
		S.amount = amount
		if(user)
			S.add_to_stacks(user, 1)
	return S
