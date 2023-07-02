//////////////////////////////////////////////////////////////////////
// Planetoid Data
//////////////////////////////////////////////////////////////////////

/**
 * Data for a planetoid. Used by SSmapping for keeping track of a lot of details about specific planetoids.
 */
/datum/planetoid_data
	///Unique internal Id string for looking up this planetoid in SSmapping
	var/id
	//The name for this planetoid that's displayed to users
	var/name

	// *** Level ***
	///Preferred width for all the planet z-levels. Null means it's up to each z-levels. Not reliable for telling the width of the levels under this planet.
	var/width
	///Preferred height for all the planet z-levels. Null means it's up to each z-levels. Not reliable for telling the height of the levels under this planet.
	var/height
	///Preferred amount of vertically connected z-levels for this planets. Null means it's up to each z-levels.
	var/tallness = 1
	///Topmost level data datum id of the root z stack (ID only, because this datum has an uncontrolled lifetime, and we don't want dangling refs)
	var/topmost_level_id
	///Level data id for the level that's considered to be the planet's surface. In other words, the topmost firm ground level of the root z stack.
	var/surface_level_id
	///A reference to the surface area of the planet.
	var/area/surface_area

	// *** Atmos ***
	///The habitability rating for this planetoid
	var/habitability_class = HABITABILITY_DEAD
	///The cached planet's atmosphere that sub-levels of this planet should use. Can be a type path at definition, and an instance at runtime.
	var/datum/gas_mixture/atmosphere
	///The minimum temperature that can be reached on the planet.(For instance via meteo or sunlight/shade or whatever)
	var/temperature_min = 0 CELSIUS
	///The maximum temperature that can be reached on the planet.(For instance via meteo or sunlight/shade or whatever)
	var/temperature_max = 25 CELSIUS
	///What weather state to use for this planet initially. If null, will not initialize any weather system. May be type path at definition or instance at runtime.
	var/decl/state/weather/initial_weather_state

	// *** Appearence ***
	///A weak reference to the overmap marker for this template instance if any exists. Or at definition the type path of the marker to use
	var/weakref/overmap_marker
	///Color of the primary layer of the skybox image. Used by the overmap marker.
	var/surface_color = COLOR_ASTEROID_ROCK
	///Color of the secondary layer of the skybox image. Is usually water-like features. Used by the overmap marker.
	var/water_color = "#436499"
	///The color for rocks on this planet. Null is the rock wall's material's default.
	var/rock_color = COLOR_ASTEROID_ROCK
	///Whether this planetoid has rings, used by the overmap marker to draw rings in the skybox and etc..
	var/has_rings = FALSE
	///If we have rings, this is the color they'll have on the overmap
	var/ring_color = COLOR_OFF_WHITE
	///If we have rings, this is the sprite we picked for it
	var/ring_type_name = SKYBOX_PLANET_RING_TYPE_SPARSE
	///The overall strata of the planet. May be a type path at definition, or instance at runtime.
	var/decl/strata/strata

	// *** Generated Features ***
	///List of theme types that were randomly picked from the possible list at runtime. Also used by the overmap marker.
	var/list/themes
	///List of subtemplates types we picked and spawned on this planet.
	var/list/subtemplates

	// *** Xenorach ***
	///A xenoarch flavor text generator instance for this planet. Used for unique engravings and weird visions stuff.
	var/datum/xenoarch_engraving_flavor/engraving_generator = /datum/xenoarch_engraving_flavor

	// *** Ambient Lighting ***
	//#TODO: Make it so this is handled in a subsystem or something?
	// Day/night cycle tracking.
	var/starts_at_night = FALSE
	///How often do we change day and night. Null means it will stay either night or day forever.
	/// Ensure that the minimum is larger than [maxx * daycycle_column_delay]. Otherwise the right side of the exoplanet can get stuck in a forever day.
	var/day_duration
	///Ambient lighting level across the surface. All surface height levels will be set to this.
	var/surface_light_level
	///Lighjting color used for the entire surface.
	var/surface_light_color

	// *** fauna/flora handling ***
	///The flora generator instance that generates and keep track of the flora types for this planet. May be set to a path to instantiate.
	var/datum/planet_flora/flora
	///The instance of the fauna generator currently managing our fauna if any. May be set to a path to instantiate.
	var/datum/fauna_generator/fauna //#TODO: Temporary thing for allowing animal stuff to be customized in the map_template

	// *** Special Overrides ***
	//#TODO: There is probably a way to handle options set from manually spawning planets that is less shitty?
	///Subtemplate budget override. If something overrode the map_template's base budget, this will be set. Otherwise, it'll stay null. (Used in manual exoplanet generation verb)
	var/tmp/_budget_override
	///Enforces a single theme. If something overrode the map template's base random themes list, this will be set. Otherwise it'll stay null. (Used in manual exoplanet generation verb)
	var/tmp/_theme_forced

