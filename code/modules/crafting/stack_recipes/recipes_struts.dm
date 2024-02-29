/decl/stack_recipe/strut
	abstract_type               = /decl/stack_recipe/strut
	craft_stack_types           = list(
		/obj/item/stack/material/strut,
		/obj/item/stack/material/bone
	)
	one_per_turf                = TRUE
	on_floor                    = TRUE
	difficulty                  = MAT_VALUE_HARD_DIY
	time                        = 5 SECONDS

/decl/stack_recipe/strut/ladder
	name                        = "ladder"
	result_type                 = /obj/structure/ladder
	one_per_turf                = TRUE
	on_floor                    = FALSE
	required_wall_support_value = 10

/decl/stack_recipe/strut/girder
	name                        = "wall support"
	result_type                 = /obj/structure/girder
	required_wall_support_value = 10

/decl/stack_recipe/strut/wall_frame
	name                        = "low wall frame"
	result_type                 = /obj/structure/wall_frame

/decl/stack_recipe/strut/table_frame
	name                        = "table frame"
	result_type                 = /obj/structure/table/frame
	time                        = 1 SECOND

/decl/stack_recipe/strut/rack
	name                        = "rack"
	result_type                 = /obj/structure/rack

/decl/stack_recipe/strut/butcher_hook
	name                        = "meat hook"
	result_type                 = /obj/structure/kitchenspike
	time                        = 4 SECONDS
	one_per_turf                = TRUE
	difficulty                  = MAT_VALUE_NORMAL_DIY

/decl/stack_recipe/strut/bed
	name                        = "bed"
	result_type                 = /obj/structure/bed
	required_integrity          = 50
	required_hardness           = MAT_VALUE_FLEXIBLE + 10

/decl/stack_recipe/strut/machine
	name                        = "machine frame"
	result_type                 = /obj/machinery/constructable_frame/machine_frame
	req_amount                  = 5
	time                        = 2.5 SECONDS
	required_material           = /decl/material/solid/metal/steel

/decl/stack_recipe/strut/machine/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	return new result_type(location)
