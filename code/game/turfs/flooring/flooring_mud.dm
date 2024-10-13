/decl/flooring/mud
	name            = "mud"
	desc            = "A stretch of thick, waterlogged mud."
	icon            = 'icons/turf/flooring/mud.dmi'
	icon_base       = "mud"
	icon_edge_layer = FLOOR_EDGE_MUD
	footstep_type   = /decl/footsteps/mud
	turf_flags      = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	force_material  = /decl/material/solid/soil
	growth_value    = 1.1

/decl/flooring/mud/fire_act(turf/floor/target, datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!target.reagents?.total_volume)
		if(target.get_topmost_flooring() == src)
			target.set_flooring(/decl/flooring/dry_mud)
		else if(target.get_base_flooring() == src)
			target.set_base_flooring(/decl/flooring/dry_mud)
		return
	return ..()

/decl/flooring/dry_mud
	name            = "dry mud"
	desc            = "This was once mud, but forgot to keep hydrated."
	icon            = 'icons/turf/flooring/seafloor.dmi'
	icon_base       = "seafloor"
	icon_edge_layer = FLOOR_EDGE_MUD
	footstep_type   = /decl/footsteps/mud
	turf_flags      = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	color           = "#ae9e66"
	dirt_color      = "#ae9e66"
	force_material  = /decl/material/solid/soil

/decl/flooring/dry_mud/fluid_act(turf/floor/target, datum/reagents/fluids)
	if(target.get_topmost_flooring() == src)
		target.set_flooring(/decl/flooring/mud)
		. = TRUE
	if(target.get_base_flooring() == src)
		target.set_base_flooring(/decl/flooring/mud)
		. = TRUE
	return . || ..()

/decl/flooring/dirt
	name            = "dirt"
	desc            = "A flat expanse of dry, cracked earth."
	icon            = 'icons/turf/flooring/dirt.dmi'
	icon_base       = "dirt"
	icon_edge_layer = FLOOR_EDGE_DIRT
	color           = "#41311b"
	footstep_type   = /decl/footsteps/asteroid
	turf_flags      = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	force_material  = /decl/material/solid/soil
	growth_value    = 1

/decl/flooring/dirt/fluid_act(turf/floor/target, datum/reagents/fluids)
	if(target.get_topmost_flooring() == src)
		target.set_flooring(/decl/flooring/mud)
		. = TRUE
	if(target.get_base_flooring() == src)
		target.set_base_flooring(/decl/flooring/mud)
		. = TRUE
	return . || ..()
