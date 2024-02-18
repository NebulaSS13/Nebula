/atom/movable/fluid_overlay
	name                = ""
	icon                = 'icons/effects/liquids.dmi'
	icon_state          = "puddle"
	anchored            = TRUE
	simulated           = FALSE
	opacity             = FALSE
	mouse_opacity       = MOUSE_OPACITY_UNCLICKABLE
	layer               = FLY_LAYER
	alpha               = 0
	color               = COLOR_LIQUID_WATER
	is_spawnable_type   = FALSE

/atom/movable/fluid_overlay/on_update_icon()
	var/datum/reagents/loc_reagents = loc?.reagents
	var/reagent_volume = loc_reagents?.total_volume
	if(reagent_volume > FLUID_OVER_MOB_HEAD)
		layer = DEEP_FLUID_LAYER
	else
		layer = SHALLOW_FLUID_LAYER
	var/new_color = loc_reagents?.get_color()
	if(color != new_color)
		color = new_color
	var/decl/material/main_reagent = loc_reagents?.get_primary_reagent_decl()
	if(main_reagent) // TODO: weighted alpha from all reagents, not just primary
		alpha = clamp(CEILING(255*(reagent_volume/FLUID_DEEP)) * main_reagent.opacity, main_reagent.min_fluid_opacity, main_reagent.max_fluid_opacity)
	else
		alpha = FLUID_MIN_ALPHA
	var/new_icon_state
	if(reagent_volume <= FLUID_PUDDLE)
		new_icon_state = "puddle"
	else if(reagent_volume <= FLUID_SHALLOW)
		new_icon_state = "shallow_still"
	else if(reagent_volume < FLUID_DEEP)
		new_icon_state = "mid_still"
	else if(reagent_volume < (FLUID_DEEP*2))
		new_icon_state = "deep_still"
	else
		new_icon_state = "ocean"
	if(new_icon_state != icon_state)
		icon_state = new_icon_state

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
