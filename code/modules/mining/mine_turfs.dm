/turf/unsimulated/mineral
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"
	blocks_air = 1
	density = TRUE
	opacity = TRUE
	turf_flags = TURF_IS_HOLOMAP_OBSTACLE

/**********************Asteroid**************************/
// Setting icon/icon_state initially will use these values when the turf is built on/replaced.
// This means you can put grass on the asteroid etc.
/turf/simulated/floor/asteroid
	name = "sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	base_name = "sand"
	base_desc = "Gritty and unpleasant."
	base_icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	footstep_type = /decl/footsteps/asteroid
	initial_flooring = null
	initial_gas = null
	temperature = TCMB
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH

	var/dug = 0       //0 = has not yet been dug, 1 = has already been dug //#TODO: This should probably be generalised?
	var/overlay_detail

/turf/simulated/floor/asteroid/Initialize()
	if(prob(20))
		overlay_detail = "asteroid[rand(0,9)]"
	. = ..()
	var/datum/level_data/mining_level/level = SSmapping.levels_by_z[z]
	if(istype(level))
		LAZYADD(level.mining_turfs, src)

/turf/simulated/floor/asteroid/Destroy()
	var/datum/level_data/mining_level/level = SSmapping.levels_by_z[z]
	if(istype(level))
		LAZYREMOVE(level.mining_turfs, src)
	return ..()

/turf/simulated/floor/asteroid/can_be_dug()
	return !density

/turf/simulated/floor/asteroid/is_plating()
	return !density

/turf/simulated/floor/asteroid/on_update_icon()
	..()
	if(dug)
		icon_state = "asteroid_dug"

/turf/simulated/floor/asteroid/clear_diggable_resources()
	dug = TRUE
	..()

/turf/simulated/floor/asteroid/get_diggable_resources()
	return dug ? null : list(/obj/item/stack/material/ore/sand = list(3, 2))

//#TODO: This should probably be generalised?
/turf/simulated/floor/asteroid/proc/updateMineralOverlays(var/update_neighbors)

	overlays.Cut()

	var/list/step_overlays = list("n" = NORTH, "s" = SOUTH, "e" = EAST, "w" = WEST)
	for(var/direction in step_overlays)

		if(isspaceturf(get_step(src, step_overlays[direction])))
			var/image/aster_edge = image('icons/turf/flooring/asteroid.dmi', "asteroid_edges", dir = step_overlays[direction])
			aster_edge.layer = DECAL_LAYER
			overlays += aster_edge

	if(overlay_detail)
		var/image/floor_decal = image(icon = 'icons/turf/flooring/decals.dmi', icon_state = overlay_detail)
		floor_decal.layer = DECAL_LAYER
		overlays |= floor_decal

	if(update_neighbors)
		var/list/all_step_directions = list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST)
		for(var/direction in all_step_directions)
			var/turf/simulated/floor/asteroid/A
			if(istype(get_step(src, direction), /turf/simulated/floor/asteroid))
				A = get_step(src, direction)
				A.updateMineralOverlays()