/datum/planetoid_data/New()
	generate_planetoid_id()

/datum/planetoid_data/Destroy(force)
	//shouldn't delete before end. Turfs refers to this
	end_processing()
	SSmapping.unregister_planetoid(src) //Clears refs to us, doesn't mess with the levels
	log_debug("Desroying planetoid data ([id], [name]): [log_info_line(src)]")
	. = ..()

///Generate and sets the planetary id for this planetoid if it doesn't have one yet. Called on instantiation.
/datum/planetoid_data/proc/generate_planetoid_id()
	if(length(id))
		return
	return id = "planetoid_[sequential_id(/datum/planetoid_data)]"

///Initializes the internal state of the planetoid, so its data can be used. Should be called no earlier than when SSmapping is running.
/datum/planetoid_data/proc/setup_planetoid()
	SSmapping.register_planetoid(src)

	//Planet composition
	if(ispath(atmosphere))
		set_atmosphere(atmosphere)
	if(ispath(strata))
		set_strata(strata)
	if(ispath(initial_weather_state))
		generate_weather()

	//Handle fauna/flora
	if(ispath(flora))
		setup_flora_data(flora)
	if(ispath(fauna))
		setup_fauna_generator(fauna)
		generate_life()

	//Xenoarch stuff
	if(ispath(engraving_generator))
		set_engraving_generator(engraving_generator)

	//Always keep the overmap marker in sync if we have one set already
	try_update_overmap_marker()

// ** Bunch of overridables below **

///Sets the name of the planetoid, and causes updates to happen to anything linked to us.
/datum/planetoid_data/proc/SetName(var/newname)
	name = newname
	//#TODO: Maybe force an update on linked areas, overmap markers and levels?
	try_update_overmap_marker()

///Sets the habitability of the planetoid for generation and display. Causes the overmap marker to be updated to reflect the changes.
/datum/planetoid_data/proc/set_habitability(var/habitability)
	habitability_class = habitability
	//#TODO: Maybe force an update on linked areas, overmap markers and levels?
	try_update_overmap_marker()

///Sets the atmosphere of the planet to the given gas_mixture instance or type path. Will Clone() the mixture in the arguments for itself.
/datum/planetoid_data/proc/set_atmosphere(var/datum/gas_mixture/A)
	if(ispath(A))
		atmosphere = new A
		return
	//Externally set atmos instances should make a clone always to be the safe side
	atmosphere = A.Clone()

///Resets the given weather state to our planet replacing the old one, and trigger updates. Can be a type path or instance.
/datum/planetoid_data/proc/reset_weather(var/decl/state/weather/W)
	if(ispath(W))
		W = GET_DECL(W)
	initial_weather_state = W
	if(!(topmost_level_id in SSmapping.levels_by_id))
		return //It's entire possible the levels weren't initialized yet, so don't bother.
	//Tells all our levels exposed to the sky to force change the weather.
	SSweather.setup_weather_system(topmost_level_id, initial_weather_state)

