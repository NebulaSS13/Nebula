/atom/movable/fluid_overlay
	name                = ""
	icon                = 'icons/effects/liquids.dmi'
	icon_state          = ""
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

	// Update layer.
	var/new_layer
	if(reagent_volume > FLUID_OVER_MOB_HEAD)
		new_layer = DEEP_FLUID_LAYER
	else
		new_layer = SHALLOW_FLUID_LAYER
	if(layer != new_layer)
		layer = new_layer

	// Update colour.
	var/new_color = loc_reagents?.get_color()
	if(color != new_color)
		color = new_color

	// Update alpha.
	var/decl/material/main_reagent = loc_reagents?.get_primary_reagent_decl()
	var/new_alpha
	if(main_reagent) // TODO: weighted alpha from all reagents, not just primary
		new_alpha = clamp(CEILING(255*(reagent_volume/FLUID_DEEP)) * main_reagent.opacity, main_reagent.min_fluid_opacity, main_reagent.max_fluid_opacity)
	else
		new_alpha = FLUID_MIN_ALPHA
	if(new_alpha != alpha)
		alpha = new_alpha

	// Update icon state. We use overlays so flick() can work on the base fluid overlay.
	if(reagent_volume <= FLUID_PUDDLE)
		set_overlays("puddle")
	else if(reagent_volume <= FLUID_SHALLOW)
		set_overlays("shallow_still")
	else if(reagent_volume < FLUID_DEEP)
		set_overlays("mid_still")
	else if(reagent_volume < (FLUID_DEEP*2))
		set_overlays("deep_still")
	else
		set_overlays("ocean")

// Map helpers.
/obj/abstract/landmark/mapped_flood
	name = "mapped fluid area"
	alpha = FLUID_MAX_ALPHA
	icon_state = "ocean"
	color = COLOR_LIQUID_WATER
	var/fluid_type = /decl/material/liquid/water

/obj/abstract/landmark/mapped_flood/Initialize()
	..()
	var/turf/my_turf = get_turf(src)
	if(my_turf)
		my_turf.set_flooded(fluid_type)
	return INITIALIZE_HINT_QDEL

/obj/abstract/landmark/mapped_fluid
	name = "mapped fluid area"
	alpha = FLUID_MIN_ALPHA
	icon_state = "shallow_still"
	color = COLOR_LIQUID_WATER

	var/fluid_type = /decl/material/liquid/water
	var/fluid_initial = FLUID_MAX_DEPTH

/obj/abstract/landmark/mapped_fluid/Initialize()
	..()
	var/turf/my_turf = get_turf(src)
	if(my_turf)
		my_turf.add_fluid(fluid_type, fluid_initial)
	return INITIALIZE_HINT_QDEL

/obj/abstract/landmark/mapped_fluid/fuel
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
