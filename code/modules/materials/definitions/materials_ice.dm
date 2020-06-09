/decl/material/ice
	stack_type = null
	color = "#a5f2f3"
	heating_products = list(
		/decl/material/gas/water = 1
	)
	ore_name = "ice"
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	removed_by_welder = TRUE
	value = 0.2
	sparse_material_weight = 2
	rich_material_weight = 37
	heating_point = T0C

/decl/material/ice/aspium
	heating_products = list(
		/decl/material/chem/fuel/hydrazine = 0.3,
		/decl/material/gas/water           = 0.7
	)
	ore_name = "aspium ice"
	value = 0.4
	sparse_material_weight = 2
	rich_material_weight = 37

/decl/material/ice/lukrite
	heating_products = list(
		/decl/material/chem/sulfur = 0.4,
		/decl/material/gas/water   = 0.2,
		/decl/material/chem/acid   = 0.4
	)
	ore_name = "lukrite ice"
	value = 0.3
	sparse_material_weight = 27
	rich_material_weight = 22

/decl/material/ice/rubenium
	heating_products = list(
		/decl/material/chem/radium  = 0.4,
		/decl/material/gas/water    = 0.4,
		/decl/material/chem/acetone = 0.2
	)
	ore_name = "rubenium ice"
	value = 0.4
	sparse_material_weight = 35
	rich_material_weight = 12

/decl/material/ice/trigarite
	heating_products = list(
		/decl/material/chem/acid/hydrochloric = 0.2,
		/decl/material/gas/water              = 0.2,
		/decl/material/chem/mercury           = 0.6
	)
	ore_name = "trigarite ice"
	value = 0.5
	sparse_material_weight = 38
	rich_material_weight = 23

/decl/material/ice/ediroite
	heating_products = list(
		/decl/material/chem/ammonia = 0.4,
		/decl/material/gas/water    = 0.2,
		/decl/material/chem/ethanol = 0.4
	)
	ore_name = "ediroite ice"
	value = 0.2
	sparse_material_weight = 21
	rich_material_weight = 39