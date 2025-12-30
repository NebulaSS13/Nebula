/*
	MATERIAL DECLS
	This data is used by various parts of the game for basic physical properties and behaviors
	of the metals/materials used for constructing many objects. Each var is commented and should be pretty
	self-explanatory but the various object types may have their own documentation.
*/

/// A lookup table of material decls by their gas symbol, used for selection in atmos filters.
var/global/list/materials_by_gas_symbol = list()

// Material definition and procs follow.
/decl/material

	abstract_type = /decl/material
	decl_flags = DECL_FLAG_MANDATORY_UID

	var/name               // Prettier name for display.
	var/codex_name         // Override for the codex article name.
	var/adjective_name
	var/solid_name
	var/gas_name
	var/liquid_name
	var/solution_name      // Name for the material in solution.
	var/use_name
	var/wall_name = "wall" // Name given to walls of this material
	var/flags = 0          // Various status modifiers.
	var/hidden_from_codex
	var/lore_text
	var/mechanics_text
	var/antag_text
	var/default_solid_form = /obj/item/stack/material/sheet

	var/soup_hot_desc = "simmering"

	var/affect_blood_on_ingest = 0.5
	var/affect_blood_on_inhale = 0.75

	var/narcosis = 0 // Not a great word for it. Constant for causing mild confusion when ingested.
	var/toxicity = 0 // Organ damage from ingestion.
	var/toxicity_targets_organ // Bypass liver/kidneys when ingested, harm this organ directly (using BP_FOO defines).

	var/can_backfill_floor_type

	// Shards/tables/structures
	var/shard_type = /obj/item/shard
	var/shard_name = SHARD_SHRAPNEL as text // Path of debris object.
	var/shard_icon                        // Related to above.
	var/shard_can_repair = 1              // Can shards be turned into sheets with a welder?
	var/destruction_desc = "breaks apart" // Fancy string for barricades/tables/objects exploding.
	var/destruction_sound = "fracture"     // As above, but the sound that plays.

	// Icons
	var/icon_base = 'icons/turf/walls/solid.dmi'
	var/icon_base_natural = 'icons/turf/walls/natural.dmi'
	/// Either the icon used for reinforcement, or a list of icons to pick from.
	var/icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	var/wall_flags = 0
	var/list/wall_blend_icons = list() // Which wall icon types walls of this material type will consider blending with. Assoc list (icon path = TRUE/FALSE)
	var/use_reinf_state = "full"

	var/door_icon_base = "metal"                         // Door base icon tag. See header.
	var/table_icon_base = "metal"
	var/table_icon_reinforced = "reinf_metal"

	// TODO: Refactor these to just apply a generic material overlay (e.g. wood grain) instead of entirely-separate icon files?
	// Alternatively, find some other way for icon variation based on material.
	// You can't do it by having separate states in the base icons,
	// because then modpacked materials can't add new states,
	// and what if we really really want a special nullglass pew sprite or something?
	var/bench_icon = 'icons/obj/structures/furniture/bench.dmi'
	var/pew_icon = 'icons/obj/structures/furniture/pew.dmi'
	var/slatted_seat_icon = 'icons/obj/structures/furniture/chair_slatted.dmi'
	var/backed_chair_icon = 'icons/obj/structures/furniture/chair_backed.dmi'

	var/list/stack_origin_tech = @'{"materials":1}' // Research level for stacks.

	// Attributes
	/// Does this material float to the top of liquids, allowing it to be skimmed off? Specific to cream at time of writing.
	var/skimmable = FALSE
	/// How rare is this material in exoplanet xenoflora?
	var/exoplanet_rarity_plant = MAT_RARITY_MUNDANE
	/// How rare is this material in exoplanet atmospheres?
	var/exoplanet_rarity_gas = MAT_RARITY_MUNDANE
	/// Delay in ticks when cutting through this wall.
	var/cut_delay = 0
	/// Radiation var. Used in wall and object processing to irradiate surroundings.
	var/radioactivity
	/// K, point at which the material catches on fire.
	var/ignition_point
	/// K, walls will take damage if they're next to a fire hotter than this
	var/melting_point = 1800
	/// K, point that material will become a gas.
	var/boiling_point = 3000
	/// Set automatically if null based on ignition, boiling and melting point
	var/temperature_damage_threshold
	/// kJ/kg, enthalpy of vaporization
	var/latent_heat = 7000
	/// kg/mol
	var/molar_mass = 0.06
	/// g/ml
	var/liquid_density = 0.997
	/// g/ml
	var/solid_density = 0.9168
	/// Brute damage to a wall is divided by this value if the wall is reinforced by this material.
	var/brute_armor = 2
	/// Same as above, but for Burn damage type. If blank brute_armor's value is used.
	var/burn_armor
	/// General-use HP value for products.
	var/integrity = 150
	/// Is the material transparent? 0.5< makes transparent walls/doors.
	var/opacity = 1.0
	/// Only used by walls currently.
	var/explosion_resistance = 5
	/// Objects with this var add CONDUCTS to flags on spawn.
	var/conductive = 1
	/// Does this material glow?
	var/luminescence
	/// Used for checking if a material can function as a wall support.
	var/wall_support_value = 30
	/// Ore generation constant for rare materials.
	var/sparse_material_weight
	/// Ore generation constant for common materials.
	var/rich_material_weight
	/// How transparent can fluids be?
	var/min_fluid_opacity = FLUID_MIN_ALPHA
	/// How opaque can fluids be?
	var/max_fluid_opacity = FLUID_MAX_ALPHA
	/// Point at which the fluid will proc turf interaction logic. Workaround for mops being ruined forever by 1u of anything else being added.
	var/turf_touch_threshold = FLUID_QDEL_POINT
	/// Whether or not billets of this material will glow with heat.
	var/glows_with_heat = FALSE

	// Damage values.
	var/hardness = MAT_VALUE_HARD       // Used for edge damage in weapons.
	var/weight = MAT_VALUE_NORMAL       // Determines blunt damage/throw force for weapons.
	var/reflectiveness = MAT_VALUE_DULL // How effective is this at reflecting light?
	var/ferrous = FALSE                 // Can be used as a striker for firemaking.

	// Noise when someone is faceplanted onto a table made of this material.
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	// Noise made when a simple door made of this material opens or closes.
	var/dooropen_noise = 'sound/effects/stonedoor_openclose.ogg'
	// Noise made when you hit structure made of this material.
	var/hitsound = 'sound/weapons/genhit.ogg'
	// Wallrot crumble message.
	var/rotting_touch_message = "crumbles under your touch"
	/// When a stack recipe doesn't specify a skill to use, use this skill.
	var/crafting_skill = SKILL_CONSTRUCTION
	// Modifies skill checks when constructing with this material.
	var/construction_difficulty = MAT_VALUE_EASY_DIY
	// Determines what is used to remove or dismantle this material.
	var/removed_by_welder

	// Mining behavior.
	var/ore_name
	var/ore_desc
	var/ore_compresses_to
	var/ore_result_amount
	var/ore_spread_chance
	var/ore_scan_icon
	var/ore_icon_overlay
	var/ore_type_value
	var/ore_data_value
	var/ore_type = /obj/item/stack/material/ore

	var/value = 1

	// Xenoarch behavior.
	var/xarch_source_mineral = /decl/material/solid/metal/iron

	// Gas behavior.
	var/gas_overlay_limit
	var/gas_specific_heat = 20    // J/(mol*K)
	var/gas_symbol_html
	var/gas_symbol
	var/gas_flags = 0
	var/gas_tile_overlay = "generic"
	var/gas_condensation_point = null
	var/gas_metabolically_inert = FALSE // If false, material will move into the bloodstream when breathed.
	// Armor values generated from properties
	var/list/basic_armor
	var/armor_degradation_speed

	// Allergen values, used by /mob/living and /datum/reagents
	/// What allergens are present on this material?
	var/allergen_flags  = ALLERGEN_NONE
	var/allergen_factor = 2

	// Copied reagent values. Todo: integrate.
	var/taste_description
	var/taste_mult = 1 //how this taste compares to others. Higher values means it is more noticable
	var/metabolism = REM // This would be 0.2 normally
	var/ingest_met = 0
	var/touch_met = 0
	var/inhale_met = 0
	var/overdose = 0
	var/scannable = 0 // Shows up on health analyzers.
	var/color = COLOR_BEIGE
	// How much variance in color do objects of this material have, in fraction of maximum brightness/hue.
	var/color_variance = 0.04
	var/color_weight = 1
	var/cocktail_ingredient
	var/defoliant
	var/fruit_descriptor // String added to fruit desc if this chemical is present.
	/// Does this reagent have an antibiotic effect (helping with infections)?
	var/antibiotic_strength = 0

	var/dirtiness = DIRTINESS_NEUTRAL // How dirty turfs are after being exposed to this material. Negative values cause a cleaning/sterilizing effect.
	var/decontamination_dose = 0      // Amount required for a decontamination effect, if any.
	var/solvent_power = MAT_SOLVENT_NONE
	var/solvent_melt_dose = 0
	var/solvent_max_damage  = 0
	var/slipperiness = 0
	var/slippery_amount = 1
	var/euphoriant // If set, ingesting/injecting this material will cause the rainbow high overlay/behavior.

	var/glass_icon = DRINK_ICON_DEFAULT
	var/glass_name = "something"
	var/glass_desc = "It's a glass of... what, exactly?"
	var/list/glass_special = null // null equivalent to list()

	// Matter state data.
	var/dissolve_message = "dissolves in"
	var/dissolve_sound = 'sound/effects/bubbles.ogg'
	var/dissolves_in = MAT_SOLVENT_STRONG
	var/list/dissolves_into	// Used with the grinder and a solvent to extract other materials.

	var/chilling_point
	var/chilling_message = "crackles and freezes!"
	var/chilling_sound = 'sound/effects/bubbles.ogg'
	var/list/chilling_products

	var/heating_point
	var/heating_message = "begins to boil!"
	var/heating_sound = 'sound/effects/bubbles.ogg'
	var/list/heating_products
	var/accelerant_value = FUEL_VALUE_NONE
	var/burn_temperature = 100 CELSIUS
	var/burn_product
	var/list/vapor_products // If splashed, releases these gasses in these proportions. // TODO add to unit test after solvent PR is merged

	var/scent //refer to _scent.dm
	var/scent_intensity = /decl/scent_intensity/normal
	var/scent_descriptor = "smell"
	var/scent_range = 1

	var/list/neutron_interactions // Associative List of potential neutron interactions for the material to undergo, corresponding to the ideal
								  // neutron energy for that reaction to occur.

	var/neutron_cross_section	  // How broad the neutron interaction curve is, independent of temperature. Materials that are harder to react with will have lower values.
	var/absorption_products		  // Transmutes into these reagents following neutron absorption and/or subsequent beta decay. Generally forms heavier reagents.
	var/fission_products		  // Transmutes into these reagents following fission. Forms lighter reagents, and a lot of heat.
	var/neutron_production		  // How many neutrons are created per unit per fission event.
	var/neutron_absorption		  // How many neutrons are absorbed per unit per absorption event.
	var/fission_heat			  // How much thermal energy per unit per fission event this material releases.
	var/fission_energy			  // Energy of neutrons released by fission.
	var/moderation_target		  // The 'target' neutron energy value that the fission environment shifts towards after a moderation event.
								  // Neutron moderators can only slow down neutrons.

	var/sound_manipulate          //Default sound something like a material stack made of this material does when picked up
	var/sound_dropped             //Default sound something like a material stack made of this material does when hitting the ground or placed down

	var/holographic // Set to true if this material is fake/visual only.

	/// Does high temperature baking change this material into something else?
	var/bakes_into_material
	var/bakes_into_at_temperature

	/// If set to a material type, stacks of this material will be able to be tanned on a drying rack after being wetted to convert them to tans_to.
	var/tans_to
	/// A multiplier for this material when used in fishing bait.
	var/fishing_bait_value = 0
	/// A relative value used only by fishing line at time of commit.
	var/tensile_strength = 0

	/// What form does this take if dug out of the ground, if any?
	var/dug_drop_type

	/// Can objects containing this material be used for textile spinning?
	var/has_textile_fibers = FALSE

	/// Whether or not turfs made of this material can support plants.
	var/tillable = FALSE

	var/compost_value = 0

	/// Nutrition values!
	var/nutriment_factor     = 0 // Per removed amount each tick
	var/hydration_factor     = 0 // Per removed amount each tick
	var/injectable_nutrition = FALSE
	var/reagent_overlay
	var/reagent_overlay_base = "reagent_base"

	/// Set to a type to indicate that a type with a matching milestone type should be used as a reference point for burn temperatures.
	var/temperature_burn_milestone_material

	/// Semi-temporary fix to issues with soup/tea boil-off - only set to TRUE on water and ethanol at time of commit.
	var/can_boil_to_gas = FALSE
	/// How much of this boils away per evaporation run?
	var/boil_evaporation_per_run = 1

	/// What verb is used when describing a colored piece of this material? e.g. 'dyed' or 'painted'
	/// If an item has a null paint_verb, it automatically sets it based on material.
	var/paint_verb = "painted"

	/// Chance of a natural wall made of this material dropping a gemstone, if the gemstone_types list is populated.
	var/gemstone_chance = 5
	/// Assoc weighted list of gemstone material types to weighting.
	var/list/gemstone_types

	var/forgable = FALSE // Can this material be forged in bar/billet form?

