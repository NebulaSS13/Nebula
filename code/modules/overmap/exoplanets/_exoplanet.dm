/obj/effect/overmap/visitable/sector/exoplanet
	name = "exoplanet"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "globe"
	sector_flags = OVERMAP_SECTOR_KNOWN
	free_landing = TRUE

	var/area/planetary_area

	var/lightlevel = 0 		//This default makes turfs not generate light. Adjust to have exoplanents be lit.
	var/night = TRUE
	var/daycycle 			//How often do we change day and night
	var/daycolumn = 0 		//Which column's light needs to be updated next?
	var/daycycle_column_delay = 10 SECONDS

	// maximum size dimensions, if less than world's dimensions, invisible walls will be spawned
	var/maxx
	var/maxy
	//realworld coordinates taking in account the fake world's edge
	var/x_origin
	var/y_origin
	var/x_size
	var/y_size

	var/landmark_type = /obj/effect/shuttle_landmark/automatic
	var/shuttle_size = 20  		 //'diameter' of expected shuttle in turfs
	var/landing_points_to_place  // number of landing points to place, calculated dynamically based on planet size

	var/list/rock_colors = list(COLOR_ASTEROID_ROCK)
	var/list/plant_colors = list("RANDOM")
	var/grass_color
	var/surface_color = COLOR_ASTEROID_ROCK
	var/water_color = "#436499"
	var/water_material = /decl/material/liquid/water
	var/ice_material =   /decl/material/solid/ice
	var/image/skybox_image

	var/list/actors = list() 	//things that appear in engravings on xenoarch finds.
	var/list/species = list() 	//list of names to use for simple animals instead of 'alien creature'

	var/datum/gas_mixture/atmosphere
	var/list/breathgas = list()			//list of gases animals/plants require to survive
	var/badgas							//id of gas that is toxic to life here

	var/repopulating = 0
	var/repopulate_types = list() 		// animals which have died that may come back
	var/list/fauna_types = list()		// possible types of mobs to spawn
	var/list/megafauna_types = list() 	// possibble types of megafauna to spawn
	var/list/animals = list()			// rerences to mobs 'born' on this planet
	var/max_animal_count

	var/flora_diversity = 4				// max number of different seeds growing here
	var/has_trees = TRUE				// if large flora should be generated
	var/list/small_flora_types = list()	// seeds of 'small' flora
	var/list/big_flora_types = list()	// seeds of tree-tier flora

	// themes are datums affecting various parameters of the planet and spawning their own maps
	var/max_themes = 2
	var/list/possible_themes = list(
		/datum/exoplanet_theme = 30,
		/datum/exoplanet_theme/mountains = 100,
		/datum/exoplanet_theme/radiation_bombing = 10,
		/datum/exoplanet_theme/ruined_city = 5,
		/datum/exoplanet_theme/robotic_guardians = 10
		)
	var/list/themes = list()	// themes that have been picked to be applied to this planet

	var/list/map_generators = list()

	//Flags deciding what features to pick
	var/ruin_tags_whitelist
	var/ruin_tags_blacklist
	var/features_budget = 4
	var/list/possible_features = list()
	var/list/spawned_features

	var/habitability_class	// if it's above bad, atmosphere will be adjusted to be better for humans (no extreme temps / oxygen to breathe)
	var/crust_strata // Decl type for exterior walls to use for material and ore gen.

	var/spawn_weight = 100	// Decides how often this planet will be picked for generation

	var/obj/abstract/weather_system/weather_system = /decl/state/weather/calm // Initial weather is passed to the system as its default state.

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_strata()
	return crust_strata

/obj/effect/overmap/visitable/sector/exoplanet/proc/select_strata()
	var/list/all_strata = decls_repository.get_decls_of_subtype(/decl/strata)
	var/list/possible_strata = list()
	for(var/stype in all_strata)
		var/decl/strata/strata = all_strata[stype]
		if(strata.is_valid_exoplanet_strata(src))
			possible_strata += stype
	if(length(possible_strata))
		crust_strata = pick(possible_strata)

/obj/effect/overmap/visitable/sector/exoplanet/Initialize(mapload, z_level)
	if(global.overmaps_by_name[overmap_id])
		forceMove(locate(1, 1, z_level))
	return ..()

