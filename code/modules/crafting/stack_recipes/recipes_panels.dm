/decl/stack_recipe/panels
	abstract_type     = /decl/stack_recipe/panels
	craft_stack_types = /obj/item/stack/material/panel
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	validation_material = /decl/material/solid/organic/plastic

/decl/stack_recipe/panels/bag
	result_type       = /obj/item/bag/flimsy
	on_floor          = TRUE

/decl/stack_recipe/panels/ivbag
	result_type       = /obj/item/chems/ivbag
	difficulty        = MAT_VALUE_HARD_DIY

/decl/stack_recipe/panels/cartridge
	difficulty        = MAT_VALUE_HARD_DIY
	category          = "dispenser cartridges"
	abstract_type     = /decl/stack_recipe/panels/cartridge

/decl/stack_recipe/panels/cartridge/small
	name              = "small dispenser cartridge"
	result_type       = /obj/item/chems/chem_disp_cartridge/small

/decl/stack_recipe/panels/cartridge/medium
	name              = "medium dispenser cartridge"
	result_type       = /obj/item/chems/chem_disp_cartridge/medium

/decl/stack_recipe/panels/cartridge/large
	name              = "large dispenser cartridge"
	result_type       = /obj/item/chems/chem_disp_cartridge

/decl/stack_recipe/panels/hazard_cone
	result_type       = /obj/item/caution/cone
	on_floor          = TRUE

/decl/stack_recipe/panels/furniture
	abstract_type     = /decl/stack_recipe/panels/furniture
	one_per_turf      = TRUE
	on_floor          = TRUE
	difficulty        = MAT_VALUE_HARD_DIY
	category          = "furniture"

/decl/stack_recipe/panels/furniture/crate
	result_type       = /obj/structure/closet/crate/plastic

/decl/stack_recipe/panels/furniture/flaps
	result_type       = /obj/structure/flaps
