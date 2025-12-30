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
	validation_material        = /decl/material/solid/stone/basalt
	category                   = "structures"

/decl/stack_recipe/bricks/cup
	result_type                = /obj/item/chems/glass/handmade/cup

/decl/stack_recipe/bricks/mug
	result_type                = /obj/item/chems/glass/handmade/mug

/decl/stack_recipe/bricks/bowl
	result_type                = /obj/item/chems/glass/handmade/bowl

/decl/stack_recipe/bricks/fire_source
	abstract_type              = /decl/stack_recipe/bricks/fire_source
	on_floor                   = TRUE
	one_per_turf               = TRUE
	apply_material_name        = FALSE
	category                   = "fire sources"
	difficulty                 = MAT_VALUE_NORMAL_DIY

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
	difficulty                 = MAT_VALUE_EASY_DIY

/decl/stack_recipe/bricks/fire_source/kiln
	result_type                = /obj/structure/fire_source/kiln

/decl/stack_recipe/bricks/fire_source/alembic
	result_type                = /obj/structure/fire_source/heater

/decl/stack_recipe/bricks/furniture
	abstract_type              = /decl/stack_recipe/bricks/furniture
	one_per_turf               = TRUE
	on_floor                   = TRUE
	difficulty                 = MAT_VALUE_HARD_DIY
	category                   = "furniture"

/decl/stack_recipe/bricks/furniture/pillar
	name                       = "pillar, square"
	result_type                = /obj/structure/pillar
	category                   = "structures"

/decl/stack_recipe/bricks/furniture/pillar/narrow
	name                       = "pillar, narrow"
	result_type                = /obj/structure/pillar/narrow

/decl/stack_recipe/bricks/furniture/pillar/triad
	name                       = "pillar, triad"
	result_type                = /obj/structure/pillar/triad

/decl/stack_recipe/bricks/furniture/pillar/round
	name                       = "pillar, round"
	result_type                = /obj/structure/pillar/round

/decl/stack_recipe/bricks/furniture/pillar/wide_round
	name                       = "pillar, wide round"
	result_type                = /obj/structure/pillar/wide

/decl/stack_recipe/bricks/furniture/pillar/wide_square
	name                       = "pillar, wide square"

	result_type                = /obj/structure/pillar/wide/square

/decl/stack_recipe/bricks/furniture/pillar/wide_inset
	name                       = "pillar, wide inset"
	result_type                = /obj/structure/pillar/wide/inset

/decl/stack_recipe/bricks/furniture/pillar/pedestal
	name                       = "pedestal, square"
	result_type                = /obj/structure/pedestal

/decl/stack_recipe/bricks/furniture/pillar/pedestal_narrow
	name                       = "pedestal, narrow"
	result_type                = /obj/structure/pedestal/narrow

/decl/stack_recipe/bricks/furniture/pillar/pedestal_triad
	name                       = "pedestal, triad"
	result_type                = /obj/structure/pedestal/triad

/decl/stack_recipe/bricks/furniture/pillar/pedestal_round
	name                       = "pedestal, round"
	result_type                = /obj/structure/pedestal/round

/decl/stack_recipe/bricks/gravestone
	result_type                = /obj/item/gravemarker/gravestone
	difficulty                 = MAT_VALUE_NORMAL_DIY

/decl/stack_recipe/bricks/fountain
	result_type                = /obj/structure/fountain/mundane
	one_per_turf               = TRUE
	on_floor                   = TRUE
	difficulty                 = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/bricks/fountain/well
	result_type                = /obj/structure/reagent_dispensers/well

/decl/stack_recipe/bricks/fountain/wall
	result_type                = /obj/structure/reagent_dispensers/well/wall_fountain

/decl/stack_recipe/turfs/wall/brick
	name                       = "brick wall"
	result_type                = /turf/wall/brick
	craft_stack_types          = /obj/item/stack/material/brick
	difficulty                 = MAT_VALUE_HARD_DIY
	validation_material        = /decl/material/solid/stone/basalt

/decl/stack_recipe/turfs/wall/brick/shutter
	name                       = "shuttered brick wall"
	result_type                = /turf/wall/brick/shutter

/decl/stack_recipe/turfs/floor/brick
	name                       = "cobblestone path"
	result_type                = /turf/floor/path
	craft_stack_types          = /obj/item/stack/material/brick
	validation_material        = /decl/material/solid/stone/basalt

/decl/stack_recipe/turfs/floor/brick/herringbone
	name                       = "herringbone path"
	result_type                = /turf/floor/path/herringbone
	difficulty                 = MAT_VALUE_HARD_DIY

/decl/stack_recipe/turfs/floor/brick/running_bond
	name                       = "running bond path"
	result_type                = /turf/floor/path/running_bond
	difficulty                 = MAT_VALUE_HARD_DIY
