var/global/list/fluid_overlay_pool = list()

/atom/movable/fluid_overlay
	name = ""
	icon = 'icons/effects/liquids.dmi'
	icon_state = ""
	anchored = 1
	simulated = 0
	opacity = 0
	mouse_opacity = 0
	layer = FLY_LAYER
	alpha = 0
	color = COLOR_LIQUID_WATER
	var/update_lighting = FALSE

/atom/movable/fluid_overlay/on_update_icon()

	cut_overlays()
	var/datum/reagents/local_fluids = loc?.reagents
	if(!local_fluids?.total_volume)
		return

	if(local_fluids.total_volume > FLUID_OVER_MOB_HEAD)
		layer = DEEP_FLUID_LAYER
	else
		layer = SHALLOW_FLUID_LAYER

	color = local_fluids.get_color()

	var/decl/material/main_reagent = local_fluids.get_primary_reagent_decl()
	if(main_reagent) // TODO: weighted alpha from all reagents, not just primary
		alpha = Clamp(CEILING(255*(local_fluids.total_volume/FLUID_DEEP)) * main_reagent.opacity, main_reagent.min_fluid_opacity, main_reagent.max_fluid_opacity)

	if(local_fluids.total_volume <= FLUID_PUDDLE)
		APPLY_FLUID_OVERLAY("puddle")
	else if(local_fluids.total_volume <= FLUID_SHALLOW)
		APPLY_FLUID_OVERLAY("shallow_still")
	else if(local_fluids.total_volume < FLUID_DEEP)
		APPLY_FLUID_OVERLAY("mid_still")
	else if(local_fluids.total_volume < (FLUID_DEEP*2))
		APPLY_FLUID_OVERLAY("deep_still")
	else
		APPLY_FLUID_OVERLAY("ocean")

	if(update_lighting)
		update_lighting = FALSE
		for(var/rtype in local_fluids.reagent_volumes)
			var/decl/material/reagent = GET_DECL(rtype)
			if(REAGENT_VOLUME(reagents, rtype) >= 3 && reagent.radioactivity)
				set_light(1, 0.2, COLOR_GREEN)
				return
		set_light(0)

// Map helper.
/obj/effect/fluid_mapped
	name = "mapped flooded area"
	alpha = 125
	icon_state = "shallow_still"
	color = COLOR_LIQUID_WATER

	var/fluid_type = /decl/material/liquid/water
	var/fluid_initial = FLUID_MAX_DEPTH

/obj/effect/fluid_mapped/Initialize()
	..()
	var/turf/T = get_turf(src)
	if(istype(T))
		var/datum/reagents/local_fluids = T.return_fluids(create_if_missing = TRUE)
		local_fluids.add_reagent(fluid_type, fluid_initial)
	return INITIALIZE_HINT_QDEL

/obj/effect/fluid_mapped/fuel
	name = "spilled fuel"
	fluid_type = /decl/material/liquid/fuel
	fluid_initial = 10

// Permaflood overlay.
var/global/obj/abstract/flood/flood_object = new
/obj/abstract/flood
	layer = DEEP_FLUID_LAYER
	color = COLOR_LIQUID_WATER
	icon = 'icons/effects/liquids.dmi'
	icon_state = "ocean"
	alpha = FLUID_MAX_ALPHA
