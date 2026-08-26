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
	uid                        = "stack_recipe_brick_cup"

/decl/stack_recipe/bricks/mug
	result_type                = /obj/item/chems/glass/handmade/mug
	uid                        = "stack_recipe_brick_mug"

/decl/stack_recipe/bricks/bowl
	result_type                = /obj/item/chems/glass/handmade/bowl
	uid                        = "stack_recipe_brick_bowl"

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
	uid                        = "stack_recipe_brick_firepit"

/decl/stack_recipe/bricks/fire_source/kiln
	result_type                = /obj/structure/fire_source/kiln
	uid                        = "stack_recipe_brick_kiln"

/decl/stack_recipe/bricks/fire_source/alembic
	result_type                = /obj/structure/fire_source/heater
	uid                        = "stack_recipe_brick_alembic"

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
	uid                        = "stack_recipe_brick_pillar_square"

/decl/stack_recipe/bricks/furniture/pillar/narrow
	name                       = "pillar, narrow"
	result_type                = /obj/structure/pillar/narrow
	uid                        = "stack_recipe_brick_pillar_narrow"

/decl/stack_recipe/bricks/furniture/pillar/triad
	name                       = "pillar, triad"
	result_type                = /obj/structure/pillar/triad
	uid                        = "stack_recipe_brick_pillar_triad"

/decl/stack_recipe/bricks/furniture/pillar/round
	name                       = "pillar, round"
	result_type                = /obj/structure/pillar/round
	uid                        = "stack_recipe_brick_pillar_round"

/decl/stack_recipe/bricks/furniture/pillar/wide_round
	name                       = "pillar, wide round"
	result_type                = /obj/structure/pillar/wide
	uid                        = "stack_recipe_brick_pillar_wide_round"

/decl/stack_recipe/bricks/furniture/pillar/wide_square
	name                       = "pillar, wide square"
	result_type                = /obj/structure/pillar/wide/square
	uid                        = "stack_recipe_brick_pillar_wide_square"

/decl/stack_recipe/bricks/furniture/pillar/wide_inset
	name                       = "pillar, wide inset"
	result_type                = /obj/structure/pillar/wide/inset
	uid                        = "stack_recipe_brick_wide_inset"

/decl/stack_recipe/bricks/furniture/pillar/pedestal
	name                       = "pedestal, square"
	result_type                = /obj/structure/pedestal
	uid                        = "stack_recipe_brick_pedestal_square"

/decl/stack_recipe/bricks/furniture/pillar/pedestal_narrow
	name                       = "pedestal, narrow"
	result_type                = /obj/structure/pedestal/narrow
	uid                        = "stack_recipe_brick_pedestal_narrow"

/decl/stack_recipe/bricks/furniture/pillar/pedestal_triad
	name                       = "pedestal, triad"
	result_type                = /obj/structure/pedestal/triad
	uid                        = "stack_recipe_brick_pedestal_triad"

/decl/stack_recipe/bricks/furniture/pillar/pedestal_round
	name                       = "pedestal, round"
	result_type                = /obj/structure/pedestal/round
	uid                        = "stack_recipe_brick_pedestal_round"

/decl/stack_recipe/bricks/furniture/fence
	result_type                = /obj/structure/fence/brick
	difficulty                 = MAT_VALUE_NORMAL_DIY
	uid                        = "stack_recipe_brick_fence"

/decl/stack_recipe/bricks/furniture/fence_door
	result_type                = /obj/structure/fence/door/brick
	difficulty                 = MAT_VALUE_NORMAL_DIY
	uid                        = "stack_recipe_brick_fence_door"

/decl/stack_recipe/bricks/gravestone
	result_type                = /obj/item/gravemarker/gravestone
	difficulty                 = MAT_VALUE_NORMAL_DIY
	uid                        = "stack_recipe_brick_gravestone"

/decl/stack_recipe/bricks/fountain
	result_type                = /obj/structure/fountain/mundane
	one_per_turf               = TRUE
	on_floor                   = TRUE
	difficulty                 = MAT_VALUE_VERY_HARD_DIY
	uid                        = "stack_recipe_brick_fountain"

/decl/stack_recipe/bricks/fountain/well
	result_type                = /obj/structure/reagent_dispensers/well
	uid                        = "stack_recipe_brick_well"

/decl/stack_recipe/bricks/fountain/wall
	result_type                = /obj/structure/reagent_dispensers/well/wall_fountain
	uid                        = "stack_recipe_brick_wall_fountain"

/decl/stack_recipe/turfs/wall/brick
	name                       = "brick wall"
	result_type                = /turf/wall/brick
	craft_stack_types          = /obj/item/stack/material/brick
	difficulty                 = MAT_VALUE_HARD_DIY
	validation_material        = /decl/material/solid/stone/basalt
	uid                        = "stack_recipe_brick_wall"

/decl/stack_recipe/turfs/wall/brick/shutter
	name                       = "shuttered brick wall"
	result_type                = /turf/wall/brick/shutter
	uid                        = "stack_recipe_brick_wall_shutter"

/decl/stack_recipe/turfs/floor/brick
	name                       = "cobblestone path"
	result_type                = /turf/floor/path
	craft_stack_types          = /obj/item/stack/material/brick
	validation_material        = /decl/material/solid/stone/basalt
	uid                        = "stack_recipe_brick_path_cobblestone"

/decl/stack_recipe/turfs/floor/brick/herringbone
	name                       = "herringbone path"
	result_type                = /turf/floor/path/herringbone
	difficulty                 = MAT_VALUE_HARD_DIY
	uid                        = "stack_recipe_brick_path_herringbone"

/decl/stack_recipe/turfs/floor/brick/running_bond
	name                       = "running bond path"
	result_type                = /turf/floor/path/running_bond
	difficulty                 = MAT_VALUE_HARD_DIY
	uid                        = "stack_recipe_brick_path_running_bond"
