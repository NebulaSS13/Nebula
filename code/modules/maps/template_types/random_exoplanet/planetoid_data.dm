//////////////////////////////////////////////////////////////////////
// Planetoid Data
//////////////////////////////////////////////////////////////////////
///Runtime data for a planetoid. Used by SSmapping for keeping track of a lot of data about planetoids
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
	///Topmost level data datum id (ID only, because this datum has an uncontrolled lifetime, and we don't want dangling refs)
	var/topmost_level_id
	///Level data id for the level that's considered to be the planet's surface.
	var/surface_level_id
	///A reference to the surface area of the planet. Don't set manually.
	var/area/surface_area
	///A cached list of connected level_ids loaded from child level_data.
	var/tmp/list/connected_level_ids //#TODO: handle caching the list, and use it!!!! Or use the overmap object's own map_z

	// *** Atmos ***
	///The habitability rating for this planetoid
	var/habitability_class = HABITABILITY_DEAD
	///The cached planet's atmosphere.
	var/datum/gas_mixture/atmosphere

	// *** Appearence ***
	///A weak reference to the overmap marker for this template instance if any exists.
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
	///The overall strata of the planet.
	var/decl/strata/strata

	// *** Generated Features ***
	///List of theme types that were randomly picked from the possible list at runtime. Also used by the overmap marker.
	var/list/themes
	///List of subtemplates types we picked and spawned on this planet.
	var/list/subtemplates

	// *** Xenorach ***
	///A xenoarch flavor text generator instance for this planet. Used for unique engravings and weird visions stuff.
	var/datum/xenoarch_engraving_flavor/engraving_generator

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

	///The flora generator instance that generates and keep track of the flora types for this planet.
	var/datum/flora_generator/flora
	///The instance of the fauna generator currently managing our fauna if any
	var/datum/fauna_generator/fauna //#TODO: Temporary thing for allowing animal stuff to be customized in the map_template

	// *** Special Overrides ***
	//#TODO: There is probably a way to handle options set from manually spawning planets that is less shitty?
	///Subtemplate budget override. If something overrode the map_template's base budget, this will be set. Otherwise, it'll stay null. (Used in manual exoplanet generation verb)
	var/tmp/_budget_override
	///Enforces a single theme. If something overrode the map template's base random themes list, this will be set. Otherwise it'll stay null. (Used in manual exoplanet generation verb)
	var/tmp/_theme_forced

/datum/planetoid_data/New(var/datum/map_template/planetoid/P)
	if(!length(id))
		id = "planetoid_[sequential_id(/datum/planetoid_data)]"

/datum/planetoid_data/Destroy(force)
	//shouldn't delete before end. Turfs refers to this
	end_processing()
	SSmapping.unregister_planetoid(src) //Clears refs to us, doesn't mess with the levels
	log_debug("Desroying planetoid data ([id], [name]): [log_info_line(src)]")
	. = ..()

// ** Bunch of overridables below **

/datum/planetoid_data/proc/SetName(var/newname)
	name = newname

/datum/planetoid_data/proc/set_habitability(var/habitability)
	habitability_class = habitability

/datum/planetoid_data/proc/set_atmosphere(var/datum/gas_mixture/A)
	atmosphere = A.Clone()

/datum/planetoid_data/proc/set_overmap_marker(var/obj/effect/overmap/visitable/sector/planetoid/P)
	overmap_marker = weakref(P)
	P.update_from_data(src)

/datum/planetoid_data/proc/set_strata(var/decl/strata/_strata)
	if(ispath(_strata, /decl/strata))
		_strata = GET_DECL(_strata)
	strata = _strata

/datum/planetoid_data/proc/set_engraving_generator(var/datum/xenoarch_engraving_flavor/X)
	engraving_generator = X

/datum/planetoid_data/proc/set_topmost_level(var/datum/level_data/LD)
	topmost_level_id = LD.level_id

/datum/planetoid_data/proc/set_surface_level(var/datum/level_data/LD)
	surface_level_id = LD.level_id
	if(LD.base_area)
		surface_area = LD.get_base_area_instance()

///Is there any live flora on this planetoid?
/datum/planetoid_data/proc/has_flora()
	return LAZYLEN(flora?.small_flora_types) > 0 || LAZYLEN(flora?.big_flora_types) > 0

///Is there any live fauna on this planetoid?
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

///Create the specified type of flora manager type for this planetoid
/datum/planetoid_data/proc/setup_flora_generator(var/generator_type)
	if(istype(flora))
		QDEL_NULL(flora)
	else
		flora = null
	return (flora = new generator_type())

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
	return fauna.rename_species(species_type, newname, force)

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
	if(flora)
		flora.generate_flora(atmosphere)
	if(fauna)
		fauna.generate_fauna(atmosphere, breathable_gas?.Copy(), toxic_gases?.Copy()) //Must be copies here #TODO: Fix this