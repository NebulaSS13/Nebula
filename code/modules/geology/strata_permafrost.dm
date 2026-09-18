/decl/strata/permafrost
	name = "permafrost"
	base_materials = list(/decl/material/liquid/water)
	// todo swap hydrogen ice to hydrate
	ores_rich = list(
		/decl/material/liquid/water/aspium,
		/decl/material/liquid/water/lukrite,
		/decl/material/liquid/water/rubenium,
		/decl/material/liquid/water/trigarite,
		/decl/material/liquid/water/ediroite,
		/decl/material/liquid/water/hydrogen,
		/decl/material/liquid/water/hydrate/methane,
		/decl/material/liquid/water/hydrate/oxygen,
		/decl/material/liquid/water/hydrate/nitrogen,
		/decl/material/liquid/water/hydrate/carbon_dioxide,
		/decl/material/liquid/water/hydrate/argon,
		/decl/material/liquid/water/hydrate/neon,
		/decl/material/liquid/water/hydrate/krypton,
		/decl/material/liquid/water/hydrate/xenon,
	)
	default_strata_candidate = STRATA_RANDOM_PLANET
	maximum_temperature = T0C
