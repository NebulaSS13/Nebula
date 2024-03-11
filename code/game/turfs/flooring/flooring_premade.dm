// simulated/floor is currently plating by default, but there really should be an explicit plating type.
/turf/floor/plating
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	layer = PLATING_LAYER

/turf/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit
	light_range = 2
	light_power = 3
	light_color = COLOR_BLUE

/turf/floor/bluegrid/airless
	initial_gas = null

/turf/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit/green
	light_range = 2
	light_power = 3
	light_color = COLOR_GREEN

/turf/floor/blackgrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "rcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit/red
	light_range = 2
	light_power = 2
	light_color = COLOR_RED

/turf/floor/greengrid/airless
	initial_gas = null

/turf/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	color = WOOD_COLOR_GENERIC
	initial_flooring = /decl/flooring/wood

/turf/floor/wood/mahogany
	color = WOOD_COLOR_RICH
	initial_flooring = /decl/flooring/wood/mahogany

/turf/floor/wood/maple
	color = WOOD_COLOR_PALE
	initial_flooring = /decl/flooring/wood/maple

/turf/floor/wood/ebony
	color = WOOD_COLOR_BLACK
	initial_flooring = /decl/flooring/wood/ebony

/turf/floor/wood/walnut
	color = WOOD_COLOR_CHOCOLATE
	initial_flooring = /decl/flooring/wood/walnut

/turf/floor/wood/bamboo
	color = WOOD_COLOR_PALE2
	initial_flooring = /decl/flooring/wood/bamboo

/turf/floor/wood/yew
	color = WOOD_COLOR_YELLOW
	initial_flooring = /decl/flooring/wood/yew

/turf/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /decl/flooring/grass

/turf/floor/carpet
	name = "brown carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "brown"
	initial_flooring = /decl/flooring/carpet

/turf/floor/carpet/blue
	name = "blue carpet"
	icon_state = "blue1"
	initial_flooring = /decl/flooring/carpet/blue

/turf/floor/carpet/blue2
	name = "pale blue carpet"
	icon_state = "blue2"
	initial_flooring = /decl/flooring/carpet/blue2

/turf/floor/carpet/blue3
	name = "sea blue carpet"
	icon_state = "blue3"
	initial_flooring = /decl/flooring/carpet/blue3

/turf/floor/carpet/magenta
	name = "magenta carpet"
	icon_state = "magenta"
	initial_flooring = /decl/flooring/carpet/magenta

/turf/floor/carpet/purple
	name = "purple carpet"
	icon_state = "purple"
	initial_flooring = /decl/flooring/carpet/purple

/turf/floor/carpet/orange
	name = "orange carpet"
	icon_state = "orange"
	initial_flooring = /decl/flooring/carpet/orange

/turf/floor/carpet/green
	name = "green carpet"
	icon_state = "green"
	initial_flooring = /decl/flooring/carpet/green

/turf/floor/carpet/red
	name = "red carpet"
	icon_state = "red"
	initial_flooring = /decl/flooring/carpet/red

/turf/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /decl/flooring/reinforced

/turf/floor/reinforced/airless
	initial_gas = null

/turf/floor/reinforced/airmix
	initial_gas = list(/decl/material/gas/oxygen = MOLES_O2ATMOS, /decl/material/gas/nitrogen = MOLES_N2ATMOS)

/turf/floor/reinforced/nitrogen
	initial_gas = list(/decl/material/gas/nitrogen = ATMOSTANK_NITROGEN)

/turf/floor/reinforced/hydrogen
	initial_gas = list(/decl/material/gas/hydrogen = ATMOSTANK_HYDROGEN)

/turf/floor/reinforced/oxygen
	initial_gas = list(/decl/material/gas/oxygen = ATMOSTANK_OXYGEN)

/turf/floor/reinforced/nitrogen/engine
	name = "engine floor"
	initial_gas = list(/decl/material/gas/nitrogen = MOLES_N2STANDARD)

/turf/floor/reinforced/hydrogen/fuel
	initial_gas = list(/decl/material/gas/hydrogen = ATMOSTANK_HYDROGEN_FUEL)

/turf/floor/reinforced/carbon_dioxide
	initial_gas = list(/decl/material/gas/carbon_dioxide = ATMOSTANK_CO2)

/turf/floor/reinforced/n20
	initial_gas = list(/decl/material/gas/nitrous_oxide = ATMOSTANK_NITROUSOXIDE)


/turf/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	initial_flooring = /decl/flooring/reinforced/cult

/turf/floor/cult/on_defilement()
	return