///Associate an overmap marker with this planetoid data so we can synchronize the information displayed on the overmap with the actual state of the planet.
/datum/planetoid_data/proc/set_overmap_marker(var/obj/effect/overmap/visitable/sector/planetoid/P)
	if(isnull(P))
		overmap_marker = null
	else
		overmap_marker = weakref(P)
		P.update_from_data(src)

///Sets the planet's strata to the given one. The argument may be a type path or instance. Shouldn't be used outside of setup after the world was generated.
/datum/planetoid_data/proc/set_strata(var/decl/strata/_strata)
	if(ispath(_strata, /decl/strata))
		_strata = GET_DECL(_strata)
	strata = _strata

///Sets the xenoarch engraving generator for the planet. The argument can be either an instance, or a type path.
/datum/planetoid_data/proc/set_engraving_generator(var/datum/xenoarch_engraving_flavor/X)
	if(ispath(X))
		X = new X
	engraving_generator = X

///Set the id of the topmost level of the planetoid. Argument can be a level_data, or level_id string. Should only be set once during setup ideally.
/datum/planetoid_data/proc/set_topmost_level(var/datum/level_data/LD)
	topmost_level_id = istext(LD)? LD : LD.level_id

///Sets the id of the surface level of the planetoid. Argument can be a level_data, or level_id string(make sure the level_data is reachable from SSmapping's level_data by id list).
/// Should be set only once during setup. Also updates our base surface area var.
/datum/planetoid_data/proc/set_surface_level(var/datum/level_data/LD)
	if(istext(LD))
		LD = SSmapping.levels_by_id[LD]
	surface_level_id = LD.level_id
	if(LD.base_area)
		surface_area = LD.get_base_area_instance()

///Is there any flora species on this planetoid?
/datum/planetoid_data/proc/has_flora()
	return LAZYLEN(flora?.small_flora_types) > 0 || LAZYLEN(flora?.big_flora_types) > 0

///Is there any currently live fauna on this planetoid?
/datum/planetoid_data/proc/has_fauna()
	return LAZYLEN(fauna?.live_fauna) > 0

///If the animal is native of this planet returns TRUE.
/datum/planetoid_data/proc/is_native_animal(mob/living/simple_animal/A)
	return LAZYISIN(fauna?.live_fauna, A) || is_type_in_list(A, fauna?.respawn_queue)

///If the plant is native of this planet it will return TRUE.
/datum/planetoid_data/proc/is_native_plant(datum/seed/S)
	return LAZYISIN(flora?.small_flora_types, S) || LAZYISIN(flora?.big_flora_types, S)

///Returns the strata picked for the planet, if there is one.
/datum/planetoid_data/proc/get_strata()
	return strata

///Returns the color of grass picked for this planet or null.
/datum/planetoid_data/proc/get_grass_color()
	return flora?.grass_color

///Returns the color of rock walls on this planet, or null.
/datum/planetoid_data/proc/get_rock_color()
	return rock_color

///Create the specified type of flora data type for this planetoid
/datum/planetoid_data/proc/setup_flora_data(var/flora_data_type)
	if(istype(flora))
		QDEL_NULL(flora)
	else
		flora = null
	flora = new flora_data_type
	flora.setup_flora(atmosphere)
	return flora

///Create the specified type of fauna manager type for this planetoid
/datum/planetoid_data/proc/setup_fauna_generator(var/generator_type)
	if(istype(fauna))
		QDEL_NULL(fauna)
	else
		fauna = null
	return (fauna = new generator_type())

///Registers to neccessary processors and begin running all processing needed by the planet
/datum/planetoid_data/proc/begin_processing()
	if(day_duration)
		SSdaycyle.add_linked_levels(get_linked_level_ids(), starts_at_night, day_duration)

///Stop running any processing needed by the planet, and unregister from processors.
/datum/planetoid_data/proc/end_processing()
	SSdaycyle.remove_linked_levels(topmost_level_id)

