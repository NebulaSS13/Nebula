/turf/wall/natural/proc/make_ramp(var/mob/user, var/new_slope, var/skip_icon_update = FALSE)

	ramp_slope_direction = new_slope

	var/old_ao = permit_ao
	if(ramp_slope_direction)
		drop_ore()
		permit_ao  = FALSE
		blocks_air = FALSE
		density    = FALSE
		opacity    = FALSE

		// Pretend to be a normal floor turf under the ramp.
		var/turf/under = floor_type
		icon             = initial(under.icon)
		icon_state       = initial(under.icon_state)
		color            = initial(under.color)

		decals = null
		var/turf/ramp_above = GetAbove(src)
		if(ramp_above)
			ramp_above.handle_ramp_dug_below(src)
		update_neighboring_ramps()

	else
		permit_ao  = initial(permit_ao)
		blocks_air = initial(blocks_air)
		density    = initial(density)
		color      = initial(color)
		refresh_opacity()

		icon = 'icons/turf/walls/natural.dmi'
		icon_state = "blank"

	if(!skip_icon_update)
		for(var/turf/wall/natural/neighbor in RANGE_TURFS(src, 1))
			neighbor.update_icon()
		if(old_ao != permit_ao)
			regenerate_ao()

/turf/wall/natural/proc/update_neighboring_ramps(destroying_self)
	// Clear any ramps we were supporting.
	for(var/turf/wall/natural/neighbor in RANGE_TURFS(src, 1))
		if(!neighbor.ramp_slope_direction || neighbor == src)
			continue
		var/turf/wall/natural/support = get_step(neighbor, global.reverse_dir[neighbor.ramp_slope_direction])
		if(!istype(support) || (destroying_self && support == src) || support.ramp_slope_direction)
			neighbor.dismantle_turf(ramp_update = FALSE) // This will only occur on ramps, so no need to propagate to other ramps.

/turf/wall/natural/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/drill_ramp)

/decl/interaction_handler/drill_ramp
	name = "Drill Ramp"
	expected_target_type = /turf/wall/natural

/decl/interaction_handler/drill_ramp/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..()
	if(.)
		if(!IS_PICK(prop))
			return FALSE
		var/turf/wall/natural/wall = target
		if(!HasAbove(wall.z))
			return FALSE
		if(!user.Adjacent(target))
			return FALSE
		return TRUE

/decl/interaction_handler/drill_ramp/invoked(atom/target, mob/user, obj/item/prop)
	var/turf/wall/natural/wall = target
	var/user_dir = get_dir(wall, user)
	if(!(user_dir in global.cardinal))
		to_chat(user, SPAN_WARNING("You must be standing at a cardinal angle to create a ramp."))
		return FALSE
	var/turf/wall/natural/support = get_step(wall, global.reverse_dir[user_dir])
	if(!istype(support) || support.ramp_slope_direction)
		to_chat(user, SPAN_WARNING("You cannot cut a ramp into a wall with no additional walls behind it."))
		return FALSE
	if(prop.do_tool_interaction(TOOL_PICK, user, wall, 3 SECONDS, suffix_message = ", forming it into a ramp") && !wall.ramp_slope_direction)
		wall.make_ramp(user, user_dir)
		return TRUE
	return FALSE
