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

/decl/flooring/Initialize()
	. = ..()
	flooring_whitelist = typecacheof(flooring_whitelist)
	flooring_blacklist = typecacheof(flooring_blacklist)

/decl/flooring/validate()
	. = ..()
	if(!icon)
		. += "null icon"
	if(!istext(icon_base))
		. += "null or invalid icon_state '[icon_base]'"
	if(icon && icon_base)
		if(has_base_range)
			for(var/i = 0 to has_base_range)
				var/check_state = "[icon_base][i]"
				if(!check_state_in_icon(check_state, icon))
					. += "missing icon_state '[check_state]' from '[icon]'"
		else if(!check_state_in_icon(icon_base, icon))
			. += "missing icon_state '[icon_base]' from '[icon]'"
		if((flags & (TURF_HAS_CORNERS|TURF_HAS_INNER_CORNERS)) && !check_state_in_icon("[icon_base]_corners", icon))
			. += "flagged for corners but missing corner state from '[icon]'"
		if((flags & TURF_HAS_EDGES) && !check_state_in_icon("[icon_base]_edges", icon))
			. += "flagged for edges but missing edge state from '[icon]'"

/decl/flooring/proc/on_remove()
	return

/decl/flooring/proc/get_movement_delay(var/travel_dir, var/mob/mover)
	return movement_delay