//#TODO: Move this into some SS for planet processing stuff or something?
/datum/planetoid_data/Process(wait, tick)
	//#TODO: Repopulation stuff could go into some mob manager thing
	if(fauna)
		fauna.Process(wait, tick)

//#TOOD: Move this somewhere sensible.
/datum/planetoid_data/proc/rename_species(var/species_type, var/newname, var/force = FALSE)
	if(!fauna)
		return FALSE
	. = fauna.rename_species(species_type, newname, force)
	//Overmap has some species stuff, so keep it up to date
	try_update_overmap_marker()

/datum/planetoid_data/proc/get_random_species_name()
	if(!fauna)
		return "alien creature"
	return fauna.get_random_species_name()

///Returns a list of all the level id of the levels associated to this planet
/datum/planetoid_data/proc/get_linked_level_ids()
	var/datum/level_data/LD = SSmapping.levels_by_id[topmost_level_id]
	return SSmapping.get_connected_levels_ids(LD.level_z)

///Make our fauna and flora gen setup.
/datum/planetoid_data/proc/generate_life(var/list/breathable_gas, var/list/toxic_gases)
	if(fauna)
		fauna.generate_fauna(atmosphere, breathable_gas?.Copy(), toxic_gases?.Copy()) //Must be copies here #TODO: Fix this

///Setup the initial weather state for the planet. Doesn't apply it to our z levels however.
/datum/planetoid_data/proc/generate_weather()
	if(ispath(initial_weather_state))
		initial_weather_state = GET_DECL(initial_weather_state)

///Force any overmap markers linked to us to update to match our state
/datum/planetoid_data/proc/try_update_overmap_marker()
	var/obj/effect/overmap/visitable/sector/planetoid/P = overmap_marker?.resolve()
	if(istype(P))
		P.update_from_data(src)
		return TRUE
	return FALSE

//
// Plants and Critter Spawner Procs
//
//#TOOD: Move this somewhere sensible.
/datum/planetoid_data/proc/spawn_random_fauna(var/turf/T)
	if(!fauna)
		return FALSE
	return fauna.try_spawn_fauna(T)

//#TOOD: Move this somewhere sensible.
/datum/planetoid_data/proc/spawn_random_megafauna(var/turf/T)
	if(!fauna)
		return FALSE
	return fauna.try_spawn_megafauna(T)

/datum/planetoid_data/proc/spawn_random_small_flora(var/turf/T)
	if(!flora)
		return FALSE
	return flora.spawn_random_small_flora(T)

/datum/planetoid_data/proc/spawn_random_big_flora(var/turf/T)
	if(!flora)
		return FALSE
	return flora.spawn_random_big_flora(T)


//
// Random Planetoid
//

