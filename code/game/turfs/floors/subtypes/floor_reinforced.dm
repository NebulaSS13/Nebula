/turf/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	_flooring = /decl/flooring/reinforced

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

/turf/floor/reinforced/airless
	name = "vacuum floor"
	initial_gas = null
	temperature = TCMB