// Used by walls when qdel()ing to avoid neighbor merging.
/decl/material/placeholder
	name = "placeholder"
	uid = "mat_placeholder"
	hidden_from_codex = TRUE
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	holographic = TRUE

// Make sure we have a use name and shard icon even if they aren't explicitly set.
/decl/material/Initialize()
	. = ..()
	if(!name)
		CRASH("Unnamed material /decl tried to initialize.")
	// Default use_name to name if unset.
	use_name       ||= name
	// Default the other state names to use_name, so that if it's overridden, we use that instead of base name.
	liquid_name    ||= use_name
	solid_name     ||= use_name
	gas_name       ||= use_name
	// Use solid_name for adjective_name so that we get "ice bracelet" instead of "water bracelet" for things made of water below 0C.
	adjective_name ||= solid_name
	adjective_name ||= use_name

	// Null/clear a bunch of physical vars as this material is fake.
	if(holographic)
		temperature_burn_milestone_material = null
		can_boil_to_gas              = FALSE
		shard_name                   = SHARD_NONE
		shard_type                   = null
		conductive                   = 0
		hidden_from_codex            = TRUE
		value                        = 0
		exoplanet_rarity_plant       = MAT_RARITY_NOWHERE
		exoplanet_rarity_gas         = MAT_RARITY_NOWHERE
		dissolves_into               = null
		dissolves_in                 = MAT_SOLVENT_IMMUNE
		solvent_power                = MAT_SOLVENT_NONE
		heating_products             = null
		chilling_products            = null
		heating_point                = null
		chilling_point               = null
		solvent_melt_dose            = 0
		solvent_max_damage           = 0
		slipperiness                 = 0
		bakes_into_at_temperature    = null
		ignition_point               = null
		melting_point                = null
		boiling_point                = null
		temperature_damage_threshold = INFINITY
		accelerant_value             = FUEL_VALUE_NONE
		burn_product                 = null
		vapor_products               = null
		compost_value                = 0
		forgable                     = FALSE
	else if(isnull(temperature_damage_threshold))
		var/new_temperature_damage_threshold = max(melting_point, boiling_point, heating_point)
		// Don't let the threshold be lower than the ignition point.
		if(isnull(new_temperature_damage_threshold) && !isnull(ignition_point))
			temperature_damage_threshold = ignition_point
		else if(isnull(ignition_point) || (new_temperature_damage_threshold > ignition_point))
			temperature_damage_threshold = new_temperature_damage_threshold

	if(!shard_icon)
		shard_icon = shard_name
	if(!burn_armor)
		burn_armor = brute_armor
	if(!gas_symbol)
		gas_symbol = "[name]_[sequential_id(abstract_type)]"
	if(!gas_symbol_html)
		gas_symbol_html = gas_symbol
	global.materials_by_gas_symbol[gas_symbol] = type
	generate_armor_values()

	if(!holographic)
		var/list/cocktails = decls_repository.get_decls_of_subtype(/decl/cocktail)
		for(var/ctype in cocktails)
			var/decl/cocktail/cocktail = cocktails[ctype]
			if(type in cocktail.ratios)
				cocktail_ingredient = TRUE
				break

