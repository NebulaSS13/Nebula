
/obj/effect/quicksand
	name = "quicksand"
	desc = "There is no candy at the bottom."
	icon = 'icons/obj/quicksand.dmi'
	icon_state = "open"
	density = 0
	anchored = 1
	can_buckle = 1
	buckle_dir = SOUTH
	var/exposed = 0
	var/busy

/obj/effect/quicksand/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	appearance = T.appearance

/obj/effect/quicksand/user_unbuckle_mob(mob/user)
	if(buckled_mob && !user.stat && !user.restrained())
		if(busy)
			to_chat(user, SPAN_NOTICE("\The [buckled_mob] is already getting out, be patient."))
			return
		var/delay = 60
		if(user == buckled_mob)
			delay *=2
			user.visible_message(
				SPAN_NOTICE("\The [user] tries to climb out of \the [src]."),
				SPAN_NOTICE("You begin to pull yourself out of \the [src]."),
				SPAN_NOTICE("You hear water sloshing.")
				)
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] begins pulling \the [buckled_mob] out of \the [src]."),
				SPAN_NOTICE("You begin to pull \the [buckled_mob] out of \the [src]."),
				SPAN_NOTICE("You hear water sloshing.")
				)
		busy = 1
		if(do_after(user, delay, src))
			busy = 0
			if(user == buckled_mob)
				if(prob(80))
					to_chat(user, SPAN_WARNING("You slip and fail to get out!"))
					return
				user.visible_message(SPAN_NOTICE("\The [buckled_mob] pulls himself out of \the [src]."))
			else
				user.visible_message(SPAN_NOTICE("\The [buckled_mob] has been freed from \the [src] by \the [user]."))
			unbuckle_mob()
		else
			busy = 0
			to_chat(user, SPAN_WARNING("You slip and fail to get out!"))
			return

/obj/effect/quicksand/unbuckle_mob()
	..()
	update_icon()

/obj/effect/quicksand/buckle_mob(var/mob/L)
	..()
	update_icon()

/obj/effect/quicksand/on_update_icon()
	if(!exposed)
		return
	icon_state = "open"
	cut_overlays()
	if(buckled_mob)
		add_overlay(image(icon,icon_state="overlay",layer=ABOVE_HUMAN_LAYER))

/obj/effect/quicksand/proc/expose()
	if(exposed)
		return
	visible_message(SPAN_WARNING("The upper crust breaks, exposing the treacherous quicksand underneath!"))
	SetName(initial(name))
	desc = initial(desc)
	icon = initial(icon)
	exposed = 1
	update_icon()

/obj/effect/quicksand/attackby(obj/item/W, mob/user)
	if(!exposed && W.force)
		expose()
	else
		..()

/obj/effect/quicksand/Crossed(var/atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.throwing || L.can_overcome_gravity())
			return
		buckle_mob(L)
		if(!exposed)
			expose()
		to_chat(L, SPAN_DANGER("You fall into \the [src]!"))
