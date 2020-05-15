/obj/effect/overmap/visitable/sector/exoplanet
	name = "exoplanet"
	icon = 'icons/obj/overmap64.dmi'
	bound_height = 64
	bound_width = 64
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

	var/list/rock_colors = list(COLOR_ASTEROID_ROCK)
	var/list/plant_colors = list("RANDOM")
	var/grass_color
	var/surface_color = COLOR_ASTEROID_ROCK
	var/water_color = "#436499"
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

/obj/effect/overmap/visitable/sector/exoplanet/Initialize(mapload, z_level)
	if(GLOB.using_map.use_overmap)
		forceMove(locate(1, 1, z_level))
	return ..()

/obj/effect/overmap/visitable/sector/exoplanet/proc/build_level(max_x, max_y)
	maxx = max_x ? max_x : world.maxx
	maxy = max_y ? max_y : world.maxy
	x_origin = TRANSITIONEDGE + 1
	y_origin = TRANSITIONEDGE + 1
	x_size = maxx - 2 * (TRANSITIONEDGE + 1)
	y_size = maxy - 2 * (TRANSITIONEDGE + 1)
	planetary_area = new planetary_area()
	var/themes_num = min(length(possible_themes), rand(1, max_themes))
	for(var/i = 1 to themes_num)
		var/datum/exoplanet_theme/T = pickweight(possible_themes)
		themes += new T
		possible_themes -= T
	name = "[generate_planet_name()], \a [name]"

	generate_habitability()
	generate_atmosphere()
	for(var/datum/exoplanet_theme/T in themes)
		T.adjust_atmosphere(src)
	generate_flora()
	generate_map()
	generate_features()
	for(var/datum/exoplanet_theme/T in themes)
		T.after_map_generation(src)
	generate_landing(2)
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

	handle_atmosphere()

	if(repopulating)
		handle_repopulation()

	if(daycycle)
		if(tick % round(daycycle / wait) == 0)
			night = !night
			daycolumn = 1
		if(daycolumn && tick % round(daycycle_column_delay / wait) == 0)
			update_daynight()

/obj/effect/overmap/visitable/sector/exoplanet/proc/update_daynight()
	var/light = 0.1
	if(!night)
		light = lightlevel
	for(var/turf/simulated/floor/exoplanet/T in block(locate(daycolumn,1,min(map_z)),locate(daycolumn,maxy,max(map_z))))
		T.set_light(light, 0.1, 2)
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
			T.ChangeTurf(/turf/simulated/planet_edge)
		for(var/map_type in map_generators)
			if(ispath(map_type, /datum/random_map/noise/exoplanet))
				new map_type(null,x_origin,y_origin,zlevel,x_size,y_size,0,1,1,planetary_area, plant_colors)
			else
				new map_type(null,x_origin,y_origin,zlevel,x_size,y_size,0,1,1,planetary_area)

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_features()
	for(var/T in subtypesof(/datum/map_template/ruin/exoplanet))
		var/datum/map_template/ruin/exoplanet/ruin = T
		if(ruin_tags_whitelist && !(ruin_tags_whitelist & initial(ruin.ruin_tags)))
			continue
		if(ruin_tags_blacklist & initial(ruin.ruin_tags))
			continue
		possible_features += new ruin
	spawned_features = seedRuins(map_z, features_budget, /area/exoplanet, possible_features, maxx, maxy)

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_daycycle()
	if(lightlevel)
		night = FALSE //we start with a day if we have light.

		//When you set daycycle ensure that the minimum is larger than [maxx * daycycle_column_delay].
		//Otherwise the right side of the exoplanet can get stuck in a forever day.
		daycycle = rand(10 MINUTES, 40 MINUTES)

//Tries to generate num landmarks, but avoids repeats.
/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_landing(num = 1)
	var/places = list()
	var/attempts = 10*num
	var/new_type = /obj/effect/shuttle_landmark/automatic
	while(num)
		attempts--
		var/turf/T = locate(rand(20, maxx-20), rand(20, maxy - 10),map_z[map_z.len])
		if(!T || (T in places)) // Two landmarks on one turf is forbidden as the landmark code doesn't work with it.
			continue
		if(attempts >= 0) // While we have the patience, try to find better spawn points. If out of patience, put them down wherever, so long as there are no repeats.
			var/valid = 1
			var/list/block_to_check = block(locate(T.x - 10, T.y - 10, T.z), locate(T.x + 10, T.y + 10, T.z))
			for(var/turf/check in block_to_check)
				if(!istype(get_area(check), /area/exoplanet) || check.turf_flags & TURF_FLAG_NORUINS)
					valid = 0
					break
			if(attempts >= 10)
				if(check_collision(T.loc, block_to_check)) //While we have lots of patience, ensure landability
					valid = 0
			else //Running out of patience, but would rather not clear ruins, so switch to clearing landmarks and bypass landability check
				new_type = /obj/effect/shuttle_landmark/automatic/clearing

			if(!valid)
				continue

		num--
		places += T
		new new_type(T)

/obj/effect/overmap/visitable/sector/exoplanet/get_scan_data(mob/user)
	. = ..()
	var/list/extra_data = list("<br>")
	if(atmosphere)
		if(user.skill_check(SKILL_SCIENCE, SKILL_EXPERT) || user.skill_check(SKILL_ATMOS, SKILL_EXPERT))
			var/list/gases = list()
			for(var/g in atmosphere.gas)
				if(atmosphere.gas[g] > atmosphere.total_moles * 0.05)
					var/material/mat = SSmaterials.get_material_datum(g)
					gases += mat.display_name
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
		for(var/datum/map_template/ruin/exoplanet/R in spawned_features)
			if(!(R.ruin_tags & RUIN_NATURAL))
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
