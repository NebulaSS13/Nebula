// TODO: buildable with artifice?
// TODO: looping 2 second tick tock sound, somehow aligned with pendulum (may not be possible in DM)
/obj/structure/grandfather_clock
	name                = "grandfather clock"
	desc                = "A tall, stately timepiece."
	icon                = 'icons/obj/structures/grandfather_clock.dmi'
	icon_state          = ICON_STATE_WORLD
	density             = TRUE
	material            = /decl/material/solid/organic/wood/mahogany
	material_alteration = MAT_FLAG_ALTERATION_ALL
	color               = /decl/material/solid/organic/wood/mahogany::color
	var/face_color      = "#f0edc7"
	var/last_time
	var/decl/material/clockwork_mat = /decl/material/solid/metal/brass

/obj/structure/grandfather_clock/Initialize(ml, _mat, _reinf_mat)
	if(ispath(clockwork_mat))
		clockwork_mat = GET_DECL(clockwork_mat)
	. = ..()
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/structure/grandfather_clock/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	// TODO: check literacy?
	if(isnull(last_time))
		last_time = stationtime2text()
	. += SPAN_NOTICE("The face of \the [src] reads [last_time].")

// TODO: don't magically make the time update when swinging is restarted
// TODO: alt interaction to interfere with the clock?
/obj/structure/grandfather_clock/attack_hand(mob/user)
	. = ..()
	if(!.)
		if(is_processing)
			STOP_PROCESSING(SSobj, src)
			user.visible_message(SPAN_NOTICE("\The [user] reaches into \the [src] and stops the pendulum."))
		else
			START_PROCESSING(SSobj, src)
			user.visible_message(SPAN_NOTICE("\The [user] reaches into \the [src] and sets the pendulum swinging."))
		update_icon()
		return TRUE

/obj/structure/grandfather_clock/Process()
	..()
	var/new_time = stationtime2text()
	if(new_time != last_time)
		last_time = new_time
		update_icon()

/obj/structure/grandfather_clock/on_update_icon()
	. = ..()
	if(isnull(last_time))
		last_time = stationtime2text()
	if(face_color)
		add_overlay(overlay_image(icon, "[icon_state]-face", face_color, RESET_COLOR))
	if(!clockwork_mat)
		return
	if(is_processing)
		add_overlay(overlay_image(icon, "[icon_state]-pendulum-swing", clockwork_mat.color, RESET_COLOR))
	else
		add_overlay(overlay_image(icon, "[icon_state]-pendulum", clockwork_mat.color, RESET_COLOR))
	var/list/time_stats = splittext(last_time, ":")
	add_overlay(overlay_image(icon, "[icon_state]-hour[round(((text2num(time_stats[1]) / 24) * 360) / 45) * 45]"), clockwork_mat.color, RESET_COLOR)
	add_overlay(overlay_image(icon, "[icon_state]-minute[round(((text2num(time_stats[2]) / 60) * 360) / 45) * 45]"), clockwork_mat.color, RESET_COLOR)
