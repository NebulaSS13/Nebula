//Recipes that produce items which aren't stacks or storage.
/decl/stack_recipe/grenade
	result_type       = /obj/item/grenade/chem_grenade
	difficulty        = MAT_VALUE_VERY_HARD_DIY
	required_material = /decl/material/solid/metal/aluminium
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	category          = "weapons"

/decl/stack_recipe/candle
	result_type       = /obj/item/flame/candle/handmade
	difficulty        = MAT_VALUE_EASY_DIY
	required_material = /decl/material/solid/organic/wax

/decl/stack_recipe/scroll
	name              = "scroll"
	result_type       = /obj/item/paper/scroll
	required_material = /decl/material/solid/organic/paper

/decl/stack_recipe/paper_sheets
	name              = "sheet of paper"
	result_type       = /obj/item/paper
	required_material = /decl/material/solid/organic/paper

/decl/stack_recipe/paper_sheets/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat, paint_color, spent_type, spent_amount = 1)
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

// These don't check hardness so that you can make them out of clay and fire them, I guess?
// They used to be in the hardness-based recipes file but aren't now.
/decl/stack_recipe/ring
	result_type         = /obj/item/clothing/gloves/ring
	validation_material = /decl/material/solid/metal/silver

/decl/stack_recipe/ring/thin
	name                = "ring, thin"
	result_type         = /obj/item/clothing/gloves/ring/thin

/decl/stack_recipe/ring/thick
	name                = "ring, thick"
	result_type         = /obj/item/clothing/gloves/ring/thick

/decl/stack_recipe/ring/split
	name                = "ring, split"
	result_type         = /obj/item/clothing/gloves/ring/split