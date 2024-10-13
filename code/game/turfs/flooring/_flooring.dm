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
	var/gender = PLURAL /// "that's some grass"
	var/icon_base
	var/color = COLOR_WHITE
	var/footstep_type = /decl/footsteps/blank
	var/growth_value = 0

	var/neighbour_type

	var/has_base_range
	var/damage_temperature
	var/icon_edge_layer = FLOOR_EDGE_NONE
	var/has_environment_proc

	/// Unbuildable if not set. Must be /obj/item/stack.
	var/build_type
	/// Unbuildable if object material var is not set to this.
	var/build_material
	/// Stack units.
	var/build_cost = 1
	/// BYOND ticks.
	var/build_time = 0

	var/descriptor
	var/flooring_flags
	var/remove_timer = 10
	var/can_paint
	var/can_engrave = TRUE

	var/turf_light_range
	var/turf_light_power
	var/turf_light_color

	var/decl/material/force_material

	var/movement_delay

	/// Smooth with nothing except the types in this list. Turned into a typecache for performance reasons.
	var/list/flooring_whitelist = list()
	/// Smooth with everything except the types in this list. Turned into a typecache for performance reasons.
	var/list/flooring_blacklist = list()

	/// How we smooth with other flooring
	var/floor_smooth
	/// How we smooth with walls
	var/wall_smooth
	/// How we smooth with space and openspace tiles
	var/space_smooth

	/// same z flags used for turfs, i.e ZMIMIC_DEFAULT etc
	var/z_flags
	/// Flags to apply to the turf.
	var/turf_flags

	var/constructed = FALSE

	var/has_internal_edges = FALSE
	var/has_external_edges = FALSE
	var/edge_state
	var/corner_state
	var/outer_edge_state
	var/outer_corner_state

	var/render_trenches = TRUE
	var/floor_layer = TURF_LAYER
	var/holographic = FALSE
	var/dirt_color = "#7c5e42"

/decl/flooring/Initialize()
	. = ..()

	neighbour_type ||= type

	if(ispath(force_material))
		force_material = GET_DECL(force_material)
	if(!istype(force_material))
		force_material = null

	if(holographic)
		turf_flags         = null
		damage_temperature = INFINITY
		build_type         = null
		build_material     = null
		flooring_flags     = null
		can_paint          = FALSE
		can_engrave        = FALSE
		constructed        = TRUE

	edge_state         = "[icon_base]_edges"
	corner_state       = "[icon_base]_corners"
	outer_edge_state   = "[icon_base]_outer_edges"
	outer_corner_state = "[icon_base]_outer_corners"

	flooring_whitelist = typecacheof(flooring_whitelist)
	flooring_blacklist = typecacheof(flooring_blacklist)
	has_internal_edges = check_state_in_icon(edge_state, icon)       || check_state_in_icon(corner_state, icon)
	has_external_edges = check_state_in_icon(outer_edge_state, icon) || check_state_in_icon(outer_corner_state, icon)

	var/default_smooth = (has_internal_edges || has_external_edges) ? SMOOTH_NONE : SMOOTH_ALL
	if(isnull(wall_smooth))
		wall_smooth =  default_smooth
	if(isnull(space_smooth))
		space_smooth = default_smooth
	if(isnull(floor_smooth))
		floor_smooth = default_smooth

/decl/flooring/validate()
	. = ..()

	if(!istext(name))
		. += "null or invalid name string"

	if(!istext(desc))
		. += "null or invalid desc string"

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

/decl/flooring/proc/get_surface_descriptor()
	return descriptor || name || "terrain"

/decl/flooring/proc/update_turf_strings(turf/floor/target)
	target.SetName(name)
	target.desc = desc

/decl/flooring/proc/update_turf_icon(turf/floor/target)

	if(target.icon != icon)
		target.icon = icon
	if(!target.floor_icon_state_override)
		target.floor_icon_state_override = icon_base
		if(has_base_range)
			target.floor_icon_state_override = "[target.floor_icon_state_override][rand(0,has_base_range)]"

	if(target.icon_state != target.floor_icon_state_override)
		target.icon_state = target.floor_icon_state_override

	if(color)
		target.color = color
	else
		var/decl/material/use_material = target.get_material()
		target.color = use_material?.color

	var/edge_layer = (icon_edge_layer != FLOOR_EDGE_NONE) ? target.layer + icon_edge_layer : target.layer
	var/list/edge_overlays = list()
	var/has_border = 0
	for(var/step_dir in global.cardinal)
		var/turf/T = get_step_resolving_mimic(target, step_dir)
		if(!istype(T) || symmetric_test_link(target, T))
			continue
		has_border |= step_dir
		if(icon_edge_layer != FLOOR_EDGE_NONE)
			if(has_internal_edges)
				edge_overlays += get_flooring_overlay("[icon]_[icon_base]-edge-[step_dir]", edge_state, step_dir, edge_layer = edge_layer)
			if(has_external_edges && target.can_draw_edge_over(T))
				edge_overlays += get_flooring_overlay("[icon]_[icon_base]-outer-edge-[step_dir]", outer_edge_state, step_dir, TRUE, edge_layer = edge_layer)

	if (has_internal_edges || has_external_edges)
		var/has_smooth = ~(has_border & (NORTH | SOUTH | EAST | WEST))
		for(var/step_dir in global.cornerdirs)
			var/turf/T = get_step_resolving_mimic(target, step_dir)
			if(!istype(T) || symmetric_test_link(target, T))
				continue
			if(icon_edge_layer != FLOOR_EDGE_NONE)
				if(has_internal_edges)
					if((has_smooth & step_dir) == step_dir)
						edge_overlays += get_flooring_overlay("[icon]_[icon_base]-corner-[step_dir]", corner_state, step_dir, edge_layer = edge_layer)
					else if((has_border & step_dir) == step_dir)
						edge_overlays += get_flooring_overlay("[icon]_[icon_base]-edge-[step_dir]", edge_state, step_dir, edge_layer = edge_layer)
				if(has_external_edges && target.can_draw_edge_over(T))
					if((has_smooth & step_dir) == step_dir)
						edge_overlays += get_flooring_overlay("[icon]_[icon_base]-outer-corner-[step_dir]", outer_corner_state, step_dir, TRUE, edge_layer = edge_layer)
					else if((has_border & step_dir) == step_dir)
						edge_overlays += get_flooring_overlay("[icon]_[icon_base]-outer-edge-[step_dir]", outer_edge_state, step_dir, TRUE, edge_layer = edge_layer)

	if(length(edge_overlays))
		target.add_overlay(edge_overlays)

