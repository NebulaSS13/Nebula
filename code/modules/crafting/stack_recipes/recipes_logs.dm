/decl/stack_recipe/logs
	abstract_type               = /decl/stack_recipe/logs
	craft_stack_types           = /obj/item/stack/material/log
	forbidden_craft_stack_types = /obj/item/stack/material/ore

/decl/stack_recipe/logs/campfire
	on_floor                    = TRUE
	one_per_turf                = TRUE
	apply_material_name         = FALSE
	result_type                 = /obj/structure/fire_source

// TODO: make this a firepit recipe using bricks or something instead.
/decl/stack_recipe/logs/campfire/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	var/obj/structure/fire_source/product = ..(user, location, amount) // Discard the material since we're putting it into the fuel var.
	if(product)
		product.matter = null
		product.material = null
		product.update_materials(TRUE)
		if(mat?.accelerant_value > FUEL_VALUE_NONE)
			product.fuel += round(mat.accelerant_value * (req_amount * (amount / res_amount) * SHEET_MATERIAL_AMOUNT))
	return product
