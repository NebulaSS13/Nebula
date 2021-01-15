/decl/material/solid/ice
	stack_type = null
	color = "#a5f2f3"
	heating_products = list(
		/decl/material/liquid/water = 1
	)
	name = "ice"
	ore_name = "ice"
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	removed_by_welder = TRUE
	value = 0.2
	sparse_material_weight = 2
	rich_material_weight = 37
	heating_point = T20C + 10 // Above room temperature, to avoid drinks melting.
	stack_type = /obj/item/stack/material/generic/brick

/decl/material/solid/ice/aspium
	heating_products = list(
		/decl/material/liquid/fuel/hydrazine = 0.3,
		/decl/material/liquid/water = 0.7
	)
	name = "aspium ice"
	ore_name = "aspium ice"
	value = 0.4
	sparse_material_weight = 2
	rich_material_weight = 37

/decl/material/solid/ice/lukrite
	heating_products = list(
		/decl/material/solid/sulfur = 0.4,
		/decl/material/liquid/water = 0.2,
		/decl/material/liquid/acid  = 0.4
	)
	name = "lukrite ice"
	ore_name = "lukrite ice"
	value = 0.3
	sparse_material_weight = 27
	rich_material_weight = 22

/decl/material/solid/ice/rubenium
	heating_products = list(
		/decl/material/solid/metal/radium  = 0.4,
		/decl/material/liquid/water = 0.4,
		/decl/material/liquid/acetone = 0.2
	)
	name = "rubenium ice"
	ore_name = "rubenium ice"
	value = 0.4
	sparse_material_weight = 35
	rich_material_weight = 12

/decl/material/solid/ice/trigarite
	heating_products = list(
		/decl/material/liquid/acid/hydrochloric = 0.2,
		/decl/material/liquid/water             = 0.2,
		/decl/material/liquid/mercury           = 0.6
	)
	name = "trigarite ice"
	ore_name = "trigarite ice"
	value = 0.5
	sparse_material_weight = 38
	rich_material_weight = 23

/decl/material/solid/ice/ediroite
	heating_products = list(
		/decl/material/gas/ammonia  = 0.4,
		/decl/material/liquid/water = 0.2,
		/decl/material/liquid/ethanol = 0.4
	)
	name = "ediroite ice"
	ore_name = "ediroite ice"
	value = 0.2
	sparse_material_weight = 21
	rich_material_weight = 39
