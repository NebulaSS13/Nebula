/decl/stack_recipe/tool
	category = "tool parts"
	abstract_type               = /decl/stack_recipe/tool
	forbidden_craft_stack_types = null
	craft_stack_types           = list(
		/obj/item/stack/material/ore,
		/obj/item/stack/material/lump,
		/obj/item/stack/material/plank
	)
	validation_material         = /decl/material/solid/stone/basalt

/decl/stack_recipe/tool/handle
	abstract_type               = /decl/stack_recipe/tool/handle
	difficulty                  = MAT_VALUE_NORMAL_DIY
	craft_stack_types = list(
		/obj/item/stack/material/plank,
		/obj/item/stack/material/rods,
		/obj/item/stack/material/bone
	)
	validation_material         = /decl/material/solid/organic/bone

/decl/stack_recipe/tool/handle/long
	result_type                 = /obj/item/tool_component/handle/long
	uid                         = "stack_recipe_tool_handle_long"

/decl/stack_recipe/tool/handle/short
	result_type                 = /obj/item/tool_component/handle/short
	uid                         = "stack_recipe_tool_handle_short"

/decl/stack_recipe/tool/head
	abstract_type               = /decl/stack_recipe/tool/head
	difficulty                  = MAT_VALUE_HARD_DIY

/decl/stack_recipe/tool/head/hammer
	result_type                 = /obj/item/tool_component/head/hammer
	uid                         = "stack_recipe_tool_head_hammer"

/decl/stack_recipe/tool/head/hoe
	result_type                 = /obj/item/tool_component/head/hoe
	uid                         = "stack_recipe_tool_head_hoe"

/decl/stack_recipe/tool/head/shovel
	result_type                 = /obj/item/tool_component/head/shovel
	uid                         = "stack_recipe_tool_head_shovel"

/decl/stack_recipe/tool/head/handaxe
	result_type                 = /obj/item/tool_component/head/handaxe
	uid                         = "stack_recipe_tool_head_handaxe"

/decl/stack_recipe/tool/head/sledgehammer
	difficulty                  = MAT_VALUE_VERY_HARD_DIY
	result_type                 = /obj/item/tool_component/head/sledgehammer
	craft_stack_types           = list(
		/obj/item/stack/material/ore,
		/obj/item/stack/material/lump
	)
	uid                         = "stack_recipe_tool_head_sledgehammer"

/decl/stack_recipe/tool/head/pickaxe
	difficulty                  = MAT_VALUE_VERY_HARD_DIY
	result_type                 = /obj/item/tool_component/head/pickaxe
	craft_stack_types           = list(
		/obj/item/stack/material/ore,
		/obj/item/stack/material/lump
	)
	uid                         = "stack_recipe_tool_head_pickaxe"
