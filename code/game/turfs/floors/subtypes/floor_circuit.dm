/turf/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	_flooring = /decl/flooring/reinforced/circuit
	light_range = 2
	light_power = 3
	light_color = COLOR_BLUE

/turf/floor/bluegrid/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	_flooring = /decl/flooring/reinforced/circuit/green
	light_range = 2
	light_power = 3
	light_color = COLOR_GREEN

/turf/floor/greengrid/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/floor/greengrid/nitrogen
	initial_gas = list(/decl/material/gas/nitrogen = MOLES_N2STANDARD)

/turf/floor/blackgrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "rcircuit"
	_flooring = /decl/flooring/reinforced/circuit/red
	light_range = 2
	light_power = 2
	light_color = COLOR_RED
