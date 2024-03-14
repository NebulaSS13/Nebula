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
	. = ..(user, location, amount, null, null) // Discard the materials since we're putting it into the fuel var.
	for(var/obj/structure/fire_source/product in .)
		product.matter = null
		product.material = null
		product.update_materials(TRUE)
		if(mat?.accelerant_value > FUEL_VALUE_NONE)
			product.fuel += round(mat.accelerant_value * (req_amount * (amount / res_amount) * SHEET_MATERIAL_AMOUNT))

/decl/stack_recipe/turfs/wall/logs
	name                        = "log wall"
	result_type                 = /turf/wall/log
	craft_stack_types           = /obj/item/stack/material/log
	forbidden_craft_stack_types = /obj/item/stack/material/ore
	difficulty                  = MAT_VALUE_HARD_DIY