///A randomly generating planetoid_data, used by random planet map_templates
/datum/planetoid_data/random
	name = null //Must be null for randomly generated name

	///The chance that this planetoid template creates a planetoid with a ring.
	var/ring_gen_probability = 25
	///Possible ring colors
	var/list/possible_ring_color = list(COLOR_OFF_WHITE, "#f0fcff", "#dcc4ad", "#d1dcad", "#adb8dc")
	///Possible ring sprites that can be used for a possible ring
	var/list/possible_ring_type_name = list(SKYBOX_PLANET_RING_TYPE_SPARSE, SKYBOX_PLANET_RING_TYPE_DENSE)

	///Possible colors for rock walls and rocks in general on this planet (Honestly, should be handled via materal system maybe?)
	var/list/possible_rock_colors = list(COLOR_ASTEROID_ROCK)

	///A list of gas and their proportion to enforce on this planet when generating the atmosphere.
	///If a level's get_mandatory_gases() returns gases, they will be added to this. If null is randomly generated.
	var/list/forced_atmosphere_gen_gases
	///Minimum amount of different atmospheric gases that may be generated for this planet, not counting the forced gases
	var/atmospheric_gen_gases_min = 1
	///Maximum amount of different atmospheric gases that may be generated for this planet, not counting the forced gases
	var/atmospheric_gen_gases_max = 4
	///Minimum possible base temperature range to pick from, in kelvins, when generating the atmosphere on this planet.
	var/atmosphere_gen_temperature_min = TCMB
	///Maximum possible base temperature range to pick from, in kelvins, when generating the atmosphere on this planet.
	var/atmosphere_gen_temperature_max = T100C
	///Minimum atmospheric pressure in the range to pick from for this planet template.
	var/atmosphere_gen_pressure_min = 0.5 ATM
	///Maximum atmospheric pressure in the range to pick from for this planet template.
	var/atmosphere_gen_pressure_max = 2 ATM

	///Planet ambient lighting minimum possible value from 0 to 1. This value may be overridden in individual /datum/level_data.
	var/surface_light_gen_level_min = 0.45
	///Planet ambient lighting maximum possible value from 0 to 1. This value may be overridden in individual /datum/level_data.
	var/surface_light_gen_level_max = 0.75

	///Possible list of colors to pick for the ambient lighting color. Null means a random color will be generated.
	///This value may be overridden by individual /datum/level_data.
	var/list/possible_surface_light_gen_colors

/datum/planetoid_data/random/setup_planetoid()
	//Generate random stuff first
	pregenerate()
	. = ..()

///Pre-generate the random planetoid's data before it has any actual level or overmap marker tied to it.
/datum/planetoid_data/random/proc/pregenerate()
	make_planet_name()
	generate_habitability()
	generate_atmosphere()
	generate_planet_materials()
	generate_planetoid_rings()
	generate_ambient_lighting()
	generate_daycycle_data()
	generate_weather()

/datum/planetoid_data/random/proc/generate_daycycle_data()
	starts_at_night = (surface_light_level > 0.1)
	day_duration    = rand(global.config.exoplanet_min_day_duration, global.config.exoplanet_max_day_duration)

///If the planet doesn't have a name defined, a name will be randomly generated for it. (Named this way because a global proc generate_planet_name already exists)
/datum/planetoid_data/random/proc/make_planet_name()
	if(length(name))
		return
	SetName(global.generate_planet_name())

/datum/planetoid_data/random/proc/generate_planetoid_rings()
	if(!prob(ring_gen_probability) || !length(possible_ring_type_name))
		return
	has_rings      = TRUE
	ring_color     = length(possible_ring_color)? pick(possible_ring_color) : COLOR_OFF_WHITE
	ring_type_name = pick(possible_ring_type_name)

///Generate the planet's minable resources, material for rocks and etc.
/datum/planetoid_data/random/proc/generate_planet_materials()
	select_strata()
	if(islist(possible_rock_colors) && length(possible_rock_colors))
		rock_color = pick(possible_rock_colors)
	else if(possible_rock_colors)
		rock_color = possible_rock_colors

///Selects the base strata for the whole planet. The levels have the final say however in what to do with that.
/datum/planetoid_data/random/proc/select_strata()
	if(isnull(strata))
		//No stratas, so pick one
		var/list/all_strata      = decls_repository.get_decls_of_subtype(/decl/strata)
		var/list/possible_strata = list()

		for(var/stype in all_strata)
			var/decl/strata/strata = all_strata[stype]
			if(strata.is_valid_exoplanet_strata(src))
				possible_strata += stype

		if(length(possible_strata))
			. = pick(possible_strata)
	else
		//If we have one defined, or have an instance alreaddy, just go with it
		if(ispath(strata))
			. = GET_DECL(strata)
		else
			. = strata
	set_strata(.)

///Pick an hability class for this planet. Should be done as early as possible during generation.
/datum/planetoid_data/random/proc/generate_habitability()
	if(isnull(habitability_class))
		if(prob(10))
			. = HABITABILITY_IDEAL
		else if(prob(30))
			. = HABITABILITY_OKAY
		else if(prob(40))
			. = HABITABILITY_BAD
		else
			. = HABITABILITY_DEAD
	else
		. = habitability_class
	set_habitability(.)

