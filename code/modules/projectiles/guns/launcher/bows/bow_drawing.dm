/obj/item/gun/launcher/bow/proc/get_loaded_arrow(mob/user)
	return _loaded

/obj/item/gun/launcher/bow/proc/get_draw_time(mob/firer)
	. = draw_time
	if(firer)
		. = max(1, round(draw_time * firer.skill_delay_mult(work_skill)))

/obj/item/gun/launcher/bow/proc/check_can_draw(mob/user)
	. = istype(user) && !QDELETED(user) && !QDELETED(src) && (!require_loaded_to_draw || get_loaded_arrow(user))
	if(. && requires_string)
		. = istype(string) && !QDELETED(string)

/obj/item/gun/launcher/bow/proc/start_drawing(var/mob/user)

	if(tension != 0 || autofire_enabled)
		return

	if(!get_loaded_arrow(user) && require_loaded_to_draw)
		to_chat(user, SPAN_WARNING("You don't have anything loaded in \the [src]."))
		return

	if(user.restrained() || tension > 0 || drawing_bow)
		return

	drawing_bow = TRUE
	show_draw_message(user)
	if(!user.do_skilled(get_draw_time(), work_skill, src))
		drawing_bow = FALSE
		show_cancel_draw_message(user)
		tension = 0
		return

	if(!check_can_draw(user))
		drawing_bow = FALSE
		tension = 0
		update_icon()
		return

	tension = 1
	update_icon()
	if(tension < max_tension)
		show_working_draw_message(user)
		continue_drawing(user)
	else
		drawing_bow = FALSE
		show_max_draw_message(user)

/obj/item/gun/launcher/bow/proc/continue_drawing(mob/user)
	set waitfor = FALSE
	if(!check_can_draw(user) || !user.do_skilled(get_draw_time(), work_skill, src) || !check_can_draw(user))
		tension = 0
		drawing_bow = FALSE
		if(user)
			show_cancel_draw_message(user)
	else
		tension++
		if(tension >= max_tension)
			tension = max_tension
			show_max_draw_message(user)
			drawing_bow = FALSE
		else
			show_working_draw_message(user)
			continue_drawing(user)
	update_icon()

/obj/item/gun/launcher/bow/wielder_mouse_drag_down(mob/user, object, location, control, params)
	if(drawing_bow)
		return FALSE
	. = ..()

// Nock an arrow, or continue to draw the string back.
// We do this here so we don't instantly nock an arrow even if this is not a proper drag yet.
// DO NOT CALL PARENT, default full auto behavior is to fire while held.
/obj/item/gun/launcher/bow/wielder_mouse_drag_held(mob/user, atom/target)

	if(!autofire_enabled)
		return FALSE

	// High skills mean you automatically nock an arrow before you draw.
	if(tension <= 0 && !get_loaded_arrow(user) && user.skill_check(SKILL_WEAPONS, SKILL_ADEPT))
		load_available_ammo(user)

	if(!check_can_draw(user))
		return FALSE

	// Start drawing.
	if(!drawing_bow)
		drawing_bow = TRUE
		tension = 0
		next_tension_step = world.time + get_draw_time(user)
		if(user && isatom(target))
			user.set_dir(get_dir(user, target))
		show_draw_message(user)
		update_icon()
		return TRUE

	// Already drawing - keep drawing.
	if(world.time >= next_tension_step && tension < max_tension)
		next_tension_step = world.time + get_draw_time(user)
		tension++
		if(tension == max_tension)
			show_max_draw_message(user)
		else
			show_working_draw_message(user)
		update_icon()
	return TRUE

// Fire!
/obj/item/gun/launcher/bow/wielder_mouse_drag_up(mob/user, atom/target)
	if(!autofire_enabled || !istype(target))
		return FALSE
	if(tension && istype(user) && !user.incapacitated() && user.get_active_held_item() == src && get_loaded_arrow())
		user.set_dir(get_dir(user, target))
		Fire(target, user, null, (get_dist(target, user) <= 1), FALSE, FALSE)
	if(tension)
		if(istype(user))
			show_cancel_draw_message(user)
		tension = 0
		update_icon()
	drawing_bow = FALSE
	return TRUE
