// Simplified metal list.
/decl/strata/shaded_hills
	name = "mountainous rock"
	base_materials = list(/decl/material/solid/stone/basalt)
	default_strata_candidate = FALSE
	ores_sparse = list(
		/decl/material/solid/quartz,
		/decl/material/solid/graphite,
		/decl/material/solid/tetrahedrite,
		/decl/material/solid/hematite
	)
	ores_rich = list(
		/decl/material/solid/gemstone/diamond,
		/decl/material/solid/metal/gold,
		/decl/material/solid/metal/platinum,
		/decl/material/solid/densegraphite,
		/decl/material/solid/galena
	)

/decl/material/solid/graphite
	name = "coal"
	codex_name = "loose coal"
	ore_name = "coal"

/decl/material/solid/densegraphite
	name = "dense coal"
	codex_name = "dense coal"
	ore_name = "dense coal"
