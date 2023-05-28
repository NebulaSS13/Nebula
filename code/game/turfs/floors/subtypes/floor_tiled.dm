//Tiled floor + sub-types
/turf/floor/tiled
	name          = "floor"
	icon          = 'icons/turf/flooring/tiles.dmi'
	icon_state    = "tiled"
	_flooring     = /decl/flooring/tiling

/turf/floor/tiled/dark
	name          = "dark floor"
	icon_state    = "dark"
	_flooring     = /decl/flooring/tiling/dark

/turf/floor/tiled/dark/cryo
	initial_gas = list(/decl/material/gas/nitrogen = MOLES_CELLSTANDARD)
	temperature = 73

/turf/floor/tiled/dark/monotile
	name          = "floor"
	icon_state    = "monotiledark"
	_flooring     = /decl/flooring/tiling/mono/dark

/turf/floor/tiled/dark/monotile/telecomms
	name          = "telecomms dark floor" // TODO: force name overriding flooring?
	temperature   = 263

/turf/floor/tiled/dark/airless
	initial_gas   = null

/turf/floor/tiled/white
	name          = "white floor"
	icon_state    = "white"
	_flooring     = /decl/flooring/tiling/white

/turf/floor/tiled/white/monotile
	name          = "floor"
	icon_state    = "monotile"
	_flooring     = /decl/flooring/tiling/mono/white

/turf/floor/tiled/monofloor
	name          = "floor"
	icon_state    = "steel_monofloor"
	_flooring     = /decl/flooring/tiling/mono

/turf/floor/tiled/white/airless
	name          = "airless floor"
	initial_gas   = null
	temperature   = TCMB

/turf/floor/tiled/freezer
	name          = "tiles"
	icon_state    = "freezer"
	_flooring     = /decl/flooring/tiling/freezer

/turf/floor/tiled/freezer/kitchen
	name          = "kitchen freezer floor" // TODO: force override of flooring name
	temperature   = 263

/turf/floor/tiled/techmaint
	name          = "floor"
	icon          = 'icons/turf/flooring/tiles.dmi'
	icon_state    = "techmaint"
	_flooring     = /decl/flooring/tiling/new_tile/techmaint

/turf/floor/tiled/monofloor
	name          = "floor"
	icon_state    = "steel_monofloor"
	_flooring     = /decl/flooring/tiling/new_tile/monofloor

/turf/floor/tiled/techfloor
	name          = "floor"
	icon          = 'icons/turf/flooring/techfloor.dmi'
	icon_state    = "techfloor_gray"
	_flooring     = /decl/flooring/tiling/tech

/turf/floor/tiled/techfloor/cryo
	initial_gas = list(/decl/material/gas/nitrogen = MOLES_CELLSTANDARD)
	temperature = 73

/turf/floor/tiled/monotile
	name          = "floor"
	icon_state    = "steel_monotile"
	_flooring     = /decl/flooring/tiling/mono

/turf/floor/tiled/steel_grid
	name          = "floor"
	icon_state    = "steel_grid"
	_flooring     = /decl/flooring/tiling/new_tile/steel_grid

/turf/floor/tiled/steel_ridged
	name          = "floor"
	icon_state    = "steel_ridged"
	_flooring     = /decl/flooring/tiling/new_tile/steel_ridged

/turf/floor/tiled/old_tile
	name          = "floor"
	icon_state    = "tile_full"
	_flooring     = /decl/flooring/tiling/new_tile

/turf/floor/tiled/old_cargo
	name          = "floor"
	icon_state    = "cargo_one_full"
	_flooring     = /decl/flooring/tiling/new_tile/cargo_one

/turf/floor/tiled/kafel_full
	name          = "floor"
	icon_state    = "kafel_full"
	_flooring     = /decl/flooring/tiling/new_tile/kafel

/turf/floor/tiled/stone
	name          = "stone slab floor"
	icon_state    = "stone"
	_flooring     = /decl/flooring/tiling/stone

/turf/floor/tiled/techfloor/grid
	name          = "floor"
	icon_state    = "techfloor_grid"
	_flooring     = /decl/flooring/tiling/tech/grid

/turf/floor/tiled/techfloor/grid/cryo
	initial_gas = list(/decl/material/gas/nitrogen = MOLES_CELLSTANDARD)
	temperature = 73

/turf/floor/tiled/airless
	name          = "airless floor"
	initial_gas   = null
	temperature   = TCMB

/turf/floor/tiled/airless/broken
	_floor_broken = TRUE

/turf/floor/tiled/airless/broken/Initialize()
	. = ..()
	var/setting_broken = _floor_broken
	_floor_broken = null
	set_floor_broken(setting_broken)