///Go through all materials and pick those that we could pick from on this planet
/datum/planetoid_data/random/proc/pick_atmospheric_gases_candidates(var/atmos_temperature, var/atmos_pressure, var/blacklisted_flags, var/list/blacklisted_gases)
	var/list/candidates    = list()
	var/list/all_materials = decls_repository.get_decls_of_subtype(/decl/material) - blacklisted_gases

	//Filter and list gases paths with their exoplanet rarity
	for(var/mat_type in all_materials)
		var/decl/material/mat = all_materials[mat_type]
		//Check if this material is allowed
		if((mat.gas_flags & blacklisted_flags) || (mat.exoplanet_rarity_gas == MAT_RARITY_NOWHERE))
			continue
		// No gaseous ice.
		// Maybe consider adding heating products instead, but it'd have to change how this loop is done.
		// Also that'd result in a ton of water vapor when really we'd only be interested in the volatiles...
		if(!isnull(mat.heating_point) && length(mat.heating_products) && atmos_temperature >= mat.heating_point)
			continue
		if(!isnull(mat.chilling_point) && length(mat.chilling_products) && atmos_temperature <= mat.chilling_point)
			continue
		//Check if this gas can exist in the atmosphere
		// For now, we skip materials above their ignition point entirely.
		// However, it's also checked in generate_atmosphere and applies the fuel flag,
		// so if including them is ever desirable it'll be handled properly.
		if(!isnull(mat.ignition_point) && atmos_temperature >= mat.ignition_point)
			continue
		var/will_condensate = !isnull(mat.gas_condensation_point) && (atmos_temperature <= mat.gas_condensation_point)
		switch(mat.phase_at_temperature(atmos_temperature, atmos_pressure))
			if(MAT_PHASE_LIQUID)
				if(will_condensate)
					continue //A liquid below dew point cannot be in the atmosphere
				//Otherwise allow liquids if they may exist as vapor
			if(MAT_PHASE_SOLID, MAT_PHASE_PLASMA)
				continue //In any other cases if we're not a gas skip
		candidates[mat.type] = mat.exoplanet_rarity_gas

	if(prob(50)) //alium gas should be slightly less common than mundane shit
		candidates -= /decl/material/gas/alien

	return candidates

///Generates a valid surface temperature for the planet's atmosphere matching its habitability class
/datum/planetoid_data/random/proc/generate_surface_temperature()
	. = rand(atmosphere_gen_temperature_min, atmosphere_gen_temperature_max)

	//Adjust for species habitability
	if(habitability_class == HABITABILITY_OKAY || habitability_class == HABITABILITY_IDEAL)
		var/decl/species/S  = global.get_species_by_key(global.using_map.default_species)
		if(habitability_class == HABITABILITY_IDEAL)
			. = clamp(., S.cold_discomfort_level + rand(1,5), S.heat_discomfort_level - rand(1,5)) //Clamp between comfortable levels since we're ideal
		else
			. = clamp(., S.cold_level_1 + 1, S.heat_level_1 - 1) //clamp between values species starts taking damages at

///Generates a valid surface pressure for the planet's atmosphere matching it's habitability class
/datum/planetoid_data/random/proc/generate_surface_pressure()
	. = rand(atmosphere_gen_pressure_min, atmosphere_gen_pressure_max)

	//Adjust for species habitability
	if(habitability_class == HABITABILITY_OKAY || habitability_class == HABITABILITY_IDEAL)
		var/decl/species/S           = global.get_species_by_key(global.using_map.default_species)
		var/breathed_min_pressure    = S.breath_pressure
		var/safe_max_pressure        = S.hazard_high_pressure
		var/safe_min_pressure        = S.hazard_low_pressure
		var/comfortable_max_pressure = S.warning_high_pressure
		var/comfortable_min_pressure = S.warning_low_pressure

		//On ideal planets, clamp against the comfortability limit pressures, since it shouldn't hit any extremes
		if(habitability_class == HABITABILITY_IDEAL)
			. = clamp(., comfortable_min_pressure, comfortable_max_pressure)
		//On okay planets, clamp against the safety limit pressures, so it's uncomfortable, but not harmful
		else
			. = clamp(., safe_min_pressure + 1, safe_max_pressure - 1) //Safety check inclusively compares against those values, so remove/add one from both

		//Ensure we at least have the minimum breathable pressure
		. = max(., breathed_min_pressure)

