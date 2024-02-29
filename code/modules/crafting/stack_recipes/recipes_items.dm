//Recipes that produce items which aren't stacks or storage.
/decl/stack_recipe/grenade
	result_type       = /obj/item/grenade/chem_grenade
	difficulty        = MAT_VALUE_VERY_HARD_DIY
	required_material = /decl/material/solid/metal/aluminium

/decl/stack_recipe/candle
	result_type       = /obj/item/flame/candle
	difficulty        = MAT_VALUE_EASY_DIY
	required_material = /decl/material/solid/organic/wax

/decl/stack_recipe/paper_sheets
	name              = "sheet of paper"
	result_type       = /obj/item/paper
	res_amount        = 4
	max_res_amount    = 30
	required_material = /decl/material/solid/organic/paper

/decl/stack_recipe/paper_sheets/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	var/obj/item/paper/P = ..()
	if(amount > 1)
		var/obj/item/paper_bundle/B = new(location)
		B.merge(P)
		for(var/i = 1 to (amount - 1))
			if(B.get_amount_papers() >= B.max_pages)
				B = new(location)
			B.merge(new /obj/item/paper(location))
		return B
	return P