/decl/flooring/proc/get_flooring_overlay(var/cache_key, var/icon_base, var/icon_dir = 0, var/external = FALSE, var/edge_layer)
	cache_key = "[cache_key]-[edge_layer]"
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
		I.layer = edge_layer
		global.flooring_cache[cache_key] = I
	return global.flooring_cache[cache_key]

/decl/flooring/proc/on_remove()
	return

/decl/flooring/proc/get_movement_delay(var/travel_dir, var/mob/mover)
	return movement_delay

/decl/flooring/proc/get_movable_alpha_mask_state(atom/movable/mover)
	return

/decl/flooring/proc/handle_item_interaction(turf/floor/floor, mob/user, obj/item/item)

	if(!istype(user) || !istype(item) || !istype(floor) || user.a_intent == I_HURT)
		return FALSE

	if(!(IS_SCREWDRIVER(item) && (flooring_flags & TURF_REMOVE_SCREWDRIVER)) && floor.try_graffiti(user, item))
		return TRUE

	if(IS_SHOVEL(item) && (flooring_flags & TURF_REMOVE_SHOVEL))
		if(!user.do_skilled(remove_timer, SKILL_CONSTRUCTION, floor) || floor.get_topmost_flooring() != src)
			return TRUE
		to_chat(user, SPAN_NOTICE("You remove the [get_surface_descriptor()] with \the [item]."))
		floor.set_flooring(null, place_product = TRUE)
		playsound(floor, 'sound/items/Deconstruct.ogg', 80, 1)
		return TRUE

	if(constructed)

		if(IS_CROWBAR(item))
			if(floor.is_floor_damaged())
				if(!user.do_skilled(remove_timer, SKILL_CONSTRUCTION, floor, 0.15))
					return TRUE
				if(floor.get_topmost_flooring() != src)
					return
				to_chat(user, SPAN_NOTICE("You remove the broken [get_surface_descriptor()]."))
				floor.set_flooring(null)
			else if(flooring_flags & TURF_IS_FRAGILE)
				if(!user.do_skilled(remove_timer, SKILL_CONSTRUCTION, floor, 0.15))
					return TRUE
				if(floor.get_topmost_flooring() != src)
					return
				to_chat(user, SPAN_DANGER("You forcefully pry off the [get_surface_descriptor()], destroying them in the process."))
				floor.set_flooring(null)
			else if(flooring_flags & TURF_REMOVE_CROWBAR)
				if(!user.do_skilled(remove_timer, SKILL_CONSTRUCTION, floor))
					return TRUE
				if(floor.get_topmost_flooring() != src)
					return
				to_chat(user, SPAN_NOTICE("You lever off the [get_surface_descriptor()]."))
				floor.set_flooring(null, place_product = TRUE)
			else
				return
			playsound(floor, 'sound/items/Crowbar.ogg', 80, 1)
			return TRUE

		if(IS_SCREWDRIVER(item) && (flooring_flags & TURF_REMOVE_SCREWDRIVER))
			if(floor.is_floor_damaged())
				return FALSE
			if(!user.do_skilled(remove_timer, SKILL_CONSTRUCTION, floor) || floor.get_topmost_flooring() != src)
				return TRUE
			to_chat(user, SPAN_NOTICE("You unscrew and remove the [get_surface_descriptor()]."))
			floor.set_flooring(null, place_product = TRUE)
			playsound(floor, 'sound/items/Screwdriver.ogg', 80, 1)
			return TRUE

		if(IS_WRENCH(item) && (flooring_flags & TURF_REMOVE_WRENCH))
			if(!user.do_skilled(remove_timer, SKILL_CONSTRUCTION, floor) || floor.get_topmost_flooring() != src)
				return TRUE
			to_chat(user, SPAN_NOTICE("You unwrench and remove the [get_surface_descriptor()]."))
			floor.set_flooring(null, place_product = TRUE)
			playsound(floor, 'sound/items/Ratchet.ogg', 80, 1)
			return TRUE

		if(IS_COIL(item))
			to_chat(user, SPAN_WARNING("You must remove the [get_surface_descriptor()] first."))
			return TRUE

	return FALSE

/decl/flooring/proc/fire_act(turf/floor/target, datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return FALSE

/decl/flooring/proc/fluid_act(turf/floor/target, datum/reagents/fluids)
	return FALSE

/decl/flooring/proc/handle_environment_proc(turf/floor/target)
	return PROCESS_KILL
