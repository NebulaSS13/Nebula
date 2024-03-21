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

/decl/stack_recipe/bricks/firepit
	on_floor                    = TRUE
	one_per_turf                = TRUE
	apply_material_name         = FALSE
	result_type                 = /obj/structure/fire_source/firepit

/decl/stack_recipe/bricks/firepit/kiln
	result_type                 = /obj/structure/fire_source/kiln

/decl/stack_recipe/bricks/furniture
	abstract_type              = /decl/stack_recipe/bricks/furniture
	one_per_turf               = TRUE
	on_floor                   = TRUE
	difficulty                 = MAT_VALUE_HARD_DIY

/decl/stack_recipe/bricks/furniture/planting_bed
	result_type                = /obj/machinery/portable_atmospherics/hydroponics/soil
	req_amount                 = 3 * SHEET_MATERIAL_AMOUNT // Arbitrary value since machines don't handle matter properly yet.

/decl/stack_recipe/bricks/furniture/planting_bed/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat, paint_color)
	return list(new result_type(location))

/decl/stack_recipe/bricks/fountain
	result_type                = /obj/structure/fountain/mundane
	one_per_turf               = TRUE
	on_floor                   = TRUE
	difficulty                 = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/turfs/wall/brick
	name                       = "brick wall"
	result_type                = /turf/wall/brick
	craft_stack_types          = /obj/item/stack/material/brick
	difficulty                 = MAT_VALUE_HARD_DIY

/decl/stack_recipe/turfs/path/brick
	name                       = "cobblestone path"
	result_type                = /turf/exterior/path
	craft_stack_types          = /obj/item/stack/material/brick

/decl/stack_recipe/turfs/path/brick/herringbone
	name                       = "herringbone path"
	result_type                = /turf/exterior/path/herringbone
	difficulty                 = MAT_VALUE_HARD_DIY

/decl/stack_recipe/turfs/path/brick/running_bond
	name                       = "running bond path"
	result_type                = /turf/exterior/path/running_bond
	difficulty                 = MAT_VALUE_HARD_DIY