/decl/material/validate()
	. = ..()

	if(!crafting_skill)
		. += "no construction skill set"
	else if(!isnull(construction_difficulty))
		var/decl/skill/used_skill = GET_DECL(crafting_skill)
		if(!istype(used_skill))
			. += "invalid skill decl [used_skill]"
		else if(length(used_skill.levels) < construction_difficulty)
			. += "required skill [used_skill] is missing skill level [json_encode(construction_difficulty)]"

	if(isnull(construction_difficulty))
		. += "no construction difficulty set"

	if(!isnull(bakes_into_at_temperature))
		// all of these variables should be above our baking temperature, because we assume only solids not currently on fire can bake
		// modify this if a material ever needs to bake while liquid or gaseous
		var/list/temperatures = list("melting point" = melting_point, "boiling point" = boiling_point, "heating point" = heating_point, "ignition point" = ignition_point)
		for(var/temperature in temperatures)
			if(isnull(temperatures[temperature]))
				continue
			if(temperatures[temperature] <= bakes_into_at_temperature)
				. += "baking point is set but [temperature] is lower or equal to it"

	// this is a little overengineered for only two values...
	// but requiring heating_point > boiling_point caused a bunch of issues
	// at least it's easy to add more if we want to enforce order more
	var/list/transition_temperatures_ascending = list("melting point" = melting_point, "boiling point" = boiling_point)
	var/max_key // if not null, this is a key from the above list
	for(var/temperature_key in transition_temperatures_ascending)
		var/temperature = transition_temperatures_ascending[temperature_key]
		if(isnull(temperature))
			continue
		if(!isnull(max_key) && temperature <= transition_temperatures_ascending[max_key])
			var/expected_temp = transition_temperatures_ascending[max_key]
			. += "transition temperature [temperature_key] ([temperature]K, [temperature - T0C]C) is colder than [max_key], expected >[expected_temp]K ([expected_temp - T0C]C)!"
		else
			max_key = temperature_key

	if(accelerant_value > FUEL_VALUE_NONE && isnull(ignition_point))
		. += "accelerant value larger than zero but null ignition point"
	if(!isnull(ignition_point) && accelerant_value <= FUEL_VALUE_NONE)
		. += "accelerant value below zero but non-null ignition point"
	if(length(dissolves_into) && isnull(dissolves_in))
		. += "dissolves_into set but dissolves_in is undefined"
	if(length(heating_products) && isnull(heating_point))
		. += "heating_products set but heating_point is undefined"
	if(length(chilling_products) && isnull(chilling_point))
		. += "chilling_products set but chilling_point is undefined"

	var/list/checking = list(
		"dissolves" = dissolves_into,
		"heats" = heating_products,
		"chills" = chilling_products
	)
	for(var/field in checking)
		var/list/checking_list = checking[field]
		if(length(checking_list))
			var/total = 0
			for(var/chem in checking_list)
				total += checking_list[chem]
			if(total != 1)
				. += "[field] adds up to [total] (should be 1)"

	if(dissolves_in == MAT_SOLVENT_IMMUNE && LAZYLEN(dissolves_into))
		. += "material is immune to solvents, but has dissolves_into products."

	if(!paint_verb)
		. += "material does not have a paint_verb set"
	else if(!istext(paint_verb))
		. += "material has a non-text paint_verb value"

	for(var/i = 0 to 7)
		if(icon_base)
			if(!check_state_in_icon("[i]", icon_base))
				. += "'[icon_base]' - missing directional base icon state '[i]'"
			if(!check_state_in_icon("other[i]", icon_base))
				. += "'[icon_base]' - missing connective base icon state 'other[i]'"

		if(wall_flags & PAINT_PAINTABLE)
			if(!check_state_in_icon("paint[i]", icon_base))
				. += "'[icon_base]' - missing directional paint icon state '[i]'"
		if(wall_flags & PAINT_STRIPABLE)
			if(!check_state_in_icon("stripe[i]", icon_base))
				. += "'[icon_base]' - missing directional stripe icon state '[i]'"
		if(wall_flags & WALL_HAS_EDGES)
			if(!check_state_in_icon("other[i]", icon_base))
				. += "'[icon_base]' - missing directional edge icon state '[i]'"

		if(icon_base_natural)
			if(!check_state_in_icon("[i]", icon_base_natural))
				. += "'[icon_base_natural]' - missing directional natural icon state '[i]'"
			if(!check_state_in_icon("shine[i]", icon_base_natural))
				. += "'[icon_base_natural]' - missing natural shine icon state 'shine[i]'"

	if(icon_reinf)
		var/list/all_reinf_icons = islist(icon_reinf) ? icon_reinf : list(icon_reinf)
		for(var/sub_icon in all_reinf_icons)
			if(use_reinf_state)
				if(!check_state_in_icon(use_reinf_state, sub_icon))
					. += "'[sub_icon]' - missing reinf icon state '[use_reinf_state]'"
			else
				for(var/i = 0 to 7)
					if(!check_state_in_icon(num2text(i), sub_icon))
						. += "'[sub_icon]' - missing directional reinf icon state '[i]'"

	if(length(color) != 7)
		. += "invalid color (not #RRGGBB)"

