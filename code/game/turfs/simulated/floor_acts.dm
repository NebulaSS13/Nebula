/turf/simulated/floor/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if(severity == 1)
		ChangeTurf(get_base_turf_by_area(src))
	else if(severity == 2)
		switch(pick(40;1,40;2,3))
			if (1)
				if(prob(33))
					var/decl/material/mat = GET_DECL(/decl/material/solid/metal/steel)
					mat.place_shards(src)
				ReplaceWithLattice()
			if(2)
				ChangeTurf(get_base_turf_by_area(src))
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

/turf/simulated/floor/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)

	var/temp_destroy = get_damage_temperature()
	if(!burnt && prob(5))
		burn_tile(exposed_temperature)
	else if(temp_destroy && exposed_temperature >= (temp_destroy + 100) && prob(1) && !is_plating())
		make_plating() //destroy the tile, exposing plating
		burn_tile(exposed_temperature)
	return

//should be a little bit lower than the temperature required to destroy the material
/turf/simulated/floor/proc/get_damage_temperature()
	return flooring ? flooring.damage_temperature : null

/turf/simulated/floor/adjacent_fire_act(turf/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	var/dir_to = get_dir(src, adj_turf)

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.is_fulltile()) //Same direction or diagonal (full tile)
			W.fire_act(adj_air, adj_temp, adj_volume)
