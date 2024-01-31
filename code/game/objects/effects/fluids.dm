/obj/effect/fluid_overlay
	name = ""
	icon = 'icons/effects/liquids.dmi'
	icon_state = "puddle"
	anchored = TRUE
	simulated = 0
	opacity = FALSE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	layer = FLY_LAYER
	alpha = 0
	color = COLOR_LIQUID_WATER
	var/update_lighting = FALSE

/obj/effect/fluid_overlay/Initialize()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	icon_state = ""
	. = ..()
	var/turf/simulated/T = get_turf(src)
	if(!isturf(T) || !T.CanFluidPass())
		return INITIALIZE_HINT_QDEL
	if(istype(T))
		T.unwet_floor(FALSE)

/obj/effect/fluid_overlay/airlock_crush()
	qdel(src)

/obj/effect/fluid_overlay/Move()
	PRINT_STACK_TRACE("A fluid overlay had Move() called!")
	return FALSE

/obj/effect/fluid_overlay/Destroy()
	var/turf/old_loc = get_turf(src)
	for(var/checkdir in global.cardinal)
		var/turf/neighbor = get_step(old_loc, checkdir)
		if(neighbor)
			ADD_ACTIVE_FLUID(neighbor)
	REMOVE_ACTIVE_FLUID(loc)
	SSfluids.pending_flows -= src
	. = ..()
	if(istype(old_loc) && old_loc.last_slipperiness > 0)
		old_loc.wet_floor(old_loc.last_slipperiness)

/obj/effect/fluid_overlay/on_update_icon()

	cut_overlays()
	var/datum/reagents/loc_reagents = loc?.reagents
	if(!loc_reagents)
		return

	if(loc_reagents.total_volume > FLUID_OVER_MOB_HEAD)
		layer = DEEP_FLUID_LAYER
	else
		layer = SHALLOW_FLUID_LAYER

	color = loc_reagents.get_color()

	if(!loc_reagents.total_volume)
		return

	var/decl/material/main_reagent = loc_reagents.get_primary_reagent_decl()
	if(main_reagent) // TODO: weighted alpha from all reagents, not just primary
		alpha = clamp(CEILING(255*(loc_reagents.total_volume/FLUID_DEEP)) * main_reagent.opacity, main_reagent.min_fluid_opacity, main_reagent.max_fluid_opacity)

	if(loc_reagents.total_volume <= FLUID_PUDDLE)
		APPLY_FLUID_OVERLAY("puddle")
	else if(loc_reagents.total_volume <= FLUID_SHALLOW)
		APPLY_FLUID_OVERLAY("shallow_still")
	else if(loc_reagents.total_volume < FLUID_DEEP)
		APPLY_FLUID_OVERLAY("mid_still")
	else if(loc_reagents.total_volume < (FLUID_DEEP*2))
		APPLY_FLUID_OVERLAY("deep_still")
	else
		APPLY_FLUID_OVERLAY("ocean")
	compile_overlays()

	if(update_lighting)
		update_lighting = FALSE
		var/glowing
		for(var/rtype in loc_reagents.reagent_volumes)
			var/decl/material/reagent = GET_DECL(rtype)
			if(REAGENT_VOLUME(reagents, rtype) >= 3 && reagent.radioactivity)
				glowing = TRUE
				break
		if(glowing)
			set_light(1, 0.2, COLOR_GREEN)
		else
			set_light(0)

// Map helper.
/obj/abstract/fluid_mapped
	name = "mapped flooded area"
	alpha = 125
	icon_state = "shallow_still"
	color = COLOR_LIQUID_WATER

	var/fluid_type = /decl/material/liquid/water
	var/fluid_initial = FLUID_MAX_DEPTH

/obj/abstract/fluid_mapped/Initialize()
	..()
	var/turf/T = get_turf(src)
	if(istype(T))
		T.add_fluid(fluid_type, fluid_initial)
	return INITIALIZE_HINT_QDEL

/obj/abstract/fluid_mapped/fuel
	name = "spilled fuel"
	fluid_type = /decl/material/liquid/fuel
	fluid_initial = 10

// Permaflood overlay.
var/global/list/flood_type_overlay_cache = list()
/proc/get_flood_overlay(fluid_type)
	if(!ispath(fluid_type, /decl/material))
		return null
	if(!global.flood_type_overlay_cache[fluid_type])
		var/decl/material/fluid_decl = GET_DECL(fluid_type)
		var/obj/effect/flood/new_flood = new
		new_flood.color = fluid_decl.color
		new_flood.alpha = round(fluid_decl.min_fluid_opacity + ((fluid_decl.max_fluid_opacity - fluid_decl.min_fluid_opacity) * 0.5))
		global.flood_type_overlay_cache[fluid_type] = new_flood
		return new_flood
	return global.flood_type_overlay_cache[fluid_type]

/obj/effect/flood
	name          = ""
	icon          = 'icons/effects/liquids.dmi'
	icon_state    = "ocean"
	layer         = DEEP_FLUID_LAYER
	color         = COLOR_LIQUID_WATER
	alpha         = 140
	invisibility  = 0
	simulated     = FALSE
	density       = FALSE
	anchored      = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