// Return the matter comprising this material.
/decl/material/proc/get_matter()
	var/list/temp_matter = list()
	temp_matter[type] = SHEET_MATERIAL_AMOUNT
	return temp_matter

// todo: should this lerp instead of using hard cutoffs?
/decl/material/proc/get_attack_cooldown()
	if(weight <= MAT_VALUE_LIGHT)
		return FAST_WEAPON_COOLDOWN
	if(weight >= MAT_VALUE_HEAVY)
		return SLOW_WEAPON_COOLDOWN
	return DEFAULT_WEAPON_COOLDOWN

/decl/material/proc/explosion_act(obj/item/chems/holder, severity)
	SHOULD_CALL_PARENT(TRUE)
	. = TRUE

/decl/material/proc/get_value()
	. = value

/decl/material/proc/combustion_effect(var/turf/T, var/temperature)
	return

/// Used for material-dependent effects on stain dry.
/// Return TRUE to skip default drying handling.
/decl/material/proc/handle_stain_dry(obj/effect/decal/cleanable/blood/stain)
	return FALSE

/// Returns (in deciseconds) how long until dry() will be called on this stain,
/// or null to use the stain's default.
/// If 0 is returned, it dries instantly.
/// If any value below 0 is returned, it doesn't start processing.
/decl/material/proc/get_time_to_dry_stain(obj/effect/decal/cleanable/blood/stain)
	return initial(stain.time_to_dry)

