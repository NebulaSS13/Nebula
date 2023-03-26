// State values:
// [icon_base]: initial base icon_state without edges or corners.
// if has_base_range is set, append 0-has_base_range ie.
//   [icon_base][has_base_range]
// [icon_base]_broken: damaged overlay.
// if has_damage_range is set, append 0-damage_range for state ie.
//   [icon_base]_broken[has_damage_range]
// [icon_base]_edges: directional overlays for edges.
// [icon_base]_corners: directional overlays for non-edge corners.

/decl/flooring
	abstract_type = /decl/flooring

	var/name
	var/desc
	var/icon
	var/icon_base
	var/color
	var/footstep_type = /decl/footsteps/blank

	var/has_base_range
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature

	var/icon_edge_layer = -1
	var/icon_edge_states

	var/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_material  // Unbuildable if object material var is not set to this.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/flags
	var/remove_timer = 10
	var/is_removable = TRUE
	var/can_paint
	var/can_engrave = TRUE
	var/movement_delay

	/// Smooth with nothing except the types in this list. Turned into a typecache for performance reasons.
	var/list/flooring_whitelist = list()
	/// Smooth with everything except the types in this list. Turned into a typecache for performance reasons.
	var/list/flooring_blacklist = list()

	var/floor_smooth = SMOOTH_ALL
	var/space_smooth = SMOOTH_ALL
	var/wall_smooth  = SMOOTH_ALL

	var/z_flags //same z flags used for turfs, i.e ZMIMIC_DEFAULT etc
	var/height = 0
	var/list/diggable_resources

/decl/flooring/Initialize()
	. = ..()

	flooring_whitelist = typecacheof(flooring_whitelist)
	flooring_blacklist = typecacheof(flooring_blacklist)


	_inner_edges_state    = "[icon_base]_inner_edges"
	_inner_corner_state   = "[icon_base]_inner_corners"
	_inner_junction_state = "[icon_base]_inner_junction"
	_outer_edges_state    = "[icon_base]_edges"
	_outer_corner_state   = "[icon_base]_corners"
	_outer_junction_state = "[icon_base]_junction"

	_has_outer_edges      = check_state_in_icon(_outer_edges_state, icon)
	_has_outer_corners    = check_state_in_icon(_outer_corner_state, icon) || check_state_in_icon(_outer_junction_state, icon)
	_has_inner_edges      = check_state_in_icon(_inner_edges_state, icon)
	_has_inner_corners    = check_state_in_icon(_inner_corner_state, icon) || check_state_in_icon(_inner_junction_state, icon)
	_has_edge_overlays    = (_has_outer_edges || _has_outer_corners || _has_inner_edges || _has_inner_corners)

/decl/flooring/validate()
	. = ..()

	if(has_base_range)
		for(var/i = 0 to has_base_range)
			if(!check_state_in_icon("[icon_base][i]", icon))
				. += "missing base icon state: '[icon_base][i]'"
	else if(!check_state_in_icon(icon_base, icon))
		. += "missing base icon state: '[icon_base]'"

	if(_has_inner_corners)
		if(!check_state_in_icon(_inner_junction_state, icon))
			. += "missing inner junction icon state: '[_inner_junction_state]'"
		if(!check_state_in_icon(_inner_corner_state, icon))
			. += "missing inner corners icon state: '[_inner_corner_state]'"
	else
		if(check_state_in_icon(_inner_junction_state, icon))
			. += "extraneous inner junction icon state: '[_inner_junction_state]'"
		if(check_state_in_icon(_inner_corner_state, icon))
			. += "extraneous inner corners icon state: '[_inner_corner_state]'"

	if(_has_outer_corners)
		if(!check_state_in_icon(_outer_junction_state, icon))
			. += "missing outer junction icon state: '[_outer_junction_state]'"
		if(!check_state_in_icon(_outer_corner_state, icon))
			. += "missing outer corners icon state: '[_outer_corner_state]'"
	else
		if(check_state_in_icon(_outer_junction_state, icon))
			. += "extraneous outer junction icon state: '[_outer_junction_state]'"
		if(check_state_in_icon(_outer_corner_state, icon))
			. += "extraneous outer corners icon state: '[_outer_corner_state]'"

	if(flags & TURF_CAN_BREAK)
		if(has_damage_range)
			for(var/i = 0 to has_damage_range)
				if(!check_state_in_icon("[icon_base]_broken[i]", icon))
					. += "missing damage icon state: '[icon_base]_broken[i]'"
		else if(!check_state_in_icon("[icon_base]_broken0", icon))
			. += "missing damage icon state: '[icon_base]_broken0'"

	if(flags & TURF_CAN_BURN)
		if(has_burn_range)
			for(var/i = 0 to has_burn_range)
				if(!check_state_in_icon("[icon_base]_burned[i]", icon))
					. += "missing burn icon state: '[icon_base]_burned[i]'"
		else if(!check_state_in_icon("[icon_base]_burned0", icon))
			. += "missing burn icon state: '[icon_base]_burned0'"

/decl/flooring/proc/get_diggable_resources(has_been_dug)
	return (has_been_dug && length(diggable_resources)) ? diggable_resources : null

/decl/flooring/proc/can_have_additional_layers(var/decl/flooring/other)
	return FALSE

/decl/flooring/proc/get_flooring_movement_delay(var/travel_dir, var/mob/mover)
	return movement_delay

/decl/flooring/proc/on_remove(var/turf/loc, var/place_build_product = FALSE)
	if(!istype(loc) || !build_type || !place_build_product)
		return
	// If build type uses material stack, check for it
	// Because material stack uses different arguments
	// And we need to use build material to spawn stack
	if(ispath(build_type, /obj/item/stack/material))
		var/decl/material/M = GET_DECL(build_material)
		if(!M)
			CRASH("[loc] at ([loc.x], [loc.y], [loc.z]) cannot create stack because it has a bad build_material path: '[build_material]'")
		M.create_object(loc, build_cost, build_type)
	else
		new build_type(loc)

/decl/flooring/proc/get_apply_color()
	return color

/decl/flooring/proc/apply_appearance_to(var/turf/target)

	// Set strings.
	target.SetName(name)
	target.desc = desc

	// Set flooring icon.
	if(target.icon != icon)
		target.icon = icon
	var/apply_color = get_apply_color(target)
	if(target.color != apply_color)
		target.color = apply_color

	// Apply base icon state.
	if(target.icon_base)
		target.icon_state = target.icon_base
	else
		if(has_base_range)
			target.icon_state = "[icon_base][rand(0,has_base_range)]"
		else
			target.icon_state = icon_base
		target.icon_base = target.icon_state
