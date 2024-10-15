/decl/flooring/tiling
	name               = "floor"
	desc               = "A solid, heavy set of flooring plates."
	icon               = 'icons/turf/flooring/tiles.dmi'
	icon_base          = "tiled"
	descriptor         = "tiles"
	color              = COLOR_DARK_GUNMETAL
	damage_temperature = T0C+1400
	flooring_flags     = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type         = /obj/item/stack/tile/floor
	can_paint          = 1
	footstep_type      = /decl/footsteps/tiles
	force_material     = /decl/material/solid/metal/steel
	wall_smooth        = SMOOTH_ALL
	space_smooth       = SMOOTH_ALL
	constructed        = TRUE
	gender             = NEUTER

/decl/flooring/tiling/mono
	icon_base          = "monotile"
	build_type         = /obj/item/stack/tile/mono

/decl/flooring/tiling/mono/dark
	color              = COLOR_DARK_GRAY
	build_type         = /obj/item/stack/tile/mono/dark

/decl/flooring/tiling/mono/white
	icon_base          = "monotile_light"
	color              = COLOR_OFF_WHITE
	build_type         = /obj/item/stack/tile/mono/white

/decl/flooring/tiling/white
	icon_base          = "tiled_light"
	desc               = "A layer of sterile white tiles."
	color              = COLOR_OFF_WHITE
	build_type         = /obj/item/stack/tile/floor_white

/decl/flooring/tiling/dark
	desc               = "A layer of ominously dark tiles."
	color              = COLOR_DARK_GRAY
	build_type         = /obj/item/stack/tile/floor_dark

/decl/flooring/tiling/dark/mono
	icon_base          = "monotile"
	build_type         = null

/decl/flooring/tiling/freezer
	desc               = "A section of non-slip tiles suitable for a cool room or freezer."
	icon_base          = "freezer"
	color              = null
	flooring_flags     = TURF_REMOVE_CROWBAR
	build_type         = /obj/item/stack/tile/floor_freezer

/decl/flooring/tiling/tech
	icon               = 'icons/turf/flooring/techfloor.dmi'
	icon_base          = "techfloor_gray"
	build_type         = /obj/item/stack/tile/techgrey
	color              = null

/decl/flooring/tiling/tech/grid
	icon_base          = "techfloor_grid"
	build_type         = /obj/item/stack/tile/techgrid

/decl/flooring/tiling/new_tile
	icon_base          = "tile_full"
	color              = null
	build_type         = null

/decl/flooring/tiling/new_tile/cargo_one
	icon_base          = "cargo_one_full"
	build_type         = null

/decl/flooring/tiling/new_tile/kafel
	icon_base          = "kafel_full"
	build_type         = null

/decl/flooring/tiling/stone
	icon_base          = "stone"
	build_type         = /obj/item/stack/tile/stone

/decl/flooring/tiling/new_tile/techmaint
	icon_base          = "techmaint"
	build_type         = /obj/item/stack/tile/techmaint

/decl/flooring/tiling/new_tile/monofloor
	icon_base          = "monofloor"
	color              = COLOR_GUNMETAL

/decl/flooring/tiling/new_tile/steel_grid
	icon_base          = "grid"
	color              = COLOR_GUNMETAL
	build_type         = /obj/item/stack/tile/grid

/decl/flooring/tiling/new_tile/steel_ridged
	icon_base          = "ridged"
	color              = COLOR_GUNMETAL
	build_type         = /obj/item/stack/tile/ridge