/obj/effect/overmap/visitable/sector/exoplanet/proc/build_level(max_x, max_y)

	maxx = max_x ? max_x : world.maxx
	maxy = max_y ? max_y : world.maxy
	x_origin = TRANSITIONEDGE + 1
	y_origin = TRANSITIONEDGE + 1
	x_size = maxx - 2 * (TRANSITIONEDGE + 1)
	y_size = maxy - 2 * (TRANSITIONEDGE + 1)
	landing_points_to_place = min(round(0.1 * (x_size * y_size) / (shuttle_size * shuttle_size)), 3)

	var/planet_name = generate_planet_name()
	SetName("[planet_name], \a [name]")
	planetary_area = new planetary_area()
	global.using_map.area_purity_test_exempt_areas += planetary_area.type
	planetary_area.SetName("Surface of [planet_name]")

	var/themes_num = min(length(possible_themes), rand(1, max_themes))
	for(var/i = 1 to themes_num)
		var/datum/exoplanet_theme/T = pickweight(possible_themes)
		themes += new T
		possible_themes -= T

	if(ispath(weather_system, /decl/state/weather))
		weather_system = new /obj/abstract/weather_system(null, map_z[1], weather_system)
		weather_system.water_material = water_material
		weather_system.ice_material = ice_material

	generate_habitability()
	generate_atmosphere()
	for(var/datum/exoplanet_theme/T in themes)
		T.adjust_atmosphere(src)
	select_strata()
	generate_flora(atmosphere?.temperature || T20C)
	generate_map()
	generate_landing(2)
	generate_features()
	for(var/datum/exoplanet_theme/T in themes)
		T.after_map_generation(src)
	generate_daycycle()
	generate_planet_image()
	START_PROCESSING(SSobj, src)

//attempt at more consistent history generation for xenoarch finds.
/obj/effect/overmap/visitable/sector/exoplanet/proc/get_engravings()
	if(!actors.len)
		actors += pick("alien humanoid","an amorphic blob","a short, hairy being","a rodent-like creature","a robot","a primate","a reptilian alien","an unidentifiable object","a statue","a starship","unusual devices","a structure")
		actors += pick("alien humanoids","amorphic blobs","short, hairy beings","rodent-like creatures","robots","primates","reptilian aliens")

	var/engravings = "[actors[1]] \
	[pick("surrounded by","being held aloft by","being struck by","being examined by","communicating with")] \
	[actors[2]]"
	if(prob(50))
		engravings += ", [pick("they seem to be enjoying themselves","they seem extremely angry","they look pensive","they are making gestures of supplication","the scene is one of subtle horror","the scene conveys a sense of desperation","the scene is completely bizarre")]"
	engravings += "."
	return engravings

/obj/effect/overmap/visitable/sector/exoplanet/Process(wait, tick)

	if(animals.len < 0.5*max_animal_count && !repopulating)
		repopulating = 1
		max_animal_count = round(max_animal_count * 0.5)

	if(repopulating)
		handle_repopulation()

	if(daycycle)
		wait = max(1, wait)
		if(tick % round(daycycle / wait) == 0)
			night = !night
			daycolumn = 1
		if(daycolumn && (tick % round(daycycle_column_delay / wait)) == 0)
			update_daynight()

/obj/effect/overmap/visitable/sector/exoplanet/proc/update_daynight()
	var/light = 0.1
	if(!night)
		light = lightlevel
	for(var/turf/exterior/T in block(locate(daycolumn,1,min(map_z)),locate(daycolumn,maxy,max(map_z))))
		if (light)
			T.set_ambient_light(COLOR_WHITE, light)
		else
			T.clear_ambient_light()
	daycolumn++
	if(daycolumn > maxx)
		daycolumn = 0

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_map()
	var/list/grasscolors = plant_colors.Copy()
	grasscolors -= "RANDOM"
	if(length(grasscolors))
		grass_color = pick(grasscolors)

	for(var/datum/exoplanet_theme/T in themes)
		T.before_map_generation(src)
	for(var/zlevel in map_z)
		var/list/edges
		edges += block(locate(1, 1, zlevel), locate(TRANSITIONEDGE, maxy, zlevel))
		edges |= block(locate(maxx-TRANSITIONEDGE, 1, zlevel),locate(maxx, maxy, zlevel))
		edges |= block(locate(1, 1, zlevel), locate(maxx, TRANSITIONEDGE, zlevel))
		edges |= block(locate(1, maxy-TRANSITIONEDGE, zlevel),locate(maxx, maxy, zlevel))
		for(var/turf/T in edges)
			T.ChangeTurf(/turf/exterior/planet_edge)
		for(var/map_type in map_generators)
			if(ispath(map_type, /datum/random_map/noise/exoplanet))
				new map_type(x_origin, y_origin, zlevel, x_size, y_size, FALSE, TRUE, planetary_area, plant_colors)
			else
				new map_type(x_origin, y_origin, zlevel, x_size, y_size, FALSE, TRUE, planetary_area)

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_features()
	var/list/ruins = SSmapping.get_templates_by_category(MAP_TEMPLATE_CATEGORY_EXOPLANET)
	for(var/ruin_name in ruins)
		var/datum/map_template/ruin = ruins[ruin_name]
		var/ruin_tags = ruin.get_ruin_tags()
		if(ruin_tags_whitelist && !(ruin_tags_whitelist & ruin_tags))
			continue
		if(ruin_tags_blacklist & ruin_tags)
			continue
		possible_features += ruin
	spawned_features = seed_ruins(map_z, features_budget, /area/exoplanet, possible_features, maxx, maxy)

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_daycycle()
	if(lightlevel)
		night = FALSE //we start with a day if we have light.

		//When you set daycycle ensure that the minimum is larger than [maxx * daycycle_column_delay].
		//Otherwise the right side of the exoplanet can get stuck in a forever day.
		daycycle = rand(10 MINUTES, 40 MINUTES)

	// This was formerly done in Initialize, but that caused problems with ChangeTurf. The initialize logic is now
	// mapload-only, and so the exoplanet step (which uses ChangeTurf) has to be done here.
	for(var/target_z in map_z)
		for(var/turf/exterior/exterior_turf in block(
			locate(TRANSITIONEDGE, TRANSITIONEDGE, target_z),
			locate(world.maxx - TRANSITIONEDGE, world.maxy - TRANSITIONEDGE, target_z)
		))
			exterior_turf.setup_environmental_lighting()
			CHECK_TICK

