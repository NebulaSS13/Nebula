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

// TODO: convert to alt interaction.
/turf/wall/natural/AltClick(mob/user)

	var/obj/item/P = user.get_active_held_item()
	if(user.Adjacent(src) && IS_PICK(P) && HasAbove(z))

		var/user_dir = get_dir(src, user)
		if(!(user_dir in global.cardinal))
			to_chat(user, SPAN_WARNING("You must be standing at a cardinal angle to create a ramp."))
			return TRUE

		var/turf/wall/natural/support = get_step(src, global.reverse_dir[user_dir])
		if(!istype(support) || support.ramp_slope_direction)
			to_chat(user, SPAN_WARNING("You cannot cut a ramp into a wall with no additional walls behind it."))
			return TRUE

		if(P.do_tool_interaction(TOOL_PICK, user, src, 3 SECONDS, suffix_message = ", forming it into a ramp") && !ramp_slope_direction)
			make_ramp(user, user_dir)
		return TRUE

	. = ..()
