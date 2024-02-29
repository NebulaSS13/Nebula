/decl/stack_recipe/reinforced
	abstract_type = /decl/stack_recipe/reinforced
	craft_stack_types = /obj/item/stack/material/reinforced
	time = 5 SECONDS
	one_per_turf = TRUE
	difficulty = MAT_VALUE_HARD_DIY

/decl/stack_recipe/reinforced/ai_core
	name = "AI core"
	result_type = /obj/structure/aicore
	on_floor = FALSE

/decl/stack_recipe/reinforced/crate
	name = "crate"
	result_type = /obj/structure/closet/crate

/decl/stack_recipe/reinforced/grip
	name = "knife grip"
	result_type = /obj/item/butterflyhandle
	time = 2 SECONDS
	difficulty = MAT_VALUE_NORMAL_DIY
	one_per_turf = FALSE
