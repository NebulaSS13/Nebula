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
	var/last_update_depth

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
	if(reagent_volume)

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
		compile_overlays()

	// Update alpha masks.
	if((last_update_depth > FLUID_PUDDLE && last_update_depth <= FLUID_SHALLOW) != (reagent_volume > FLUID_PUDDLE && reagent_volume <= FLUID_SHALLOW) && length(loc?.contents))
		for(var/atom/movable/AM in loc.contents)
			if(AM.simulated)
				AM.update_turf_alpha_mask()
	last_update_depth = reagent_volume

/atom/movable/fluid_overlay/Destroy()
	var/atom/oldloc = loc
	. = ..()
	if(istype(oldloc))
		for(var/atom/movable/AM in oldloc.contents)
			if(AM.simulated)
				AM.update_turf_alpha_mask()
