/decl/stack_recipe/bricks
	abstract_type              = /decl/stack_recipe/bricks
	craft_stack_types          = list(
		/obj/item/stack/material/brick,
		/obj/item/stack/material/slab
	)
	forbidden_craft_stack_types = list(
		/obj/item/stack/material/ore,
		/obj/item/stack/material/log,
		/obj/item/stack/material/lump
	)

/decl/stack_recipe/bricks/furniture
	abstract_type              = /decl/stack_recipe/bricks/furniture
	one_per_turf               = TRUE
	on_floor                   = TRUE
	difficulty                 = MAT_VALUE_HARD_DIY

/decl/stack_recipe/bricks/furniture/planting_bed
	result_type                = /obj/machinery/portable_atmospherics/hydroponics/soil
	req_amount                 = 3 // Arbitrary value since machines don't handle matter properly yet.

/decl/stack_recipe/bricks/furniture/planting_bed/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	return new result_type(location)

/decl/stack_recipe/bricks/fountain
	result_type                = /obj/structure/fountain/mundane
	one_per_turf               = TRUE
	on_floor                   = TRUE
	difficulty                 = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/turfs/wall/brick
	result_type                =  /turf/simulated/wall/brick
	craft_stack_types          = /obj/item/stack/material/brick
