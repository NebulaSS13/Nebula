/datum/exoplanet_theme/radiation_bombing
	name = "Radiation Bombardment"

/datum/exoplanet_theme/radiation_bombing/adjust_atmosphere(datum/planetoid_data/E)
	var/add_temp = rand(20, 100)
	if(E.atmosphere)
		E.atmosphere.temperature += add_temp
		E.atmosphere.update_values()

/datum/exoplanet_theme/radiation_bombing/get_sensor_data()
	return "Hotspots of radiation detected."

/datum/exoplanet_theme/radiation_bombing/after_map_generation(datum/planetoid_data/E)
	var/datum/level_data/LD = SSmapping.levels_by_id[E.surface_level_id]
	var/radiation_power = rand(10, 37.5)
	var/num_craters = round(min(0.5, rand()) * 0.02 * LD.level_inner_width * LD.level_inner_height)

	//Grab all turfs that are within the level's borders
	var/list/available_turfs = block(locate(LD.level_inner_min_x, LD.level_inner_min_y, LD.level_z), locate(LD.level_inner_max_x, LD.level_inner_max_y, LD.level_z))
	var/list/picked_turfs = list()

	//Manually filter out turfs
	for(var/turf/T in available_turfs)
		if(!turf_contains_dense_objects(T) && (T.loc == E.surface_area))
			picked_turfs += T

	for(var/i = 1 to num_craters)
		var/turf/crater_center = pick_n_take(picked_turfs)
		if(!crater_center) // ran out of space somehow
			return
		new/obj/structure/rubble/war(crater_center)
		var/datum/radiation_source/source = new(crater_center, radiation_power, FALSE)
		source.range = 4
		SSradiation.add_source(source)
		crater_center.set_light(2, 0.4, PIPE_COLOR_GREEN)
		for(var/turf/exterior/crater in circlerangeturfs(crater_center, 3))
			if(prob(10))
				new/obj/item/remains/xeno/charred(crater)
			crater.melt()
			crater.update_icon()
