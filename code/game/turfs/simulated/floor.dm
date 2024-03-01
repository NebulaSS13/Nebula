/turf/simulated/floor
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	permit_ao = TRUE
	thermal_conductivity = 0.040
	heat_capacity = 10000
	explosion_resistance = 1
	turf_flags = TURF_IS_HOLOMAP_PATH

/turf/simulated/floor/can_climb_from_below(var/mob/climber)
	return TRUE

/turf/simulated/floor/is_plating()
	var/decl/flooring/flooring = get_flooring()
	return !flooring || istype(flooring, /decl/flooring/plating)

/turf/simulated/floor/get_base_movement_delay(var/travel_dir, var/mob/mover)
	return get_flooring()?.get_flooring_movement_delay(travel_dir, mover) || ..()

/turf/simulated/floor/protects_atom(var/atom/A)
	return (A.level <= LEVEL_BELOW_PLATING && !is_plating()) || ..()

/turf/simulated/floor/Initialize(var/ml, var/floortype)
	if(floortype)
		flooring_layers = floortype // this will be handled in parent calls
	. = ..(ml)
	if(!ml)
		RemoveLattice()

//This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating(var/place_product, var/defer_icon_update)

	LAZYCLEARLIST(decals)
	for(var/obj/effect/decal/writing/W in src)
		qdel(W)

	var/decl/flooring/flooring = get_plating_data()
	SetName(flooring.name)
	desc = flooring.desc
	if(icon != flooring.icon)
		icon = flooring.icon
	icon_state = flooring.icon_base
	color = flooring.color
	layer = PLATING_LAYER

	// Clear the flooring stack.
	if(flooring_layers)
		if(islist(flooring_layers))
			for(var/i = length(flooring_layers); i > 0; i--)
				flooring = flooring_layers[i]
				if(ispath(flooring))
					flooring = GET_DECL(flooring)
				flooring.on_remove(src, place_product)
		else
			flooring = flooring_layers
			if(ispath(flooring))
				flooring = GET_DECL(flooring)
			flooring.on_remove(src, place_product)
		flooring_layers = null

	icon_base = null

	set_light(0)
	set_turf_broken(null, skip_icon_update = TRUE)
	set_turf_burned(null, skip_icon_update = defer_icon_update)
	levelupdate()

	if(!defer_icon_update)
		update_icon(1)

/turf/simulated/floor/levelupdate()
	var/decl/flooring/flooring = get_flooring()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && flooring)
	if(flooring)
		layer = TURF_LAYER
	else
		layer = PLATING_LAYER

/turf/simulated/floor/can_engrave()
	var/decl/flooring/flooring = get_flooring()
	return (!flooring || flooring.can_engrave)

/turf/simulated/floor/shuttle_ceiling
	name = "hull plating"
	icon = 'icons/turf/flooring/static/shuttle_ceiling.dmi'
	icon_state = "reinforced_light"
	initial_gas = null

/turf/simulated/floor/shuttle_ceiling/air
	initial_gas = list(/decl/material/gas/oxygen = MOLES_O2STANDARD, /decl/material/gas/nitrogen = MOLES_N2STANDARD)

/turf/simulated/floor/is_floor()
	return TRUE

/turf/simulated/floor/is_defiled()
	return get_flooring()?.type == /decl/flooring/reinforced/cult || ..()
