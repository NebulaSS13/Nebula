// Tiles
/decl/stack_recipe/tile
	abstract_type       = /decl/stack_recipe/tile
	difficulty          = MAT_VALUE_NORMAL_DIY
	apply_material_name = FALSE
	category            = "tiling"

/decl/stack_recipe/tile/wood
	result_type         = /obj/item/stack/tile/wood
	required_material   = /decl/material/solid/organic/wood

/decl/stack_recipe/tile/wood/mahogany
	result_type         = /obj/item/stack/tile/mahogany
	required_material   = /decl/material/solid/organic/wood/mahogany

/decl/stack_recipe/tile/wood/maple
	result_type         = /obj/item/stack/tile/maple
	required_material   = /decl/material/solid/organic/wood/maple

/decl/stack_recipe/tile/wood/ebony
	difficulty          = MAT_VALUE_VERY_HARD_DIY
	result_type         = /obj/item/stack/tile/ebony
	required_material   = /decl/material/solid/organic/wood/ebony

/decl/stack_recipe/tile/wood/walnut
	result_type         = /obj/item/stack/tile/walnut
	required_material   = /decl/material/solid/organic/wood/walnut


/decl/stack_recipe/tile/steel
	abstract_type     = /decl/stack_recipe/tile/steel
	required_material = /decl/material/solid/metal/steel
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/tile/steel/floor
	result_type       = /obj/item/stack/tile/floor

/decl/stack_recipe/tile/steel/roof
	result_type       = /obj/item/stack/tile/roof

/decl/stack_recipe/tile/steel/mono
	result_type       = /obj/item/stack/tile/mono

/decl/stack_recipe/tile/steel/mono_dark
	result_type       = /obj/item/stack/tile/mono/dark

/decl/stack_recipe/tile/steel/grid
	result_type       = /obj/item/stack/tile/grid

/decl/stack_recipe/tile/steel/ridged
	result_type       = /obj/item/stack/tile/ridge

/decl/stack_recipe/tile/steel/tech_grey
	result_type       = /obj/item/stack/tile/techgrey

/decl/stack_recipe/tile/steel/tech_grid
	result_type       = /obj/item/stack/tile/techgrid

/decl/stack_recipe/tile/steel/tech_maint
	result_type       = /obj/item/stack/tile/techmaint

/decl/stack_recipe/tile/steel/dark
	result_type       = /obj/item/stack/tile/floor_dark

/decl/stack_recipe/tile/steel/pool
	result_type       = /obj/item/stack/tile/pool

/decl/stack_recipe/tile/panels
	abstract_type = /decl/stack_recipe/tile/panels
	craft_stack_types = /obj/item/stack/material/panel
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/tile/panels/floor
	result_type       = /obj/item/stack/tile/floor_white

/decl/stack_recipe/tile/panels/freezer
	result_type       = /obj/item/stack/tile/floor_freezer
