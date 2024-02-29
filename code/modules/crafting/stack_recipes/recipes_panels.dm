/decl/stack_recipe/panels
	abstract_type     = /decl/stack_recipe/panels
	craft_stack_types = /obj/item/stack/material/panel

/decl/stack_recipe/panels/bag
	name              = "bag"
	result_type       = /obj/item/storage/bag/plasticbag
	on_floor          = TRUE

/decl/stack_recipe/panels/ivbag
	name              = "IV bag"
	result_type       = /obj/item/chems/ivbag
	difficulty        = MAT_VALUE_HARD_DIY

/decl/stack_recipe/panels/cartridge
	name              = "dispenser cartridge"
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

/decl/stack_recipe/panels/tile
	abstract_type     = /decl/stack_recipe/panels/tile
	category          = "tiling"

/decl/stack_recipe/panels/tile/floor
	name              = "white floor tile"
	result_type       = /obj/item/stack/tile/floor_white

/decl/stack_recipe/panels/tile/freezer
	name              = "freezer floor tile"
	result_type       = /obj/item/stack/tile/floor_freezer

/decl/stack_recipe/panels/hazard_cone
	name              = "hazard cone"
	result_type       = /obj/item/caution/cone
	on_floor          = TRUE

/decl/stack_recipe/panels/furniture
	abstract_type     = /decl/stack_recipe/panels/furniture
	one_per_turf      = TRUE
	on_floor          = TRUE
	difficulty        = MAT_VALUE_HARD_DIY
	time              = 5 SECONDS

/decl/stack_recipe/panels/furniture/crate
	result_type       = /obj/structure/closet/crate/plastic

/decl/stack_recipe/panels/furniture/flaps
	name              = "flaps"
	result_type       = /obj/structure/plasticflaps
