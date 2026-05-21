/decl/stack_recipe/logs
	abstract_type               = /decl/stack_recipe/logs
	craft_stack_types           = /obj/item/stack/material/log
	forbidden_craft_stack_types = /obj/item/stack/material/ore
	validation_material         = /decl/material/solid/organic/wood/oak

/decl/stack_recipe/logs/travois
	result_type                 = /obj/structure/travois
	difficulty                  = MAT_VALUE_EASY_DIY

/decl/stack_recipe/turfs/wall/logs
	name                        = "log wall"
	result_type                 = /turf/wall/log
	craft_stack_types           = /obj/item/stack/material/log
	forbidden_craft_stack_types = /obj/item/stack/material/ore
	validation_material         = /decl/material/solid/organic/wood/oak
	difficulty                  = MAT_VALUE_HARD_DIY

/decl/stack_recipe/turfs/wall/logs/shutter
	name                        = "shuttered log wall"
	result_type                 = /turf/wall/log/shutter

/decl/stack_recipe/logs/wall_frame
	result_type                 = /obj/structure/wall_frame/log
	difficulty                  = MAT_VALUE_HARD_DIY

/decl/stack_recipe/logs/furniture
	abstract_type          = /decl/stack_recipe/logs/furniture
	one_per_turf           = TRUE
	on_floor               = TRUE
	difficulty             = MAT_VALUE_HARD_DIY
	category               = "furniture"

/decl/stack_recipe/logs/furniture/fence
	result_type            = /obj/structure/fence/palisade
	difficulty             = MAT_VALUE_NORMAL_DIY

/decl/stack_recipe/logs/furniture/fence_door
	result_type            = /obj/structure/fence/door/palisade
	difficulty             = MAT_VALUE_NORMAL_DIY
