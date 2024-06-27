///Base level data for levels that are subordinated to a /datum/planetoid_data entry.
///A bunch of things are fetched from planet gen to stay in sync.
/datum/level_data/planetoid
	level_flags                  = (ZLEVEL_PLAYER|ZLEVEL_SEALED)
	border_filler                = /turf/unsimulated/mineral
	loop_turf_type               = /turf/mimic_edge/transition/loop
	transition_turf_type         = /turf/mimic_edge/transition
	use_global_exterior_ambience = FALSE
	forbid_strata                = null

	///The planetoid_data datum owning this level. At definition can be set to the planetoid_id of the planetoid to link up with on creation.
	///Ideally this will eventually be the main reference for the z-level to the planet level contents are located on. So we don't need to link every single turfs to it.
	var/datum/planetoid_data/parent_planetoid

///Level data for generating surface levels on exoplanets
/datum/level_data/planetoid/exoplanet
	base_area = /area/exoplanet
	base_turf = /turf/floor/natural/dirt
	daycycle_id = null // will be generated
	daycycle_type = /datum/daycycle/exoplanet

///Level data for generating underground levels on exoplanets
/datum/level_data/planetoid/exoplanet/underground
	base_area = /area/exoplanet/underground
	base_turf = /turf/floor/natural/rock
	level_generators = list(
		/datum/random_map/noise/exoplanet/mantle,
		/datum/random_map/automata/cave_system/mantle,
	)

/datum/level_data/planetoid/setup_level_data(skip_gen)
	//setup level may be run post level gen, or as soon as the level_data is constructed.
	if(istext(parent_planetoid))
		set_planetoid(parent_planetoid)
	. = ..()

/datum/level_data/planetoid/copy_from(datum/level_data/planetoid/old_level)
	//Make sure we pass over the planetoid_data that's been assigned to our turfs for coherency's sake
	if(istype(old_level) && old_level.parent_planetoid)
		set_planetoid(old_level.parent_planetoid)

/datum/level_data/planetoid/initialize_level_id()
	if(level_id)
		return
	level_id = "planetoid_[level_z]_[sequential_id(/datum/level_data)]"

/datum/level_data/planetoid/setup_strata()
	//If no fixed strata, grab the one from the owning planetoid_data if we have any
	if(!strata)
		strata = parent_planetoid?.get_strata()
	. = ..()

///Make sure the planetoid we belong to knows about us and that we know about them.
/// * P: The planetoid data datum, or the planetoid id string of the planet.
/datum/level_data/planetoid/proc/set_planetoid(var/datum/planetoid_data/P)
	if(istext(P))
		P = SSmapping.planetoid_data_by_id[P]
	if(istype(P))
		parent_planetoid = P
		SSmapping.register_planetoid_levels(level_z, P)
	if(!parent_planetoid)
		CRASH("Failed to set planetoid data for level '[level_id]', z:[level_z]")

	//If the planetoid_data has some pre-defined level id for top and surface levels, be sure to let it know we exist.
	if(parent_planetoid.topmost_level_id == level_id)
		parent_planetoid.set_topmost_level(src)
	if(parent_planetoid.surface_level_id == level_id)
		parent_planetoid.set_surface_level(src)

	//Apply parent's prefered bounds if we don't have any preferences
	if(!level_max_width && parent_planetoid.width)
		level_max_width = parent_planetoid.width
	if(!level_max_height && parent_planetoid.height)
		level_max_height = parent_planetoid.height

	//Refresh bounds
	setup_level_bounds()
	//override atmosphere
	apply_planet_atmosphere(parent_planetoid)
	//Try to adopt our parent planet's ambient lighting preferences
	apply_planet_ambient_lighting(parent_planetoid)
	//Rename the surface area if we have one yet
	adapt_location_name(parent_planetoid.name)

///If we're getting atmos from our parent planet, decide if we're going to apply it, or ignore it
/datum/level_data/planetoid/proc/apply_planet_atmosphere(var/datum/planetoid_data/P)
	if(istype(exterior_atmosphere))
		return //level atmos takes priority over planet atmos
	exterior_atmosphere = P.atmosphere.Clone() //Make sure we get one instance per level

///Apply our parent planet's ambient lighting settings if we want to.
/datum/level_data/planetoid/proc/apply_planet_ambient_lighting(var/datum/planetoid_data/P)
	if(!ambient_light_level)
		ambient_light_level = P.surface_light_level
	if(!ambient_light_color)
		ambient_light_level = P.surface_light_color

/datum/level_data/planetoid/adapt_location_name(location_name)
	if(!(. = ..()))
		return
	if(!ispath(base_area) || ispath(base_area, world.area))
		return
	var/area/A = get_base_area_instance()
	//Make sure we're not going to rename the world's base area
	if(!istype(A, world.area))
		global.using_map.area_purity_test_exempt_areas |= A.type //Make sure we add any of those, so unit tests calm down when we rename
		A.SetName("[location_name]")