///Creates the atmosphere for the planet randomly or not.
/datum/planetoid_data/random/proc/generate_atmosphere()
	//Determine the temp, pressure, and mol count
	var/datum/gas_mixture/new_atmos = new
	var/target_temperature = generate_surface_temperature()
	var/target_pressure    = generate_surface_pressure()
	var/total_moles        = (target_pressure * CELL_VOLUME) / (target_temperature * R_IDEAL_GAS_EQUATION)
	var/available_moles    = total_moles
	new_atmos.temperature  = target_temperature

	//Forced gases get added in first
	var/forced_flag_check = 0
	for(var/gas_path in forced_atmosphere_gen_gases)
		var/decl/material/gas_mat = GET_DECL(gas_path)
		forced_flag_check |= gas_mat.gas_flags
		new_atmos.gas[gas_path] = forced_atmosphere_gen_gases[gas_path] * total_moles
		//Subtract any forced gases from the total available moles amount
		available_moles = max(0, available_moles - new_atmos.gas[gas_path])

	//Sanity warning so people don't accidently set a combustible mixture as forced atmos
	if((forced_flag_check & XGM_GAS_OXIDIZER) && (forced_flag_check & XGM_GAS_FUEL))
		log_warning("The list of forced gases user-defined for [src]'s atmoshpere contains both an oxidizer and a fuel!")

	//Make a list of gas flags to avoid
	var/blacklisted_flags = forced_flag_check & (XGM_GAS_OXIDIZER | XGM_GAS_FUEL) //Prevents combustible mixtures
	var/list/blacklisted_gases //list of gases that shouldn't be in the atmosphere

	//Habitable planets do not want any contaminants in the air
	if(habitability_class == HABITABILITY_OKAY || habitability_class == HABITABILITY_IDEAL)
		blacklisted_flags |= XGM_GAS_CONTAMINANT

		//Make sure temperature can't damage people on casual planets (Only when not forcing an atmosphere)
		var/decl/species/S = global.get_species_by_key(global.using_map.default_species)
		var/lower_temp            = max(S.cold_level_1, atmosphere_gen_temperature_min)
		var/higher_temp           = min(S.heat_level_1, atmosphere_gen_temperature_max)
		var/breathed_gas          = S.breath_type
		var/breathed_min_pressure = S.breath_pressure

		//Make sure we add all the poisons to the blacklist
		for(var/gas_path in S.poison_types)
			LAZYDISTINCTADD(blacklisted_gases, gas_path)

		//Adjust temperatures to be for the species
		new_atmos.temperature = clamp(new_atmos.temperature, lower_temp + rand(1,5), higher_temp - rand(1,5))

		//#TODO: Take into account if a species is aquatic?
		//Synths don't breath, so make sure we validate this here
		if(breathed_gas)
			//Calculate the minimum amount of moles of breathable gas needed by the default species
			new_atmos.gas[breathed_gas] = (breathed_min_pressure * CELL_VOLUME) / (new_atmos.temperature * R_IDEAL_GAS_EQUATION)

	//Pick the list of possible gases we can use in our random atmosphere, if we are set to generate any
	if(atmospheric_gen_gases_min > 0 && atmospheric_gen_gases_max > 0)
		var/list/candidate_gases = pick_atmospheric_gases_candidates(new_atmos.temperature, target_pressure, blacklisted_flags, blacklisted_gases)
		if(length(candidate_gases))
			//All the toggled flags of the gases we added this far. Used to avoid mixing dangerous gases.
			var/current_merged_flags = 0
			var/number_gases         = rand(atmospheric_gen_gases_min, atmospheric_gen_gases_max)
			var/i                    = 1

			while((i <= number_gases) && (available_moles > 0) && length(candidate_gases))
				var/picked_gas = pickweight(candidate_gases)	//pick a gas
				candidate_gases -= picked_gas

				// Make sure atmosphere is not flammable
				var/decl/material/mat = GET_DECL(picked_gas)
				if(((current_merged_flags & XGM_GAS_OXIDIZER) && (mat.gas_flags & XGM_GAS_FUEL)) || \
					((current_merged_flags & XGM_GAS_FUEL) && (mat.gas_flags & XGM_GAS_OXIDIZER)))
					continue
				
				// If we have an ignition point we're basically XGM_GAS_FUEL, kind of. TODO: Combine those somehow?
				// These don't actually burn but it's still weird to see vaporized skin gas in an oxygen-rich atmosphere,
				// so skip them.
				if(!isnull(mat.ignition_point) && new_atmos.temperature >= mat.ignition_point)
					if(current_merged_flags & XGM_GAS_OXIDIZER)
						continue
					current_merged_flags |= XGM_GAS_FUEL

				current_merged_flags |= mat.gas_flags
				var/min_percent = 10
				var/max_percent = 90
				switch(mat.exoplanet_rarity_gas)
					if(MAT_RARITY_UNCOMMON)
						min_percent = 5
						max_percent = 60
					if(MAT_RARITY_EXOTIC)
						min_percent = 1
						max_percent = 10
				var/part = available_moles * (rand(min_percent, max_percent)/100) //allocate percentage to it
				if(i == number_gases || !length(candidate_gases)) //if it's last gas, let it have all remaining moles
					part = available_moles
				new_atmos.gas[picked_gas] += part
				available_moles = max(available_moles - part, 0)
				i++

	new_atmos.update_values()
	set_atmosphere(new_atmos)

