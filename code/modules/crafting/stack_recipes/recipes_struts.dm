/decl/stack_recipe/rods
	abstract_type               = /decl/stack_recipe/rods
	craft_stack_types           = list(
		/obj/item/stack/material/rods,
		/obj/item/stack/material/bone
	)
	one_per_turf                = TRUE
	on_floor                    = TRUE
	difficulty                  = MAT_VALUE_HARD_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_MEDIEVAL
	category                    = "structures"

/decl/stack_recipe/rods/stick
	result_type                 = /obj/item/stick
	one_per_turf                = FALSE
	on_floor                    = FALSE
	difficulty                  = MAT_VALUE_EASY_DIY
	category                    = "items"

/decl/stack_recipe/rods/stick/staff
	result_type                 = /obj/item/staff
	difficulty                  = MAT_VALUE_NORMAL_DIY

/decl/stack_recipe/rods/stick/cane
	result_type                 = /obj/item/cane
	difficulty                  = MAT_VALUE_NORMAL_DIY

/decl/stack_recipe/rods/railing
	result_type                 = /obj/structure/railing

/decl/stack_recipe/rods/ladder
	result_type                 = /obj/structure/ladder
	on_floor                    = FALSE
	required_wall_support_value = 10

/decl/stack_recipe/rods/girder
	result_type                 = /obj/structure/girder
	required_wall_support_value = 10
	req_amount                  = 5 * SHEET_MATERIAL_AMOUNT // Arbitrary value since girders return weird matter values.
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/rods/wall_frame
	result_type                 = /obj/structure/wall_frame
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/rods/table_frame
	result_type                 = /obj/structure/table/frame
	category                    = "furniture"

/decl/stack_recipe/rods/rack
	result_type                 = /obj/structure/rack
	category                    = "furniture"

/decl/stack_recipe/rods/butcher_hook
	result_type                 = /obj/structure/meat_hook
	one_per_turf                = TRUE
	difficulty                  = MAT_VALUE_NORMAL_DIY
	category                    = "furniture"

/decl/stack_recipe/rods/bed
	result_type                 = /obj/structure/bed
	required_integrity          = 50
	required_min_hardness       = MAT_VALUE_FLEXIBLE + 10
	category                    = "furniture"

/decl/stack_recipe/rods/machine
	result_type                 = /obj/machinery/constructable_frame/machine_frame
	req_amount                  = 5 * SHEET_MATERIAL_AMOUNT // Arbitrary value since machines don't handle matter properly yet.
	required_material           = /decl/material/solid/metal/steel
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/rods/machine/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat, paint_color, spent_type, spent_amount = 1)
	return ..(user, location, amount, null, null, paint_color, spent_type, spent_amount)
