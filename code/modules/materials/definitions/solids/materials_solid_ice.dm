/decl/material/solid/ice
	stack_type = null
	color = "#a5f2f3"
	heating_products = list(
		/decl/material/liquid/water = 1
	)
	name = "ice"
	ore_name = "ice"
	taste_description = "ice"
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	removed_by_welder = TRUE
	value = 0.2
	sparse_material_weight = 2
	ore_result_amount = 7
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
	sparse_material_weight = 20
	rich_material_weight = 16

/decl/material/solid/ice/rubenium
	heating_products = list(
		/decl/material/solid/metal/radium  = 0.4,
		/decl/material/liquid/water = 0.4,
		/decl/material/liquid/acetone = 0.2
	)
	name = "rubenium ice"
	ore_name = "rubenium ice"
	value = 0.4
	sparse_material_weight = 20
	rich_material_weight = 13

/decl/material/solid/ice/trigarite
	heating_products = list(
		/decl/material/liquid/acid/hydrochloric = 0.2,
		/decl/material/liquid/water             = 0.2,
		/decl/material/liquid/mercury           = 0.6
	)
	name = "trigarite ice"
	ore_name = "trigarite ice"
	value = 0.5
	sparse_material_weight = 20
	rich_material_weight = 15

/decl/material/solid/ice/ediroite
	heating_products = list(
		/decl/material/gas/ammonia  = 0.4,
		/decl/material/liquid/water = 0.2,
		/decl/material/liquid/ethanol = 0.4
	)
	name = "ediroite ice"
	ore_name = "ediroite ice"
	value = 0.2
	sparse_material_weight = 20
	rich_material_weight = 16

//
// Frozen basic gases
//
/decl/material/solid/ice/hydrogen
	heating_products = list(
		/decl/material/gas/hydrogen = 1
	)
	name = "hydrogen ice"
	ore_name = "hydrogen ice"
	value = 0.3
	heating_point = 13 //k
	sparse_material_weight = 20
	rich_material_weight = 20

/decl/material/solid/ice/oxygen
	heating_products = list(
		/decl/material/gas/oxygen = 1
	)
	name = "oxygen ice"
	ore_name = "oxygen ice"
	melting_point = 54 //K
	sparse_material_weight = 10
	rich_material_weight = 10

/decl/material/solid/ice/nitrogen
	heating_products = list(
		/decl/material/gas/nitrogen = 1
	)
	name = "nitrogen ice"
	ore_name = "nitrogen ice"
	melting_point = 63 //K
	sparse_material_weight = 10
	rich_material_weight = 10

/decl/material/solid/ice/carbon_dioxide
	heating_products = list(
		/decl/material/gas/carbon_dioxide = 1
	)
	name = "carbon dioxide ice"
	ore_name = "carbon dioxide ice"
	melting_point = 216 //K
	sparse_material_weight = 8
	rich_material_weight = 8

/decl/material/solid/ice/methane
	heating_products = list(
		/decl/material/gas/methane = 1
	)
	name = "methane ice"
	ore_name = "methane ice"
	value = 0.3
	melting_point = 90 //K
	sparse_material_weight = 10
	rich_material_weight = 10

/decl/material/solid/ice/ammonia
	heating_products = list(
		/decl/material/gas/ammonia = 1
	)
	name = "ammonia ice"
	ore_name = "ammonia ice"
	melting_point = 195 //k
	sparse_material_weight = 20
	rich_material_weight = 16

/decl/material/solid/ice/argon
	heating_products = list(
		/decl/material/gas/argon = 1
	)
	name = "argon ice"
	ore_name = "argon ice"
	melting_point = 83 //K
	sparse_material_weight = 8
	rich_material_weight = 8
	
/decl/material/solid/ice/neon
	heating_products = list(
		/decl/material/gas/neon = 1
	)
	name = "neon ice"
	ore_name = "neon ice"
	melting_point = 24 //K
	sparse_material_weight = 15
	rich_material_weight = 15

/decl/material/solid/ice/xenon
	heating_products = list(
		/decl/material/gas/xenon = 1
	)
	name = "xenon ice"
	ore_name = "xenon ice"
	value = 0.3
	melting_point = 161 //k
	sparse_material_weight = 12
	rich_material_weight = 12

/decl/material/solid/ice/chlorine
	heating_products = list(
		/decl/material/gas/chlorine = 1
	)
	name = "chlorine ice"
	ore_name = "chlorine ice"
	melting_point = 171 //k
	sparse_material_weight = 10
	rich_material_weight = 10

/decl/material/solid/ice/sulfur_dioxide
	heating_products = list(
		/decl/material/gas/sulfur_dioxide = 1
	)
	name = "sulfur dioxide ice"
	ore_name = "sulfur dioxide ice"
	melting_point = 201 //k
	sparse_material_weight = 10
	rich_material_weight = 10
