/decl/flooring/tiling
	name               = "floor"
	desc               = "A solid, heavy set of flooring plates."
	icon               = 'icons/turf/flooring/tiles.dmi'
	icon_base          = "tiled"
	descriptor         = "tiles"
	color              = COLOR_DARK_GUNMETAL
	damage_temperature = T0C+1400
	flooring_flags     = TURF_REMOVE_CROWBAR
	build_type         = /obj/item/stack/tile/floor
	can_paint          = TRUE
	footstep_type      = /decl/footsteps/tiles
	force_material     = /decl/material/solid/metal/steel
	wall_smooth        = SMOOTH_ALL
	space_smooth       = SMOOTH_ALL
	constructed        = TRUE
	gender             = NEUTER
	burned_states  = list(
		"burned0",
		"burned1"
	)
	broken_states  = list(
		"broken0",
		"broken1",
		"broken2",
		"broken3",
		"broken4"
	)
	uid                = "floor_tiled"

/decl/flooring/tiling/mono
	icon_base          = "monotile"
	build_type         = /obj/item/stack/tile/mono
	uid                = "floor_tiled_mono"

/decl/flooring/tiling/mono/dark
	color              = COLOR_DARK_GRAY
	build_type         = /obj/item/stack/tile/mono/dark
	uid                = "floor_tiled_dark_mono"

/decl/flooring/tiling/mono/white
	icon_base          = "monotile_light"
	color              = COLOR_OFF_WHITE
	build_type         = /obj/item/stack/tile/mono/white
	uid                = "floor_tiled_mono_white"

/decl/flooring/tiling/white
	icon_base          = "tiled_light"
	desc               = "A layer of sterile white tiles."
	color              = COLOR_OFF_WHITE
	build_type         = /obj/item/stack/tile/floor_white
	uid                = "floor_tiled_white"

/decl/flooring/tiling/dark
	desc               = "A layer of ominously dark tiles."
	color              = COLOR_DARK_GRAY
	build_type         = /obj/item/stack/tile/floor_dark
	uid                = "floor_tiled_dark"

/decl/flooring/tiling/dark/mono
	icon_base          = "monotile"
	build_type         = null
	uid                = "floor_tiled_dark_monotile"

/decl/flooring/tiling/freezer
	desc               = "A section of non-slip tiles suitable for a cool room or freezer."
	icon_base          = "freezer"
	color              = null
	flooring_flags     = TURF_REMOVE_CROWBAR
	build_type         = /obj/item/stack/tile/floor_freezer
	uid                = "floor_tiled_freezer"

/decl/flooring/tiling/tech
	icon               = 'icons/turf/flooring/techfloor.dmi'
	icon_base          = "techfloor_gray"
	build_type         = /obj/item/stack/tile/techgrey
	color              = null
	uid                = "floor_tiled_tech"

/decl/flooring/tiling/tech/grid
	icon_base          = "techfloor_grid"
	build_type         = /obj/item/stack/tile/techgrid
	uid                = "floor_tiled_tech_grid"

/decl/flooring/tiling/new_tile
	icon_base          = "tile_full"
	color              = null
	build_type         = null
	uid                = "floor_tiled_new"

/decl/flooring/tiling/new_tile/cargo_one
	icon_base          = "cargo_one_full"
	build_type         = null
	uid                = "floor_tiled_cargo"

/decl/flooring/tiling/new_tile/kafel
	icon_base          = "kafel_full"
	build_type         = null
	uid                = "floor_tiled_kafel"

/decl/flooring/tiling/stone
	icon_base          = "stone"
	build_type         = /obj/item/stack/tile/stone
	uid                = "floor_tiled_stone"

/decl/flooring/tiling/new_tile/techmaint
	icon_base          = "techmaint"
	build_type         = /obj/item/stack/tile/techmaint
	uid                = "floor_tiled_techmaint"

/decl/flooring/tiling/new_tile/monofloor
	icon_base          = "monofloor"
	color              = COLOR_GUNMETAL
	uid                = "floor_tiled_monofloor"

/decl/flooring/tiling/new_tile/steel_grid
	icon_base          = "grid"
	color              = COLOR_GUNMETAL
	build_type         = /obj/item/stack/tile/grid
	uid                = "floor_tiled_steel_grid"

/decl/flooring/tiling/new_tile/steel_ridged
	icon_base          = "ridged"
	color              = COLOR_GUNMETAL
	build_type         = /obj/item/stack/tile/ridge
	uid                = "floor_tiled_steel_ridged"
