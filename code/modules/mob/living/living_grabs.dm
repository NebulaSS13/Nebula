/mob/living/proc/can_grab(var/atom/movable/target, var/target_zone)
	if(get_active_hand())
		to_chat(src, SPAN_WARNING("Your hand is full!"))
		return FALSE
	if(LAZYLEN(grabbed_by))
		to_chat(src, SPAN_WARNING("You cannot start grappling while already being grappled!"))
		return FALSE
	for(var/obj/item/grab/G in target.grabbed_by)
		if(G.assailant != src)
			continue
		if(!target_zone || !ismob(target))
			to_chat(src, SPAN_WARNING("You already have a grip on \the [target]!"))
			return FALSE
		if(G.target_zone == target_zone)
			var/obj/O = G.get_targeted_organ()
			if(O)
				to_chat(src, SPAN_WARNING("You already have a grip on \the [target]'s [O.name]."))
				return FALSE
	return TRUE

/mob/living/proc/make_grab(var/atom/movable/target, var/grab_tag = /decl/grab/simple)

	// Resolve to the 'topmost' atom in the buckle chain, as grabbing someone buckled to something tends to prevent further interaction.
	var/atom/movable/original_target = target
	var/mob/grabbing_mob = target
	while(istype(grabbing_mob) && grabbing_mob.buckled)
		if(grabbing_mob.buckled == grabbing_mob) // Are circular buckles like this even possible?
			break
		grabbing_mob = grabbing_mob.buckled
	if(grabbing_mob && grabbing_mob != original_target)
		target = grabbing_mob
		to_chat(src, SPAN_WARNING("As \the [original_target] is buckled to \the [target], you try to grab that instead!"))

	if(!istype(target))
		return

	face_atom(target)
	if(original_target != src && ismob(original_target))
		to_chat(original_target, SPAN_WARNING("\The [src] tries to grab you!"))
		to_chat(src, SPAN_WARNING("You try to grab \the [target]!"))
	if(ispath(grab_tag, /decl/grab) && can_grab(target, zone_sel?.selecting) && target.can_be_grabbed(src, zone_sel?.selecting))
		var/obj/item/grab/grab = new(src, target, grab_tag)
		. = !QDELETED(grab)

/mob/living/add_grab(var/obj/item/grab/grab)
	for(var/obj/item/grab/other_grab in contents)
		if(other_grab != grab)
			return FALSE
	grab.forceMove(src)
	return TRUE

/mob/living/ProcessGrabs()
	if(LAZYLEN(grabbed_by))
		resist()

/mob/living/reset_pixel_offsets_for_grab(var/obj/item/grab/G)
	..()
	if(!buckled)
		animate(src, pixel_x = default_pixel_x, pixel_y = default_pixel_y, 4, 1, LINEAR_EASING)

/mob/living/adjust_pixel_offsets_for_grab(var/obj/item/grab/G, var/grab_dir)
	..()
	if(grab_dir && istype(G))
		var/draw_under = TRUE
		switch(grab_dir)
			if(NORTH)
				animate(src, pixel_x = default_pixel_x, pixel_y = default_pixel_y - G.current_grab.shift, 5, 1, LINEAR_EASING)
			if(WEST)
				animate(src, pixel_x = default_pixel_x + G.current_grab.shift, pixel_y = default_pixel_y, 5, 1, LINEAR_EASING)
			if(EAST)
				animate(src, pixel_x = default_pixel_x - G.current_grab.shift, pixel_y = default_pixel_y, 5, 1, LINEAR_EASING)
			if(SOUTH)
				animate(src, pixel_x = default_pixel_x, pixel_y = default_pixel_y + G.current_grab.shift, 5, 1, LINEAR_EASING)
				draw_under = FALSE
		plane = G.assailant.plane
		layer += draw_under ? -0.01 : 0.01