var/global/list/_descriptive_temperature_strings
/// Returns a list of strings explaining certain material transitions that can happen at the given temperature,
/// e.g. 'ignite paper', 'melt lead', 'boil water' and so on.
/proc/get_descriptive_temperature_strings(temperature as num)
	if(!_descriptive_temperature_strings)
		_descriptive_temperature_strings = list()

		for(var/decl/material/desc_material as anything in decls_repository.get_decls_of_subtype_unassociated(/decl/material))

			if(desc_material.type != desc_material.temperature_burn_milestone_material)
				continue

			if(!isnull(desc_material.bakes_into_at_temperature) && desc_material.bakes_into_material)
				var/decl/material/cook = GET_DECL(desc_material.bakes_into_material)
				global._descriptive_temperature_strings["bake [desc_material.name] into [cook.name]"] = desc_material.bakes_into_at_temperature
				continue

			switch(desc_material.phase_at_temperature())
				if(MAT_PHASE_SOLID)
					if(!isnull(desc_material.ignition_point))
						global._descriptive_temperature_strings["ignite [desc_material.name]"] = desc_material.ignition_point
					else if(!isnull(desc_material.melting_point))
						global._descriptive_temperature_strings["melt [desc_material.name]"] = desc_material.melting_point
				if(MAT_PHASE_LIQUID)
					if(!isnull(desc_material.boiling_point))
						global._descriptive_temperature_strings["boil [desc_material.name]"] = desc_material.boiling_point

	for(var/burn_string in global._descriptive_temperature_strings)
		if(temperature >= global._descriptive_temperature_strings[burn_string])
			LAZYADD(., burn_string)