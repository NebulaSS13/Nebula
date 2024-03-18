/decl/stack_recipe/tool
	abstract_type               = /decl/stack_recipe/tool
	forbidden_craft_stack_types = null
	craft_stack_types           = list(
		/obj/item/stack/material/ore,
		/obj/item/stack/material/lump,
		/obj/item/stack/material/plank
	)

/decl/stack_recipe/tool/handle
	abstract_type               = /decl/stack_recipe/tool/handle
	difficulty                  = MAT_VALUE_NORMAL_DIY
	craft_stack_types = list(
		/obj/item/stack/material/plank,
		/obj/item/stack/material/rods
	)

/decl/stack_recipe/tool/handle/long
	result_type                 = /obj/item/tool_component/handle/long

/decl/stack_recipe/tool/handle/short
	result_type                 = /obj/item/tool_component/handle/short

/decl/stack_recipe/tool/head
	abstract_type               = /decl/stack_recipe/tool/head
	difficulty                  = MAT_VALUE_HARD_DIY

/decl/stack_recipe/tool/head/hammer
	result_type                 = /obj/item/tool_component/head/hammer

/decl/stack_recipe/tool/head/shovel
	result_type                 = /obj/item/tool_component/head/shovel

/decl/stack_recipe/tool/head/sledgehammer
	difficulty                  = MAT_VALUE_VERY_HARD_DIY
	result_type                 = /obj/item/tool_component/head/sledgehammer
	craft_stack_types           = list(
		/obj/item/stack/material/ore,
		/obj/item/stack/material/lump
	)

/decl/stack_recipe/tool/head/pickaxe
	difficulty                  = MAT_VALUE_VERY_HARD_DIY
	result_type                 = /obj/item/tool_component/head/pickaxe
	craft_stack_types           = list(
		/obj/item/stack/material/ore,
		/obj/item/stack/material/lump
	)
