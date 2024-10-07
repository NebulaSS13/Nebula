/turf/floor/explosion_act(severity)
	SHOULD_CALL_PARENT(TRUE)
	..()
	if(severity == 1)
		ChangeTurf(get_base_turf_by_area(src), keep_air = TRUE)
	else if(severity == 2)
		switch(pick(40;1,40;2,3))
			if (1)
				if(prob(33))
					var/decl/material/mat = GET_DECL(/decl/material/solid/metal/steel)
					mat.place_shards(src)
				physically_destroyed()
			if(2)
				ChangeTurf(get_base_turf_by_area(src), keep_air = TRUE)
			if(3)
				if(prob(33))
					var/decl/material/mat = GET_DECL(/decl/material/solid/metal/steel)
					mat.place_shards(src)
				if(prob(80))
					break_tile_to_plating()
				else
					break_tile()
				hotspot_expose(1000,CELL_VOLUME)
	else if(severity == 3 && prob(50))
		break_tile()
		hotspot_expose(1000,CELL_VOLUME)

/turf/floor/fluid_act(var/datum/reagents/fluids)
	. = ..()
	if(!QDELETED(fluids) && fluids.total_volume)
		if(istype(flooring) && flooring.fluid_act(src, fluids))
			return
		if(istype(base_flooring) && base_flooring.fluid_act(src, fluids))
			return

/turf/floor/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)

	if(istype(flooring) && flooring.fire_act(src, air, exposed_temperature, exposed_volume))
		return

	if(istype(base_flooring) && base_flooring.fire_act(src, air, exposed_temperature, exposed_volume))
		return

	var/temp_destroy = get_damage_temperature()
	if(!is_floor_burned() && prob(5))
		burn_tile(exposed_temperature)
	else if(temp_destroy && exposed_temperature >= (temp_destroy + 100) && prob(1) && !is_plating())
		set_flooring(null) //destroy the tile, exposing plating
		burn_tile(exposed_temperature)
	return ..()

//should be a little bit lower than the temperature required to destroy the material
/turf/floor/proc/get_damage_temperature()
	if(istype(flooring))
		return flooring.damage_temperature

/turf/floor/adjacent_fire_act(turf/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	var/dir_to = get_dir(src, adj_turf)

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.is_fulltile()) //Same direction or diagonal (full tile)
			W.fire_act(adj_air, adj_temp, adj_volume)
