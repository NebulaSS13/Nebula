/decl/stack_recipe/reinforced
	abstract_type               = /decl/stack_recipe/reinforced
	craft_stack_types           = /obj/item/stack/material/sheet/reinforced
	one_per_turf                = TRUE
	difficulty                  = MAT_VALUE_HARD_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	validation_material         = /decl/material/solid/metal/plasteel

/decl/stack_recipe/reinforced/ai_core
	result_type       = /obj/structure/aicore
	on_floor          = FALSE
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	category          = "furniture"

/decl/stack_recipe/reinforced/crate
	result_type       = /obj/structure/closet/crate
	category          = "furniture"

/decl/stack_recipe/reinforced/grip
	result_type       = /obj/item/butterflyhandle
	difficulty        = MAT_VALUE_NORMAL_DIY
	one_per_turf      = FALSE
	category          = "weapons"
