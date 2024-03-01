// simulated/floor is currently plating by default, but there really should be an explicit plating type.
/turf/simulated/floor/plating
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	layer = PLATING_LAYER

/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit/circuit_blue.dmi'
	icon_state = "bcircuit"
	flooring_layers = /decl/flooring/reinforced/circuit
	light_range = 2
	light_power = 3
	light_color = COLOR_BLUE

/turf/simulated/floor/bluegrid/airless
	initial_gas = null

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit/circuit_green.dmi'
	icon_state = "gcircuit"
	flooring_layers = /decl/flooring/reinforced/circuit/green
	light_range = 2
	light_power = 3
	light_color = COLOR_GREEN

/turf/simulated/floor/blackgrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit/circuit_red.dmi'
	icon_state = "rcircuit"
	flooring_layers = /decl/flooring/reinforced/circuit/red
	light_range = 2
	light_power = 2
	light_color = COLOR_RED

/turf/simulated/floor/greengrid/airless
	initial_gas = null

/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	color = WOOD_COLOR_GENERIC
	flooring_layers = /decl/flooring/wood

/turf/simulated/floor/wood/mahogany
	color = WOOD_COLOR_RICH
	flooring_layers = /decl/flooring/wood/mahogany

/turf/simulated/floor/wood/maple
	color = WOOD_COLOR_PALE
	flooring_layers = /decl/flooring/wood/maple

/turf/simulated/floor/wood/ebony
	color = WOOD_COLOR_BLACK
	flooring_layers = /decl/flooring/wood/ebony

/turf/simulated/floor/wood/walnut
	color = WOOD_COLOR_CHOCOLATE
	flooring_layers = /decl/flooring/wood/walnut

/turf/simulated/floor/wood/bamboo
	color = WOOD_COLOR_PALE2
	flooring_layers = /decl/flooring/wood/bamboo

/turf/simulated/floor/wood/yew
	color = WOOD_COLOR_YELLOW
	flooring_layers = /decl/flooring/wood/yew

/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	flooring_layers = /decl/flooring/grass

/turf/simulated/floor/carpet
	name = "brown carpet"
	icon = 'icons/turf/flooring/carpet/carpet_brown.dmi'
	icon_state = "brown"
	flooring_layers = /decl/flooring/carpet

/turf/simulated/floor/carpet/blue
	name = "blue carpet"
	icon_state = "blue1"
	icon = 'icons/turf/flooring/carpet/carpet_blue_orange.dmi'
	flooring_layers = /decl/flooring/carpet/blue_orange

/turf/simulated/floor/carpet/blue2
	name = "pale blue carpet"
	icon_state = "blue2"
	icon = 'icons/turf/flooring/carpet/carpet_blue.dmi'
	flooring_layers = /decl/flooring/carpet/blue

/turf/simulated/floor/carpet/blue3
	name = "sea blue carpet"
	icon_state = "blue3"
	icon = 'icons/turf/flooring/carpet/carpet_blue_green.dmi'
	flooring_layers = /decl/flooring/carpet/blue_green

/turf/simulated/floor/carpet/magenta
	name = "magenta carpet"
	icon_state = "magenta"
	icon = 'icons/turf/flooring/carpet/carpet_magenta.dmi'
	flooring_layers = /decl/flooring/carpet/magenta

/turf/simulated/floor/carpet/purple
	name = "purple carpet"
	icon_state = "purple"
	icon = 'icons/turf/flooring/carpet/carpet_purple.dmi'
	flooring_layers = /decl/flooring/carpet/purple

/turf/simulated/floor/carpet/orange
	name = "orange carpet"
	icon_state = "orange"
	icon = 'icons/turf/flooring/carpet/carpet_orange.dmi'
	flooring_layers = /decl/flooring/carpet/orange

/turf/simulated/floor/carpet/green
	name = "green carpet"
	icon_state = "green"
	icon = 'icons/turf/flooring/carpet/carpet_green.dmi'
	flooring_layers = /decl/flooring/carpet/green

/turf/simulated/floor/carpet/red
	name = "red carpet"
	icon_state = "red"
	icon = 'icons/turf/flooring/carpet/carpet_red.dmi'
	flooring_layers = /decl/flooring/carpet/red

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles/tile_reinforced.dmi'
	icon_state = "reinforced"
	flooring_layers = /decl/flooring/reinforced

/turf/simulated/floor/reinforced/airless
	initial_gas = null

/turf/simulated/floor/reinforced/airmix
	initial_gas = list(/decl/material/gas/oxygen = MOLES_O2ATMOS, /decl/material/gas/nitrogen = MOLES_N2ATMOS)

/turf/simulated/floor/reinforced/nitrogen
	initial_gas = list(/decl/material/gas/nitrogen = ATMOSTANK_NITROGEN)

/turf/simulated/floor/reinforced/hydrogen
	initial_gas = list(/decl/material/gas/hydrogen = ATMOSTANK_HYDROGEN)

/turf/simulated/floor/reinforced/oxygen
	initial_gas = list(/decl/material/gas/oxygen = ATMOSTANK_OXYGEN)

/turf/simulated/floor/reinforced/nitrogen/engine
	name = "engine floor"
	initial_gas = list(/decl/material/gas/nitrogen = MOLES_N2STANDARD)

/turf/simulated/floor/reinforced/hydrogen/fuel
	initial_gas = list(/decl/material/gas/hydrogen = ATMOSTANK_HYDROGEN_FUEL)

/turf/simulated/floor/reinforced/carbon_dioxide
	initial_gas = list(/decl/material/gas/carbon_dioxide = ATMOSTANK_CO2)

