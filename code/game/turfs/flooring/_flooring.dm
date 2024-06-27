var/global/list/flooring_cache = list()

// State values:
// [icon_base]: initial base icon_state without edges or corners.
// if has_base_range is set, append 0-has_base_range ie.
//   [icon_base][has_base_range]
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
	var/damage_temperature

	var/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_material  // Unbuildable if object material var is not set to this.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/flags
	var/remove_timer = 10
	var/can_paint
	var/can_engrave = TRUE

	var/movement_delay

	//How we smooth with other flooring
	var/decal_layer = DECAL_LAYER
	var/floor_smooth = SMOOTH_ALL
	/// Smooth with nothing except the types in this list. Turned into a typecache for performance reasons.
	var/list/flooring_whitelist = list()
	/// Smooth with everything except the types in this list. Turned into a typecache for performance reasons.
	var/list/flooring_blacklist = list()

	//How we smooth with walls
	var/wall_smooth = SMOOTH_ALL
	//There are no lists for walls at this time

	//How we smooth with space and openspace tiles
	var/space_smooth = SMOOTH_ALL
	//There are no lists for spaces
	var/z_flags //same z flags used for turfs, i.e ZMIMIC_DEFAULT etc

	var/height = 0

	var/has_internal_edges = FALSE
	var/has_external_edges = FALSE
	var/edge_state
	var/corner_state
	var/outer_edge_state
	var/outer_corner_state

	var/render_trenches = TRUE

/decl/flooring/Initialize()
	. = ..()

	edge_state         = "[icon_base]_edges"
	corner_state       = "[icon_base]_corners"
	outer_edge_state   = "[icon_base]_outer_edges"
	outer_corner_state = "[icon_base]_outer_corners"

	flooring_whitelist = typecacheof(flooring_whitelist)
	flooring_blacklist = typecacheof(flooring_blacklist)
	has_internal_edges = check_state_in_icon(edge_state, icon)       || check_state_in_icon(corner_state, icon)
	has_external_edges = check_state_in_icon(outer_edge_state, icon) || check_state_in_icon(outer_corner_state, icon)

/decl/flooring/validate()
	. = ..()

	if(!icon)
		. += "null icon"

	if(!istext(icon_base))
		. += "null or invalid icon_state '[icon_base]'"

	if(icon && icon_base)

		if(!check_state_in_icon("trench", icon))
			. += "no trench wall state"

		if(has_base_range)
			for(var/i = 0 to has_base_range)
				var/check_state = "[icon_base][i]"
				if(!check_state_in_icon(check_state, icon))
					. += "missing icon_state '[check_state]' from '[icon]'"
		else if(!check_state_in_icon(icon_base, icon))
			. += "missing icon_state '[icon_base]' from '[icon]'"

		if(has_internal_edges)
			if(!check_state_in_icon(edge_state, icon))
				. += "flagged for internal edges but missing edge state from '[icon]'"
			if(!check_state_in_icon(corner_state, icon))
				. += "flagged for internal edges but missing corner state from '[icon]'"

		if(has_external_edges)
			if(!check_state_in_icon(outer_edge_state, icon))
				. += "flagged for external edges but missing edge state from '[icon]'"
			if(!check_state_in_icon(outer_corner_state, icon))
				. += "flagged for external edges but missing corner state from '[icon]'"

/decl/flooring/proc/update_turf_icon(turf/floor/target)

	target.SetName(name)
	target.desc  = desc
	if(target.icon != icon)
		target.icon  = icon
	if(target.color != color)
		target.color = color
	if(!target.flooring_override)
		target.flooring_override = icon_base
		if(has_base_range)
			target.flooring_override = "[target.flooring_override][rand(0,has_base_range)]"

	if(target.icon_state != target.flooring_override)
		target.icon_state = target.flooring_override

	var/has_border = 0
	for(var/step_dir in global.cardinal)
		var/turf/floor/T = get_step(target, step_dir)
		var/is_linked = symmetric_test_link(target, T)
		if (!is_linked)
			has_border |= step_dir
			if(has_internal_edges)
				target.add_overlay(get_flooring_overlay("[icon]_[icon_base]-edge-[step_dir]", edge_state, step_dir))
			if(has_external_edges)
				target.add_overlay(get_flooring_overlay("[icon]_[icon_base]-outer-edge-[step_dir]", outer_edge_state, step_dir, TRUE))

	if (has_internal_edges || has_external_edges)
		var/has_smooth = ~(has_border & (NORTH | SOUTH | EAST | WEST))
		for(var/step_dir in global.cornerdirs)
			if(!symmetric_test_link(target, get_step(target, step_dir)))
				if(has_internal_edges)
					if((has_smooth & step_dir) == step_dir)
						target.add_overlay(get_flooring_overlay("[icon]_[icon_base]-corner-[step_dir]", corner_state, step_dir))
					else if((has_border & step_dir) == step_dir)
						target.add_overlay(get_flooring_overlay("[icon]_[icon_base]-edge-[step_dir]", edge_state, step_dir))
				if(has_external_edges)
					if((has_smooth & step_dir) == step_dir)
						target.add_overlay(get_flooring_overlay("[icon]_[icon_base]-outer-corner-[step_dir]", outer_corner_state, step_dir, TRUE))
					else if((has_border & step_dir) == step_dir)
						target.add_overlay(get_flooring_overlay("[icon]_[icon_base]-outer-edge-[step_dir]", outer_edge_state, step_dir, TRUE))

/decl/flooring/proc/get_flooring_overlay(var/cache_key, var/icon_base, var/icon_dir = 0, var/external = FALSE)
	if(!global.flooring_cache[cache_key])
		var/image/I = image(icon = icon, icon_state = icon_base, dir = icon_dir)
		//External overlays will be offset out of this tile
		if (external)
			if (icon_dir & NORTH)
				I.pixel_y = world.icon_size
			else if (icon_dir & SOUTH)
				I.pixel_y = -world.icon_size
			if (icon_dir & WEST)
				I.pixel_x = -world.icon_size
			else if (icon_dir & EAST)
				I.pixel_x = world.icon_size
		I.layer = decal_layer
		global.flooring_cache[cache_key] = I
	return global.flooring_cache[cache_key]

/decl/flooring/proc/on_remove()
	return

/decl/flooring/proc/get_movement_delay(var/travel_dir, var/mob/mover)
	return movement_delay