/turf/floor/cult/is_defiled()
	return TRUE

/turf/simulated/floor/woven
	name = "floor"
	icon = 'icons/turf/flooring/woven.dmi'
	icon_state = "0"
	initial_flooring = /decl/flooring/woven
	color = COLOR_BEIGE

//Tiled floor + sub-types

/turf/floor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "tiled"
	initial_flooring = /decl/flooring/tiling

/turf/floor/tiled/dark
	name = "dark floor"
	icon_state = "dark"
	initial_flooring = /decl/flooring/tiling/dark

/turf/floor/tiled/dark/monotile
	name = "floor"
	icon_state = "monotiledark"
	initial_flooring = /decl/flooring/tiling/mono/dark

/turf/floor/tiled/dark/airless
	initial_gas = null

/turf/floor/tiled/white
	name = "white floor"
	icon_state = "white"
	initial_flooring = /decl/flooring/tiling/white

/turf/floor/tiled/white/monotile
	name = "floor"
	icon_state = "monotile"
	initial_flooring = /decl/flooring/tiling/mono/white

/turf/floor/tiled/monofloor
	name = "floor"
	icon_state = "steel_monofloor"
	initial_flooring = /decl/flooring/tiling/mono

/turf/floor/tiled/white/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	initial_flooring = /decl/flooring/tiling/freezer

/turf/floor/tiled/techmaint
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "techmaint"
	initial_flooring = /decl/flooring/tiling/new_tile/techmaint

/turf/floor/tiled/monofloor
	name = "floor"
	icon_state = "steel_monofloor"
	initial_flooring = /decl/flooring/tiling/new_tile/monofloor

/turf/floor/tiled/techfloor
	name = "floor"
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_state = "techfloor_gray"
	initial_flooring = /decl/flooring/tiling/tech

/turf/floor/tiled/monotile
	name = "floor"
	icon_state = "steel_monotile"
	initial_flooring = /decl/flooring/tiling/mono

/turf/floor/tiled/steel_grid
	name = "floor"
	icon_state = "steel_grid"
	initial_flooring = /decl/flooring/tiling/new_tile/steel_grid

/turf/floor/tiled/steel_ridged
	name = "floor"
	icon_state = "steel_ridged"
	initial_flooring = /decl/flooring/tiling/new_tile/steel_ridged

/turf/floor/tiled/old_tile
	name = "floor"
	icon_state = "tile_full"
	initial_flooring = /decl/flooring/tiling/new_tile

/turf/floor/tiled/old_cargo
	name = "floor"
	icon_state = "cargo_one_full"
	initial_flooring = /decl/flooring/tiling/new_tile/cargo_one

/turf/floor/tiled/kafel_full
	name = "floor"
	icon_state = "kafel_full"
	initial_flooring = /decl/flooring/tiling/new_tile/kafel

/turf/floor/tiled/stone
	name = "stone slab floor"
	icon_state = "stone"
	initial_flooring = /decl/flooring/tiling/stone

/turf/floor/tiled/techfloor/grid
	name = "floor"
	icon_state = "techfloor_grid"
	initial_flooring = /decl/flooring/tiling/tech/grid

/turf/floor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /decl/flooring/linoleum

//ATMOS PREMADES
/turf/floor/reinforced/airless
	name = "vacuum floor"
	initial_gas = null
	temperature = TCMB

/turf/floor/airless
	name = "airless plating"
	initial_gas = null
	temperature = TCMB

/turf/floor/tiled/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/floor/bluegrid/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/floor/greengrid/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/floor/greengrid/nitrogen
	initial_gas = list(/decl/material/gas/nitrogen = MOLES_N2STANDARD)

/turf/floor/crystal
	name = "crystal floor"
	icon = 'icons/turf/flooring/crystal.dmi'
	icon_state = "crystal"
	initial_flooring = /decl/flooring/crystal

/turf/floor/glass
	name = "glass floor"
	icon = 'icons/turf/flooring/glass.dmi'
	icon_state = "glass"
	initial_flooring = /decl/flooring/glass

/turf/floor/glass/boro
	initial_flooring = /decl/flooring/glass/boro

//Water go splish
/turf/floor/pool
	name = "pool floor"
	icon = 'icons/turf/flooring/pool.dmi'
	icon_state = "pool"
	initial_flooring = /decl/flooring/pool

/turf/floor/pool/deep
	name = "deep pool floor"
	icon = 'icons/turf/flooring/pool.dmi'
	icon_state = "pool"
	initial_flooring = /decl/flooring/pool/deep
