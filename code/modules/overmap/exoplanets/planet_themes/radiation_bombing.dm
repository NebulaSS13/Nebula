/datum/exoplanet_theme/radiation_bombing
	name = "Radiation Bombardment"

/datum/exoplanet_theme/radiation_bombing/adjust_atmosphere(obj/effect/overmap/visitable/sector/exoplanet/E)
	if(E.atmosphere)
		E.atmosphere.temperature += rand(20, 100)
		E.atmosphere.update_values()

/datum/exoplanet_theme/radiation_bombing/get_sensor_data()
	return "Hotspots of radiation detected."

/datum/exoplanet_theme/radiation_bombing/after_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	var/radiation_power = rand(10, 37.5)
	var/num_craters = round(min(0.5, rand()) * 0.02 * E.maxx * E.maxy)
	for(var/i = 1 to num_craters)
		var/turf/simulated/T = pick_area_turf(E.planetary_area, list(/proc/not_turf_contains_dense_objects))
		if(!T) // ran out of space somehow
			return
		new/obj/structure/rubble/war(T)
		var/datum/radiation_source/S = new(T, radiation_power, FALSE)
		S.range = 4
		SSradiation.add_source(S)
		T.set_light_new(2, 0.4, PIPE_COLOR_GREEN)
		for(var/turf/exterior/crater in circlerangeturfs(T, 3))
			if(prob(10))
				new/obj/item/remains/xeno/charred(crater)
			crater.melt()
			crater.update_icon()
