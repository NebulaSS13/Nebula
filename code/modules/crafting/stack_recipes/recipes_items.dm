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
	. = ..()
	if(amount <= 1)
		return .
	var/obj/item/paper_bundle/bundle = new (location)
	var/list/bundles = list(bundle)
	var/remaining = amount
	for(var/obj/item/paper/paper in .)
		remaining--
		if(bundle.get_amount_papers() >= bundle.max_pages)
			if(remaining == 0)
				bundles += paper // not a bundle, this is an exception for single overflow pages
				break
			bundle = new(location)
			bundles += bundle
		bundle.merge(paper)
	return bundles