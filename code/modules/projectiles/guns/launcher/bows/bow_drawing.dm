/obj/item/gun/launcher/bow/proc/get_loaded_arrow(mob/user)
	return _loaded

/obj/item/gun/launcher/bow/proc/get_draw_time(mob/firer)
	. = draw_time
	if(firer)
		. = max(1, round(draw_time * firer.skill_delay_mult(work_skill)))

/obj/item/gun/launcher/bow/proc/check_can_draw(mob/user)
	. = istype(user) && !QDELETED(user) && !QDELETED(src) && (!require_loaded_to_draw || get_loaded_arrow(user))
	if(. && initial(string))
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
