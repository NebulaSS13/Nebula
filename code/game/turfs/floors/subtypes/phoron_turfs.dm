#define ATMOSTANK_PHORON 25000
/turf/floor/reinforced/phoron
	initial_gas = list(/decl/material/solid/phoron = ATMOSTANK_PHORON)
#undef ATMOSTANK_PHORON

#define ATMOSTANK_PHORON_FUEL 15000
/turf/floor/reinforced/phoron/fuel
	initial_gas = list(/decl/material/solid/phoron = ATMOSTANK_PHORON_FUEL)
#undef ATMOSTANK_PHORON_FUEL

/turf/wall/phoron
	color = "#e37108"
	icon_state = "stone"
	material = /decl/material/solid/phoron
