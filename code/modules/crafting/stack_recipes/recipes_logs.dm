/decl/stack_recipe/logs
	abstract_type              = /decl/stack_recipe/logs
	craft_stack_types          = /obj/item/stack/material/log
	forbidden_craft_stack_type = /obj/item/stack/material/ore

/decl/stack_recipe/logs/campfire
	name                       = "campfire"
	time                       = 4 SECONDS
	on_floor                   = TRUE
	one_per_turf               = TRUE
	apply_material_name        = FALSE
	result_type                = /obj/structure/fire_source

/decl/stack_recipe/logs/campfire/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	var/obj/structure/fire_source/product = ..()
	for(var/material in product.matter)
		var/decl/material/material_decl = GET_DECL(mat)
		if(material_decl.accelerant_value > FUEL_VALUE_NONE)
			product.fuel += material_decl.accelerant_value * round(product.matter[material] / SHEET_MATERIAL_AMOUNT)
	return product