///Calculate the color and intensity of the ambient starlight that this planet receives.
/datum/planetoid_data/random/proc/generate_ambient_lighting()
	//Try to generate a surface light intensity if we don't have it yet
	if(!surface_light_level)
		surface_light_level = generate_surface_light_level()

	//Try to generate surface light color if we don't have any yet
	if(!surface_light_color)
		surface_light_color = generate_surface_light_color()

///Calculate the ambient lighting intensity for the planet.
/datum/planetoid_data/random/proc/generate_surface_light_level()
	if((surface_light_gen_level_min >= 0) && (surface_light_gen_level_max > 0) && (min(surface_light_gen_level_max, 1) <= 1.0))
		//We got a range of random values to generate the lighting level from, so use that
		return rand(surface_light_gen_level_min * 100, surface_light_gen_level_max * 100) / 100 //rand() doesn't work on decimal numbers
	else
		return 0.9

/datum/planetoid_data/random/proc/generate_surface_light_color()
	if(length(possible_surface_light_gen_colors))
		//If we have colors to pick from, go for it
		return pick(possible_surface_light_gen_colors)
	else
		//Otherwise generate it randomly
		var/atmos_color = atmosphere?.get_overall_color() || get_random_colour()
		var/list/HSV    = rgb2num(atmos_color, COLORSPACE_HSV)
		var/sat_factor  = rand(50, 80) / 100 //Make the color less saturated to around 50% to 80%
		var/val_factor  = 1 + (rand(10, 50) / 100) //Make the color brighter within a factor of 10%-50%
		//Scale and clamp to sane-ish values for lighting
		return hsv(HSV[1], clamp(round(HSV[2] * sat_factor), 40, 80), clamp(round(HSV[3] * val_factor), 60, 90), 200)

