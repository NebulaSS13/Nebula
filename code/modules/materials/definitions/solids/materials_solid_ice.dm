/decl/material/solid/ice
	color = "#a5f2f3"
	heating_products = list(
		/decl/material/liquid/water = 1
	)
	name = "water"
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

/decl/material/solid/ice/Initialize()
	if(!liquid_name)
		liquid_name = "liquid [name]" // avoiding the 'molten ice' issue
	if(!gas_name)
		gas_name = name
	if(!solid_name)
		solid_name = "[name] ice"
	if(!ore_name)
		ore_name = solid_name
	. = ..()
	
/decl/material/solid/ice/aspium
	name = "aspium"
	heating_products = list(
		/decl/material/liquid/fuel/hydrazine = 0.3,
		/decl/material/liquid/water = 0.7
	)
	value = 0.4
	sparse_material_weight = 2
	rich_material_weight = 37

/decl/material/solid/ice/lukrite
	name = "lukrite"
	heating_products = list(
		/decl/material/solid/sulfur = 0.4,
		/decl/material/liquid/water = 0.2,
		/decl/material/liquid/acid  = 0.4
	)
	value = 0.3
	sparse_material_weight = 20
	rich_material_weight = 16

/decl/material/solid/ice/rubenium
	name = "rubenium"
	heating_products = list(
		/decl/material/solid/metal/radium  = 0.4,
		/decl/material/liquid/water = 0.4,
		/decl/material/liquid/acetone = 0.2
	)
	value = 0.4
	sparse_material_weight = 20
	rich_material_weight = 13

/decl/material/solid/ice/trigarite
	name = "trigarite"
	heating_products = list(
		/decl/material/liquid/acid/hydrochloric = 0.2,
		/decl/material/liquid/water             = 0.2,
		/decl/material/liquid/mercury           = 0.6
	)
	value = 0.5
	sparse_material_weight = 20
	rich_material_weight = 15

/decl/material/solid/ice/ediroite
	name = "ediroite"
	heating_products = list(
		/decl/material/gas/ammonia  = 0.4,
		/decl/material/liquid/water = 0.2,
		/decl/material/liquid/ethanol = 0.4
	)
	value = 0.2
	sparse_material_weight = 20
	rich_material_weight = 16

/decl/material/solid/ice/hydrogen
	name = "hydrogen"
	heating_products = list(
		/decl/material/gas/hydrogen = 0.2,
		/decl/material/liquid/water = 0.65,
		/decl/material/gas/hydrogen/deuterium = 0.1,
		/decl/material/gas/hydrogen/tritium = 0.05
	)
	value = 0.3
	sparse_material_weight = 20
	rich_material_weight   = 20

////////////////////////////////////
// Gas Hydrates/Clathrates
////////////////////////////////////

//Hydrates gas are basically bubbles of gas trapped in water ice lattices
/decl/material/solid/ice/hydrate
	heating_point = T0C //the melting point is always water's

//Little helper macro, since hydrates are all basically the same
// DISPLAY_NAME is needed because of compounds with white spaces in their names
#define DECLARE_HYDRATE_DNAME_PATH(PATH, NAME, DISPLAY_NAME)                \
/decl/material/solid/ice/hydrate/##NAME/Initialize(){                       \
	name = "[##DISPLAY_NAME] hydrate";                                      \
	heating_products = list(PATH = 0.2, /decl/material/liquid/water = 0.8); \
	. = ..();                                                               \
}                                                                           \
/decl/material/solid/ice/hydrate/##NAME 

#define DECLARE_HYDRATE_DNAME(NAME, DISPLAY_NAME) DECLARE_HYDRATE_DNAME_PATH(/decl/material/gas/##NAME, NAME, DISPLAY_NAME)
#define DECLARE_HYDRATE(NAME) DECLARE_HYDRATE_DNAME(NAME, #NAME)

//
// Definitions
//
DECLARE_HYDRATE(methane)
	value = 0.3
	sparse_material_weight = 10
	rich_material_weight   = 10

DECLARE_HYDRATE(oxygen)
	sparse_material_weight = 10
	rich_material_weight   = 10

DECLARE_HYDRATE(nitrogen)
	sparse_material_weight = 10
	rich_material_weight   = 10

DECLARE_HYDRATE_DNAME(carbon_dioxide, "carbon dioxide")
	sparse_material_weight = 8
	rich_material_weight   = 8

DECLARE_HYDRATE(argon)
	sparse_material_weight = 8
	rich_material_weight   = 8

DECLARE_HYDRATE(neon)
	sparse_material_weight = 15
	rich_material_weight   = 15

DECLARE_HYDRATE(krypton)
	sparse_material_weight = 12
	rich_material_weight   = 12

DECLARE_HYDRATE(xenon)
	sparse_material_weight = 12
	rich_material_weight   = 12

#undef DECLARE_HYDRATE_DNAME_PATH
#undef DECLARE_HYDRATE_DNAME
#undef DECLARE_HYDRATE