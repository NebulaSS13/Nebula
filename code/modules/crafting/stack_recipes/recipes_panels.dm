/decl/stack_recipe/panels
	abstract_type     = /decl/stack_recipe/panels
	craft_stack_types = /obj/item/stack/material/panel
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	validation_material = /decl/material/solid/organic/plastic

/decl/stack_recipe/panels/bag
	result_type       = /obj/item/bag/flimsy
	on_floor          = TRUE
	uid               = "stack_recipe_panel_flimsy_bag"

/decl/stack_recipe/panels/ivbag
	result_type       = /obj/item/chems/ivbag
	difficulty        = MAT_VALUE_HARD_DIY
	uid               = "stack_recipe_panel_iv_bag"

/decl/stack_recipe/panels/cartridge
	difficulty        = MAT_VALUE_HARD_DIY
	category          = "dispenser cartridges"
	abstract_type     = /decl/stack_recipe/panels/cartridge

/decl/stack_recipe/panels/cartridge/small
	name              = "small dispenser cartridge"
	result_type       = /obj/item/chems/chem_disp_cartridge/small
	uid               = "stack_recipe_panel_dispenser_cartridge_small"

/decl/stack_recipe/panels/cartridge/medium
	name              = "medium dispenser cartridge"
	result_type       = /obj/item/chems/chem_disp_cartridge/medium
	uid               = "stack_recipe_panel_dispenser_cartridge_medium"

/decl/stack_recipe/panels/cartridge/large
	name              = "large dispenser cartridge"
	result_type       = /obj/item/chems/chem_disp_cartridge
	uid               = "stack_recipe_panel_dispenser_cartridge_large"

/decl/stack_recipe/panels/hazard_cone
	result_type       = /obj/item/caution/cone
	on_floor          = TRUE
	uid               = "stack_recipe_panel_caution_cone"

/decl/stack_recipe/panels/furniture
	abstract_type     = /decl/stack_recipe/panels/furniture
	one_per_turf      = TRUE
	on_floor          = TRUE
	difficulty        = MAT_VALUE_HARD_DIY
	category          = "furniture"

/decl/stack_recipe/panels/furniture/crate
	result_type       = /obj/structure/closet/crate/plastic
	uid               = "stack_recipe_panel_crate"

/decl/stack_recipe/panels/furniture/flaps
	result_type       = /obj/structure/flaps
	uid               = "stack_recipe_panel_flaps"
