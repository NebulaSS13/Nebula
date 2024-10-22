/obj/screen/maneuver
	name = "Prepare Maneuver"
	icon_state = "maneuver_off"
	screen_loc = ui_pull_resist

/obj/screen/maneuver/handle_click(mob/user, params)
	if(isliving(user))
		var/mob/living/user_living = user
		user_living.prepare_maneuver()

/obj/screen/maneuver/examine(mob/user, distance)
	. = ..()
	if(!isliving(user))
		return
	var/mob/living/user_living = user
	if(user_living.prepared_maneuver)
		to_chat(src, SPAN_NOTICE("You are prepared to [user_living.prepared_maneuver.name]."))
	else
		to_chat(src, SPAN_NOTICE("You are not prepared to perform a maneuver."))
