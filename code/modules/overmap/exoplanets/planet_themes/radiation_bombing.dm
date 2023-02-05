/datum/exoplanet_theme/radiation_bombing
	name = "Radiation Bombardment"

/datum/exoplanet_theme/radiation_bombing/adjust_atmosphere(obj/effect/overmap/visitable/sector/exoplanet/E)
	var/add_temp = rand(20, 100)
	for(var/obj/abstract/level_data/level_data in E.zlevels)
		level_data.exterior_atmos_temp += add_temp
		if(level_data.exterior_atmosphere)
			level_data.exterior_atmosphere.temperature = level_data.exterior_atmos_temp
			level_data.exterior_atmosphere.update_values()

/datum/exoplanet_theme/radiation_bombing/get_sensor_data()
	return "Hotspots of radiation detected."

/datum/exoplanet_theme/radiation_bombing/after_map_generation(obj/effect/overmap/visitable/sector/exoplanet/our_exoplanet)
	var/radiation_power = rand(10, 37.5)
	var/num_craters = round(min(0.5, rand()) * 0.02 * our_exoplanet.maxx * our_exoplanet.maxy)
	var/area_turfs = get_area_turfs(our_exoplanet.planetary_area, list(/proc/not_turf_contains_dense_objects))
	for(var/i = 1 to num_craters)
		var/turf/simulated/crater_center = pick_n_take(area_turfs)
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
