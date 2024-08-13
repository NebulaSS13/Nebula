/decl/stack_recipe/bricks
	abstract_type               = /decl/stack_recipe/bricks
	craft_stack_types           = list(
		/obj/item/stack/material/brick,
		/obj/item/stack/material/slab
	)
	forbidden_craft_stack_types = list(
		/obj/item/stack/material/ore,
		/obj/item/stack/material/log,
		/obj/item/stack/material/lump
	)
	category                    = "structures"

/decl/stack_recipe/bricks/cup
	result_type                = /obj/item/chems/glass/handmade/cup

/decl/stack_recipe/bricks/mug
	result_type                = /obj/item/chems/glass/handmade/mug

/decl/stack_recipe/bricks/bowl
	result_type                = /obj/item/chems/glass/handmade/bowl

/decl/stack_recipe/bricks/fire_source
	abstract_type               = /decl/stack_recipe/bricks/fire_source
	on_floor                    = TRUE
	one_per_turf                = TRUE
	apply_material_name         = FALSE
	category                    = "fire sources"

/decl/stack_recipe/bricks/fire_source/firepit
	result_type                 = /obj/structure/fire_source/firepit
	craft_stack_types           = list(
		/obj/item/stack/material/brick,
		/obj/item/stack/material/slab,
		/obj/item/stack/material/ore,
		/obj/item/stack/material/lump
	)
	forbidden_craft_stack_types = list(
		/obj/item/stack/material/log,
	)

/decl/stack_recipe/bricks/fire_source/kiln
	result_type                 = /obj/structure/fire_source/kiln

/decl/stack_recipe/bricks/fire_source/alembic
	result_type                 = /obj/structure/fire_source/heater

/decl/stack_recipe/bricks/furniture
	abstract_type              = /decl/stack_recipe/bricks/furniture
	one_per_turf               = TRUE
	on_floor                   = TRUE
	difficulty                 = MAT_VALUE_HARD_DIY
	category                   = "furniture"

/decl/stack_recipe/bricks/gravestone
	result_type            = /obj/item/gravemarker/gravestone
	difficulty             = MAT_VALUE_NORMAL_DIY

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

/decl/stack_recipe/turfs/wall/brick/shutter
	name                       = "shuttered brick wall"
	result_type                = /turf/wall/brick/shutter

/decl/stack_recipe/turfs/floor/brick
	name                       = "cobblestone path"
	result_type                = /turf/floor/natural/path
	craft_stack_types          = /obj/item/stack/material/brick

/decl/stack_recipe/turfs/floor/brick/herringbone
	name                       = "herringbone path"
	result_type                = /turf/floor/natural/path/herringbone
	difficulty                 = MAT_VALUE_HARD_DIY

/decl/stack_recipe/turfs/floor/brick/running_bond
	name                       = "running bond path"
	result_type                = /turf/floor/natural/path/running_bond
	difficulty                 = MAT_VALUE_HARD_DIY
