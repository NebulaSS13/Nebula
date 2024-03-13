/datum/map_template/ruin/exoplanet/lodge
	name = "lodge"
	description = "A wood cabin."
	suffixes = list("lodge/lodge.dmm")
	cost = 1
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	template_tags = TEMPLATE_TAG_HUMAN|TEMPLATE_TAG_HABITAT

/turf/floor/wood/usedup
	initial_gas = list(/decl/material/gas/carbon_dioxide = MOLES_O2STANDARD, /decl/material/gas/nitrogen = MOLES_N2STANDARD)