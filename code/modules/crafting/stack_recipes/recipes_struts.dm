/decl/stack_recipe/strut
	abstract_type               = /decl/stack_recipe/strut
	craft_stack_types           = list(
		/obj/item/stack/material/strut,
		/obj/item/stack/material/bone
	)
	one_per_turf                = TRUE
	on_floor                    = TRUE
	difficulty                  = MAT_VALUE_HARD_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/strut/railing
	result_type = /obj/structure/railing

/decl/stack_recipe/strut/ladder
	result_type                 = /obj/structure/ladder
	on_floor                    = FALSE
	required_wall_support_value = 10

/decl/stack_recipe/strut/girder
	result_type                 = /obj/structure/girder
	required_wall_support_value = 10
	req_amount                  = 5 * SHEET_MATERIAL_AMOUNT // Arbitrary value since girders return weird matter values.

/decl/stack_recipe/strut/wall_frame
	result_type                 = /obj/structure/wall_frame

/decl/stack_recipe/strut/table_frame
	result_type                 = /obj/structure/table/frame

/decl/stack_recipe/strut/rack
	result_type                 = /obj/structure/rack

/decl/stack_recipe/strut/butcher_hook
	result_type                 = /obj/structure/meat_hook
	one_per_turf                = TRUE
	difficulty                  = MAT_VALUE_NORMAL_DIY

/decl/stack_recipe/strut/bed
	result_type                 = /obj/structure/bed
	required_integrity          = 50
	required_hardness           = MAT_VALUE_FLEXIBLE + 10

/decl/stack_recipe/strut/machine
	result_type                 = /obj/machinery/constructable_frame/machine_frame
	req_amount                  = 5 * SHEET_MATERIAL_AMOUNT // Arbitrary value since machines don't handle matter properly yet.
	required_material           = /decl/material/solid/metal/steel

/decl/stack_recipe/strut/machine/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat, paint_color)
	return ..(user, location, amount, null, null)
