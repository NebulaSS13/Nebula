/decl/stack_recipe/logs
	abstract_type               = /decl/stack_recipe/logs
	craft_stack_types           = /obj/item/stack/material/log
	forbidden_craft_stack_types = /obj/item/stack/material/ore

/decl/stack_recipe/turfs/wall/logs
	name                        = "log wall"
	result_type                 = /turf/wall/log
	craft_stack_types           = /obj/item/stack/material/log
	forbidden_craft_stack_types = /obj/item/stack/material/ore
	difficulty                  = MAT_VALUE_HARD_DIY

/decl/stack_recipe/turfs/wall/logs/shutter
	name                        = "shuttered log wall"
	result_type                 = /turf/wall/log/shutter

/decl/stack_recipe/logs/wall_frame
	result_type                 = /obj/structure/wall_frame/log
	difficulty                  = MAT_VALUE_HARD_DIY