/turf/simulated/floor/reinforced/n20
	initial_gas = list(/decl/material/gas/nitrous_oxide = ATMOSTANK_NITROUSOXIDE)


/turf/simulated/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	flooring_layers = /decl/flooring/reinforced/cult

/turf/simulated/floor/cult/on_defilement()
	return

/turf/simulated/floor/cult/is_defiled()
	return TRUE

//Tiled floor + sub-types

/turf/simulated/floor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles/tile.dmi'
	icon_state = "tiled"
	flooring_layers = /decl/flooring/tiling

/turf/simulated/floor/tiled/dark
	name = "dark floor"
	icon_state = "tiled"
	color = COLOR_DARK_GRAY
	flooring_layers = /decl/flooring/tiling/dark

/turf/simulated/floor/tiled/dark/monotile
	name = "floor"
	icon = 'icons/turf/flooring/tiles/tile_mono_dark.dmi'
	icon_state = "monotiledark"
	flooring_layers = /decl/flooring/tiling/mono/dark

/turf/simulated/floor/tiled/dark/airless
	initial_gas = null

/turf/simulated/floor/tiled/white
	name = "white floor"
	icon_state = "tiled_light"
	flooring_layers = /decl/flooring/tiling/white
	icon = 'icons/turf/flooring/tiles/tile_white.dmi'

/turf/simulated/floor/tiled/white/monotile
	name = "floor"
	icon_state = "monotile_light"
	icon = 'icons/turf/flooring/tiles/tile_mono_light.dmi'
	flooring_layers = /decl/flooring/tiling/mono/white

/turf/simulated/floor/tiled/white/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	icon = 'icons/turf/flooring/tiles/tile_freezer.dmi'
	flooring_layers = /decl/flooring/tiling/freezer

/turf/simulated/floor/tiled/techmaint
	name = "floor"
	icon = 'icons/turf/flooring/tiles/tile_techmaint.dmi'
	icon_state = "techmaint"
	flooring_layers = /decl/flooring/tiling/new_tile/techmaint

/turf/simulated/floor/tiled/techfloor
	name = "floor"
	icon = 'icons/turf/flooring/techfloor_gray.dmi'
	icon_state = "techfloor_gray"
	flooring_layers = /decl/flooring/tiling/tech

/turf/simulated/floor/tiled/monotile
	name = "floor"
	icon_state = "monotile"
	icon = 'icons/turf/flooring/tiles/tile_mono.dmi'
	flooring_layers = /decl/flooring/tiling/mono

/turf/simulated/floor/tiled/steel_grid
	name = "floor"
	icon_state = "grid"
	flooring_layers = /decl/flooring/tiling/new_tile/steel_grid
	icon = 'icons/turf/flooring/tiles/tile_steel_grid.dmi'

/turf/simulated/floor/tiled/steel_ridged
	name = "floor"
	icon_state = "ridged"
	flooring_layers = /decl/flooring/tiling/new_tile/steel_ridged
	icon = 'icons/turf/flooring/tiles/tile_steel_ridged.dmi'

/turf/simulated/floor/tiled/old_tile
	name = "floor"
	icon_state = "tile_full"
	flooring_layers = /decl/flooring/tiling/new_tile
	icon = 'icons/turf/flooring/tiles/tile_full.dmi'

/turf/simulated/floor/tiled/old_cargo
	name = "floor"
	icon_state = "cargo_one_full"
	flooring_layers = /decl/flooring/tiling/new_tile/cargo_one
	icon = 'icons/turf/flooring/tiles/tile_cargo.dmi'

/turf/simulated/floor/tiled/kafel_full
	name = "floor"
	icon_state = "kafel_full"
	flooring_layers = /decl/flooring/tiling/new_tile/kafel
	icon = 'icons/turf/flooring/tiles/tile_kafel.dmi'

/turf/simulated/floor/tiled/stone
	name = "stone slab floor"
	icon_state = "stone"
	flooring_layers = /decl/flooring/tiling/stone
	icon = 'icons/turf/flooring/tiles/tile_stone.dmi'

/turf/simulated/floor/tiled/techfloor/grid
	name = "floor"
	icon_state = "techfloor_grid"
	flooring_layers = /decl/flooring/tiling/tech/grid
	icon = 'icons/turf/flooring/techfloor_grid.dmi'

/turf/simulated/floor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	flooring_layers = /decl/flooring/linoleum

//ATMOS PREMADES
/turf/simulated/floor/reinforced/airless
	name = "vacuum floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/airless
	name = "airless plating"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/tiled/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/bluegrid/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/greengrid/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/greengrid/nitrogen
	initial_gas = list(/decl/material/gas/nitrogen = MOLES_N2STANDARD)

/turf/simulated/floor/crystal
	name = "crystal floor"
	icon = 'icons/turf/flooring/crystal.dmi'
	icon_state = "crystal"
	flooring_layers = /decl/flooring/crystal

/turf/simulated/floor/glass
	name = "glass floor"
	icon = 'icons/turf/flooring/glass.dmi'
	icon_state = "glass"
	flooring_layers = /decl/flooring/glass

/turf/simulated/floor/glass/boro
	flooring_layers = /decl/flooring/glass/boro

//Water go splish
/turf/simulated/floor/pool
	name = "pool floor"
	icon = 'icons/turf/flooring/pool.dmi'
	icon_state = "pool"
	flooring_layers = /decl/flooring/pool

/turf/simulated/floor/pool/deep
	name = "deep pool floor"
	icon = 'icons/turf/flooring/pool.dmi'
	icon_state = "pool"
	flooring_layers = /decl/flooring/pool/deep

