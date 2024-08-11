/atom/movable/fluid_overlay
	name              = ""
	icon              = 'icons/effects/liquids.dmi'
	icon_state        = ""
	anchored          = TRUE
	simulated         = FALSE
	opacity           = FALSE
	mouse_opacity     = MOUSE_OPACITY_UNCLICKABLE
	layer             = FLY_LAYER
	alpha             = 0
	color             = COLOR_LIQUID_WATER
	is_spawnable_type = FALSE
	appearance_flags  = KEEP_TOGETHER
	var/last_update_depth
	var/updating_edge_mask

/atom/movable/fluid_overlay/on_update_icon()

	var/datum/reagents/loc_reagents = loc?.reagents
	var/reagent_volume = loc_reagents?.total_volume

	// Update layer.
	var/new_layer
	if(reagent_volume > FLUID_DEEP)
		new_layer = DEEP_FLUID_LAYER
	else
		var/turf/T = get_turf(src)
		if(T?.get_physical_height() < 0)
			new_layer = T.layer + 0.2
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
			new_alpha = clamp(ceil(255*(reagent_volume/FLUID_DEEP)) * main_reagent.opacity, main_reagent.min_fluid_opacity, main_reagent.max_fluid_opacity)
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
	else
		cut_overlays()
// Define FLUID_AMOUNT_DEBUG before this to get a handy overlay of fluid amounts.
#ifdef FLUID_AMOUNT_DEBUG
	var/image/I = new()
	I.maptext = STYLE_SMALLFONTS_OUTLINE("<center>[num2text(reagent_volume)]</center>", 6, COLOR_WHITE, COLOR_BLACK)
	I.maptext_y = 8
	I.appearance_flags |= KEEP_APART
	add_overlay(I)
#endif
	compile_overlays()

	if((last_update_depth > FLUID_PUDDLE) != (reagent_volume > FLUID_PUDDLE))

		// Update alpha masks.
		for(var/checkdir in global.alldirs)
			var/turf/neighbor = get_step_resolving_mimic(loc, checkdir)
			if(istype(neighbor) && neighbor.fluid_overlay && !neighbor.fluid_overlay.updating_edge_mask)
				neighbor.fluid_overlay.update_alpha_mask()
		if(!updating_edge_mask)
			update_alpha_mask()

		// Update everything on our atom too.
		if(length(loc?.contents) && (last_update_depth > FLUID_PUDDLE && last_update_depth <= FLUID_SHALLOW) != (reagent_volume <= FLUID_SHALLOW))
			for(var/atom/movable/AM in loc.contents)
				if(AM.simulated)
					AM.update_turf_alpha_mask()

	last_update_depth = reagent_volume

var/global/list/_fluid_edge_mask_cache = list()
/atom/movable/fluid_overlay/proc/update_alpha_mask()

	set waitfor = FALSE
	// Delay to avoid multiple updates.
	if(updating_edge_mask)
		return
	updating_edge_mask = TRUE
	sleep(-1)
	updating_edge_mask = FALSE

	if(loc?.reagents?.total_volume <= FLUID_PUDDLE)
		remove_filter("fluid_edge_mask")
		return

	// Collect neighbor info.
	var/list/ignored
	var/list/connections
	for(var/checkdir in global.alldirs)
		var/turf/neighbor = get_step_resolving_mimic(loc, checkdir)
		if(!neighbor || neighbor.density || neighbor?.reagents?.total_volume > FLUID_PUDDLE)
			LAZYADD(connections, checkdir)
		else
			LAZYADD(ignored, checkdir)

	if(!LAZYLEN(connections))
		remove_filter("fluid_edge_mask")
		return

	// Generate and apply an alpha filter for our edges.
	// Need to use icons here due to overlays being hell with directional states.

	var/cache_key = "[length(connections) ? jointext(connections, "-") : 0]|[length(ignored) ? jointext(ignored, "-") : 0]"
	var/icon/edge_mask = global._fluid_edge_mask_cache[cache_key]
	if(isnull(edge_mask))
		connections = dirs_to_corner_states(connections)
		edge_mask = icon(icon, "blank")
		for(var/i = 1 to 4)
			if(length(connections) >= i)
				edge_mask.Blend(icon(icon, "edgemask[connections[i]]", dir = BITFLAG(i-1)), ICON_OVERLAY)
		global._fluid_edge_mask_cache[cache_key] = edge_mask || FALSE

	if(edge_mask)
		add_filter("fluid_edge_mask", 1, list(type = "alpha", icon = edge_mask, flags = MASK_INVERSE))
	else
		remove_filter("fluid_edge_mask")

/atom/movable/fluid_overlay/Destroy()
	var/atom/oldloc = loc
	. = ..()
	if(istype(oldloc))
		for(var/atom/movable/AM in oldloc.contents)
			if(AM.simulated)
				AM.update_turf_alpha_mask()
