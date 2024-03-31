/decl/material/solid/ice
	name                   = "water"
	use_name               = "ice"
	solid_name             = "ice"
	liquid_name            = "water"
	gas_name               = "steam"
	color                  = "#a5f2f3"
	codex_name             = "water ice"
	taste_description      = "ice"
	ore_spread_chance      = 25
	ore_scan_icon          = "mineral_common"
	ore_icon_overlay       = "lump"
	removed_by_welder      = TRUE
	value                  = 0.2
	sparse_material_weight = 2
	ore_result_amount      = 4
	rich_material_weight   = 37
	heating_point          = T20C + 10 // Above room temperature, to avoid drinks melting.
	uid                    = "solid_ice"
	heating_products       = list(
		/decl/material/liquid/water = 1
	)

/decl/material/solid/ice/Initialize()
	liquid_name ||= "liquid [name]" // avoiding the 'molten ice' issue
	gas_name    ||= name
	solid_name  ||= "[name] ice"
	use_name    ||= solid_name
	ore_name    ||= solid_name
	. = ..()

/decl/material/solid/ice/snow
	name = "snow"
	liquid_name = "water"
	solid_name = "snow"
	gas_name = "steam"
	color = COLOR_WHITE
	codex_name = null
	uid = "solid_snow"
	hardness = MAT_VALUE_MALLEABLE
	dug_drop_type = /obj/item/stack/material/ore/handful
	default_solid_form = /obj/item/stack/material/ore/handful
	can_backfill_turf_type = /turf/floor/snow

/decl/material/solid/ice/aspium
	name = "aspium"
	use_name = null
	codex_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	heating_products = list(
		/decl/material/liquid/fuel/hydrazine = 0.3,
		/decl/material/liquid/water = 0.7
	)
	uid = "solid_ice_aspium"
	value = 0.4
	sparse_material_weight = 2
	rich_material_weight = 37

/decl/material/solid/ice/lukrite
	name = "lukrite"
	use_name = null
	codex_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	heating_products = list(
		/decl/material/solid/sulfur = 0.4,
		/decl/material/liquid/water = 0.2,
		/decl/material/liquid/acid  = 0.4
	)
	uid = "solid_ice_lukrite"
	value = 0.3
	sparse_material_weight = 20
	rich_material_weight = 16

/decl/material/solid/ice/rubenium
	name = "rubenium"
	use_name = null
	codex_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	heating_products = list(
		/decl/material/solid/metal/radium  = 0.4,
		/decl/material/liquid/water = 0.4,
		/decl/material/liquid/acetone = 0.2
	)
	uid = "solid_ice_rubenium"
	value = 0.4
	sparse_material_weight = 20
	rich_material_weight = 13

/decl/material/solid/ice/trigarite
	name = "trigarite"
	use_name = null
	codex_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	heating_products = list(
		/decl/material/liquid/acid/hydrochloric = 0.2,
		/decl/material/liquid/water             = 0.2,
		/decl/material/liquid/mercury           = 0.6
	)
	uid = "solid_ice_trigarite"
	value = 0.5
	sparse_material_weight = 20
	rich_material_weight = 15

/decl/material/solid/ice/ediroite
	name = "ediroite"
	use_name = null
	codex_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	heating_products = list(
		/decl/material/gas/ammonia  = 0.05,
		/decl/material/liquid/water = 0.55,
		/decl/material/liquid/ethanol = 0.4
	)
	uid = "solid_ice_ediroite"
	value = 0.2
	sparse_material_weight = 20
	rich_material_weight = 16

/decl/material/solid/ice/hydrogen
	name = "hydrogen ice"
	use_name = null
	codex_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	uid = "solid_ice_hydrogen"
	heating_products = list(
		/decl/material/gas/hydrogen = 0.05,
		/decl/material/liquid/water = 0.92,
		/decl/material/gas/hydrogen/deuterium = 0.02,
		/decl/material/gas/hydrogen/tritium = 0.01
	)
	value = 0.3
	sparse_material_weight = 20
	rich_material_weight   = 20

////////////////////////////////////
// Gas Hydrates/Clathrates
////////////////////////////////////

//Hydrates gas are basically bubbles of gas trapped in water ice lattices
/decl/material/solid/ice/hydrate
	codex_name = null
	use_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	uid = "solid_hydrate"
	heating_point = T0C //the melting point is always water's
	abstract_type = /decl/material/solid/ice/hydrate

//Little helper macro, since hydrates are all basically the same
// DISPLAY_NAME is needed because of compounds with white spaces in their names
#define DECLARE_HYDRATE_DNAME_PATH(PATH, NAME, DISPLAY_NAME)               \
/decl/material/solid/ice/hydrate/##NAME/uid = "solid_hydrate_" + #NAME;    \
/decl/material/solid/ice/hydrate/##NAME/name = DISPLAY_NAME + " hydrate"; \
/decl/material/solid/ice/hydrate/##NAME/heating_products = list(           \
	PATH = 0.1,                                                            \
	/decl/material/liquid/water = 0.9                                      \
);                                                                         \
/decl/material/solid/ice/hydrate/##NAME

#define DECLARE_HYDRATE_DNAME(NAME, DISPLAY_NAME) DECLARE_HYDRATE_DNAME_PATH(/decl/material/gas/##NAME, NAME, DISPLAY_NAME)
#define DECLARE_HYDRATE(NAME) DECLARE_HYDRATE_DNAME(NAME, #NAME)

//
// Definitions
//
DECLARE_HYDRATE(methane)
	uid = "solid_ice_methane"
	value = 0.3
	sparse_material_weight = 10
	rich_material_weight   = 10

DECLARE_HYDRATE(oxygen)
	uid = "solid_ice_oxygen"
	sparse_material_weight = 10
	rich_material_weight   = 10

DECLARE_HYDRATE(nitrogen)
	uid = "solid_ice_nitrogen"
	sparse_material_weight = 10
	rich_material_weight   = 10

DECLARE_HYDRATE_DNAME(carbon_dioxide, "carbon dioxide")
	uid = "solid_ice_carbon_dioxide"
	sparse_material_weight = 8
	rich_material_weight   = 8

DECLARE_HYDRATE(argon)
	uid = "solid_ice_argon"
	sparse_material_weight = 8
	rich_material_weight   = 8

DECLARE_HYDRATE(neon)
	uid = "solid_ice_neon"
	sparse_material_weight = 15
	rich_material_weight   = 15

DECLARE_HYDRATE(krypton)
	uid = "solid_ice_krypton"
	sparse_material_weight = 12
	rich_material_weight   = 12

DECLARE_HYDRATE(xenon)
	uid = "solid_ice_xenon"
	sparse_material_weight = 12
	rich_material_weight   = 12

#undef DECLARE_HYDRATE_DNAME_PATH
#undef DECLARE_HYDRATE_DNAME
#undef DECLARE_HYDRATE