//Tries to generate num landmarks, but avoids repeats.
/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_landing()
	var/places = list()
	var/attempts = 10*landing_points_to_place
	var/border_padding = shuttle_size / 2 + 3

	while(landing_points_to_place)
		attempts--
		var/turf/T = locate(rand(x_origin + border_padding, x_origin + x_size - border_padding), rand(y_origin + border_padding, y_origin + y_size - border_padding), map_z[1])

		if(!T || (T in places)) // Two landmarks on one turf is forbidden as the landmark code doesn't work with it.
			continue

		if(attempts >= 0) // While we have the patience, try to find better spawn points. If out of patience, put them down wherever, so long as there are no repeats.
			var/valid = 1
			var/list/block_to_check = block(locate(T.x - shuttle_size / 2, T.y - shuttle_size / 2, T.z), locate(T.x + shuttle_size / 2, T.y + shuttle_size / 2, T.z))
			for(var/turf/check in block_to_check)
				if(!istype(get_area(check), /area/exoplanet) || check.turf_flags & TURF_FLAG_NORUINS)
					valid = 0
					break
			if(attempts >= 10)
				if(check_collision(T.loc, block_to_check)) //While we have lots of patience, ensure landability
					valid = 0

			if(!valid)
				continue

		landing_points_to_place--
		places += T
		new /obj/effect/shuttle_landmark/automatic/clearing(T)

/obj/effect/overmap/visitable/sector/exoplanet/get_scan_data(mob/user)
	. = ..()
	var/list/extra_data = list("<br>")
	if(atmosphere)
		if(user.skill_check(SKILL_SCIENCE, SKILL_EXPERT) || user.skill_check(SKILL_ATMOS, SKILL_EXPERT))
			var/list/gases = list()
			for(var/g in atmosphere.gas)
				if(atmosphere.gas[g] > atmosphere.total_moles * 0.05)
					var/decl/material/mat = GET_DECL(g)
					gases += mat.gas_name
			extra_data += "Atmosphere composition: [english_list(gases)]"
			var/inaccuracy = rand(8,12)/10
			extra_data += "Atmosphere pressure [atmosphere.return_pressure()*inaccuracy] kPa, temperature [atmosphere.temperature*inaccuracy] K"
		else if(user.skill_check(SKILL_SCIENCE, SKILL_BASIC) || user.skill_check(SKILL_ATMOS, SKILL_BASIC))
			extra_data += "Atmosphere present"
		extra_data += "<br>"

	if(small_flora_types.len && user.skill_check(SKILL_SCIENCE, SKILL_BASIC))
		extra_data += "Xenoflora detected"

	if(animals.len && user.skill_check(SKILL_SCIENCE, SKILL_BASIC))
		extra_data += "Life traces detected"

	if(LAZYLEN(spawned_features) && user.skill_check(SKILL_SCIENCE, SKILL_ADEPT))
		var/ruin_num = 0
		for(var/datum/map_template/R in spawned_features)
			if(!(R.get_ruin_tags() & RUIN_NATURAL))
				ruin_num++
		if(ruin_num)
			extra_data += "<br>[ruin_num] possible artificial structure\s detected."

	for(var/datum/exoplanet_theme/T in themes)
		if(T.get_sensor_data())
			extra_data += T.get_sensor_data()
	. += jointext(extra_data, "<br>")

/area/exoplanet
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')
	always_unpowered = 1
	area_flags = AREA_FLAG_IS_BACKGROUND | AREA_FLAG_EXTERNAL
	show_starlight = TRUE
	is_outside = OUTSIDE_YES
