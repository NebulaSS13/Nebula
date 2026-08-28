// Tiles
/decl/stack_recipe/tile
	abstract_type       = /decl/stack_recipe/tile
	difficulty          = MAT_VALUE_NORMAL_DIY
	apply_material_name = FALSE
	category            = "tiling"

/decl/stack_recipe/tile/wood
	abstract_type       = /decl/stack_recipe/tile/wood

/decl/stack_recipe/tile/wood/oak
	result_type         = /obj/item/stack/tile/wood/oak
	required_material   = /decl/material/solid/organic/wood/oak
	uid                 = "stack_recipe_tile_wood_oak"

/decl/stack_recipe/tile/wood/mahogany
	result_type         = /obj/item/stack/tile/wood/mahogany
	required_material   = /decl/material/solid/organic/wood/mahogany
	uid                 = "stack_recipe_tile_wood_mahogany"

/decl/stack_recipe/tile/wood/maple
	result_type         = /obj/item/stack/tile/wood/maple
	required_material   = /decl/material/solid/organic/wood/maple
	uid                 = "stack_recipe_tile_wood_maple"

/decl/stack_recipe/tile/wood/ebony
	difficulty          = MAT_VALUE_VERY_HARD_DIY
	result_type         = /obj/item/stack/tile/wood/ebony
	required_material   = /decl/material/solid/organic/wood/ebony
	uid                 = "stack_recipe_tile_wood_ebony"

/decl/stack_recipe/tile/wood/walnut
	result_type         = /obj/item/stack/tile/wood/walnut
	required_material   = /decl/material/solid/organic/wood/walnut
	uid                 = "stack_recipe_tile_wood_walnut"

/decl/stack_recipe/tile/wood/oak/rough
	crafting_extra_cost_factor = 2 // wasteful but easy
	difficulty                 = MAT_VALUE_EASY_DIY
	result_type                = /obj/item/stack/tile/wood/rough/oak
	uid                        = "stack_recipe_tile_wood_oak_rough"

/decl/stack_recipe/tile/wood/mahogany/rough
	crafting_extra_cost_factor = 2
	difficulty                 = MAT_VALUE_EASY_DIY
	result_type                = /obj/item/stack/tile/wood/rough/mahogany
	uid                        = "stack_recipe_tile_wood_mahogany_rough"

/decl/stack_recipe/tile/wood/maple/rough
	crafting_extra_cost_factor = 2
	difficulty                 = MAT_VALUE_EASY_DIY
	result_type                = /obj/item/stack/tile/wood/rough/maple
	uid                        = "stack_recipe_tile_wood_maple_rough"

/decl/stack_recipe/tile/wood/ebony/rough
	crafting_extra_cost_factor = 2
	difficulty                 = MAT_VALUE_HARD_DIY
	result_type                = /obj/item/stack/tile/wood/rough/ebony
	uid                        = "stack_recipe_tile_wood_ebony_rough"

/decl/stack_recipe/tile/wood/walnut/rough
	crafting_extra_cost_factor = 2
	difficulty                 = MAT_VALUE_EASY_DIY
	result_type                = /obj/item/stack/tile/wood/rough/walnut
	uid                        = "stack_recipe_tile_wood_walnut_rough"

/decl/stack_recipe/tile/wood/oak_laminate
	result_type         = /obj/item/stack/tile/wood/laminate/oak
	required_material   = /decl/material/solid/organic/wood/chipboard
	uid                 = "stack_recipe_tile_wood_laminate_oak"

/decl/stack_recipe/tile/wood/mahogany_laminate
	result_type         = /obj/item/stack/tile/wood/laminate/mahogany
	required_material   = /decl/material/solid/organic/wood/chipboard/mahogany
	uid                 = "stack_recipe_tile_wood_laminate_mahogany"

/decl/stack_recipe/tile/wood/maple_laminate
	result_type         = /obj/item/stack/tile/wood/laminate/maple
	required_material   = /decl/material/solid/organic/wood/chipboard/maple
	uid                 = "stack_recipe_tile_wood_laminate_maple"

/decl/stack_recipe/tile/wood/ebony_laminate
	result_type         = /obj/item/stack/tile/wood/laminate/ebony
	required_material   = /decl/material/solid/organic/wood/chipboard/ebony
	uid                 = "stack_recipe_tile_wood_laminate_ebony"

/decl/stack_recipe/tile/wood/walnut_laminate
	result_type         = /obj/item/stack/tile/wood/walnut
	required_material   = /decl/material/solid/organic/wood/chipboard/walnut
	uid                 = "stack_recipe_tile_wood_laminate_walnut"

/decl/stack_recipe/tile/wood/yew_laminate
	result_type         = /obj/item/stack/tile/wood/laminate/yew
	required_material   = /decl/material/solid/organic/wood/chipboard/yew
	uid                 = "stack_recipe_tile_wood_laminate_yew"

/decl/stack_recipe/tile/steel
	abstract_type     = /decl/stack_recipe/tile/steel
	required_material = /decl/material/solid/metal/steel
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/tile/steel/floor
	result_type       = /obj/item/stack/tile/floor
	uid               = "stack_recipe_tile_steel_floor"

/decl/stack_recipe/tile/steel/roof
	result_type       = /obj/item/stack/tile/roof
	uid               = "stack_recipe_tile_steel_roof"

/decl/stack_recipe/tile/steel/mono
	result_type       = /obj/item/stack/tile/mono
	uid               = "stack_recipe_tile_steel_mono"

/decl/stack_recipe/tile/steel/mono_dark
	result_type       = /obj/item/stack/tile/mono/dark
	uid               = "stack_recipe_tile_steel_mono_dark"

/decl/stack_recipe/tile/steel/grid
	result_type       = /obj/item/stack/tile/grid
	uid               = "stack_recipe_tile_steel_grid"

/decl/stack_recipe/tile/steel/ridged
	result_type       = /obj/item/stack/tile/ridge
	uid               = "stack_recipe_tile_steel_ridge"

/decl/stack_recipe/tile/steel/tech_grey
	result_type       = /obj/item/stack/tile/techgrey
	uid               = "stack_recipe_tile_steel_tech_grey"

/decl/stack_recipe/tile/steel/tech_grid
	result_type       = /obj/item/stack/tile/techgrid
	uid               = "stack_recipe_tile_steel_tech_grid"

/decl/stack_recipe/tile/steel/tech_maint
	result_type       = /obj/item/stack/tile/techmaint
	uid               = "stack_recipe_tile_steel_tech_maint"

/decl/stack_recipe/tile/steel/dark
	result_type       = /obj/item/stack/tile/floor_dark
	uid               = "stack_recipe_tile_steel_dark"

/decl/stack_recipe/tile/steel/pool
	result_type       = /obj/item/stack/tile/pool
	uid               = "stack_recipe_tile_steel_pool"

/decl/stack_recipe/tile/panels
	abstract_type = /decl/stack_recipe/tile/panels
	craft_stack_types = /obj/item/stack/material/panel
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	validation_material = /decl/material/solid/organic/plastic

/decl/stack_recipe/tile/panels/floor
	result_type       = /obj/item/stack/tile/floor_white
	uid               = "stack_recipe_tile_panel_floor_white"

/decl/stack_recipe/tile/panels/freezer
	result_type       = /obj/item/stack/tile/floor_freezer
	uid               = "stack_recipe_tile_panel_floor_freezer"
