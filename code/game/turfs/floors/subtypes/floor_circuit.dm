/turf/floor/bluegrid
	name        = "mainframe floor"
	icon        = 'icons/turf/flooring/circuit.dmi'
	icon_state  = "bcircuit"
	_flooring   = /decl/flooring/reinforced/circuit

/turf/floor/bluegrid/airless
	name        = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/floor/bluegrid/mainframe
	name        = "mainframe base" // TODO: force name overriding flooring?
	temperature = 263

/turf/floor/bluegrid/cryo
	initial_gas = list(/decl/material/gas/nitrogen = MOLES_CELLSTANDARD)
	temperature = 73

/turf/floor/greengrid
	name        = "mainframe floor"
	icon        = 'icons/turf/flooring/circuit.dmi'
	icon_state  = "gcircuit"
	_flooring   = /decl/flooring/reinforced/circuit/green

/turf/floor/greengrid/airless
	name        = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/floor/greengrid/nitrogen
	initial_gas = list(/decl/material/gas/nitrogen = MOLES_N2STANDARD)

/turf/floor/blackgrid
	name        = "mainframe floor"
	icon        = 'icons/turf/flooring/circuit.dmi'
	icon_state  = "rcircuit"
	_flooring   = /decl/flooring/reinforced/circuit/red
