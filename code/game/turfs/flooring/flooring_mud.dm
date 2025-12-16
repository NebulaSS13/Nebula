/decl/flooring/mud
	name            = "mud"
	desc            = "A stretch of thick, waterlogged mud."
	icon            = 'icons/turf/flooring/mud.dmi'
	icon_base       = "mud"
	color           = null // autoset from material
	icon_edge_layer = FLOOR_EDGE_MUD
	footstep_type   = /decl/footsteps/mud
	turf_flags      = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	force_material  = /decl/material/solid/soil
	growth_value    = 1.1
	can_collect     = TRUE
	print_type      = /obj/effect/footprints
	uid             = "floor_mud"

/decl/flooring/mud/fire_act(turf/floor/target, datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!REAGENT_TOTAL_VOLUME(target.reagents))
		if(target.get_topmost_flooring() == src)
			target.set_flooring(/decl/flooring/dry_mud)
		else if(target.get_base_flooring() == src)
			target.set_base_flooring(/decl/flooring/dry_mud)
		return
	return ..()

/decl/flooring/mud/turf_crossed(atom/movable/crosser)
	if(!isliving(crosser))
		return
	var/mob/living/walker = crosser
	walker.add_walking_contaminant(force_material.type, rand(2,3))

/decl/flooring/mud/can_show_coating_footprints(turf/target, decl/material/contaminant)
	if(force_material == contaminant) // So we don't end up covered in a million footsteps that we provided.
		return FALSE
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
	uid             = "floor_dry_mud"

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
	color           = null // autoset from material
	footstep_type   = /decl/footsteps/asteroid
	turf_flags      = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	force_material  = /decl/material/solid/soil
	growth_value    = 1
	uid             = "floor_dirt"

/decl/flooring/dirt/fluid_act(turf/floor/target, datum/reagents/fluids)
	if(target.get_topmost_flooring() == src)
		target.set_flooring(/decl/flooring/mud)
		. = TRUE
	if(target.get_base_flooring() == src)
		target.set_base_flooring(/decl/flooring/mud)
		. = TRUE
	return . || ..()
