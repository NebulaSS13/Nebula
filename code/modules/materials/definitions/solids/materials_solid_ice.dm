/decl/material/liquid/water/snow
	name = "snow"
	solid_name = "snow"
	adjective_name = "snow"
	coated_adjective = "snowy"
	codex_name = null
	gas_symbol = null
	uid = "solid_snow"
	hardness = MAT_VALUE_MALLEABLE
	dug_drop_type = /obj/item/stack/material/ore/handful
	default_solid_form = /obj/item/stack/material/lump/large
	can_backfill_floor_type = /decl/flooring/snow
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/decl/material/liquid/water/snow/handle_stain_dry(obj/effect/decal/cleanable/blood/stain)
	var/ambient_temperature = stain.get_ambient_temperature()
	if(ambient_temperature < melting_point)
		// reset the drying timer, it's not warm enough to melt
		stain.start_drying() // you'd better not ever melt instantly below your melting point, or else this will cause infinite recursion
	else if(ambient_temperature > boiling_point)
		qdel(src) // melt instantly, no questions asked
	else
		if(--stain.amount < 0) // reduce the amount of snow (amount is always 0 for footprints currently, but maybe someday?)
			qdel(src)
	return TRUE // skip base blood handling

// For snowy footprints melting.
/decl/material/liquid/water/snow/get_time_to_dry_stain(obj/effect/decal/cleanable/blood/stain)
	// Attempt to melt once every two minutes at T20C,
	// and every 5 minutes at T0C, trying to 'fake' latent heat.
	// Above T20C it scales based on (temperature / T20C).
	// At or above the boiling point it melts instantly.
	// This doesn't mean it WILL melt at that point, just that it'll attempt to.
	var/ambient_temperature = max(stain.get_ambient_temperature(), melting_point)
	if(ambient_temperature >= boiling_point)
		return 0 // dry instantly
	if(ambient_temperature < melting_point)
		return 5 MINUTES
	// convert from kelvins to celsius by subtracting the 0C point in Kelvins
	return Interpolate(5 MINUTES, 2 MINUTES, (ambient_temperature - T0C) / 20) / (stain.amount + 1) // Undo the scaling done by blood.

/decl/material/liquid/water/aspium
	name = "aspium"
	use_name = null
	codex_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	gas_symbol = null
	heating_point = T0C
	heating_products = list(
		/decl/material/liquid/fuel/hydrazine = 0.3,
		/decl/material/liquid/water = 0.7
	)
	uid = "solid_ice_aspium"
	value = 0.4
	sparse_material_weight = 2
	rich_material_weight = 37

/decl/material/liquid/water/lukrite
	name = "lukrite"
	use_name = null
	codex_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	gas_symbol = null
	heating_point = T0C
	heating_products = list(
		/decl/material/solid/sulfur = 0.4,
		/decl/material/liquid/water = 0.2,
		/decl/material/liquid/acid  = 0.4
	)
	uid = "solid_ice_lukrite"
	value = 0.3
	sparse_material_weight = 20
	rich_material_weight = 16

/decl/material/liquid/water/rubenium
	name = "rubenium"
	use_name = null
	codex_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	gas_symbol = null
	heating_point = T0C
	heating_products = list(
		/decl/material/solid/metal/radium  = 0.4,
		/decl/material/liquid/water = 0.4,
		/decl/material/liquid/acetone = 0.2
	)
	uid = "solid_ice_rubenium"
	value = 0.4
	sparse_material_weight = 20
	rich_material_weight = 13

/decl/material/liquid/water/trigarite
	name = "trigarite"
	use_name = null
	codex_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	gas_symbol = null
	heating_point = T0C
	heating_products = list(
		/decl/material/liquid/acid/hydrochloric = 0.2,
		/decl/material/liquid/water             = 0.2,
		/decl/material/liquid/mercury           = 0.6
	)
	uid = "solid_ice_trigarite"
	value = 0.5
	sparse_material_weight = 20
	rich_material_weight = 15

/decl/material/liquid/water/ediroite
	name = "ediroite"
	use_name = null
	codex_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	gas_symbol = null
	heating_point = T0C
	heating_products = list(
		/decl/material/gas/ammonia            = 0.05,
		/decl/material/liquid/water           = 0.55,
		/decl/material/liquid/alcohol/ethanol = 0.4
	)
	uid = "solid_ice_ediroite"
	value = 0.2
	sparse_material_weight = 20
	rich_material_weight = 16

/decl/material/liquid/water/hydrogen
	name = "hydrogen ice"
	use_name = null
	codex_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	gas_symbol = null
	uid = "solid_ice_hydrogen"
	heating_point = T0C
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
/decl/material/liquid/water/hydrate
	codex_name = null
	use_name = null
	solid_name = null
	liquid_name = null
	gas_name = null
	gas_symbol = null
	uid = "solid_hydrate"
	heating_point = T0C //the melting point is always water's
	abstract_type = /decl/material/liquid/water/hydrate

//Little helper macro, since hydrates are all basically the same
// DISPLAY_NAME is needed because of compounds with white spaces in their names
#define DECLARE_HYDRATE_DNAME_PATH(PATH, NAME, DISPLAY_NAME)                 \
/decl/material/liquid/water/hydrate/##NAME/uid = "solid_hydrate_" + #NAME;   \
/decl/material/liquid/water/hydrate/##NAME/name = DISPLAY_NAME + " hydrate"; \
/decl/material/liquid/water/hydrate/##NAME/heating_point = T0C;              \
/decl/material/liquid/water/hydrate/##NAME/heating_products = list(          \
	PATH = 0.1,                                                              \
	/decl/material/liquid/water = 0.9                                        \
);                                                                           \
/decl/material/liquid/water/hydrate/##NAME

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
