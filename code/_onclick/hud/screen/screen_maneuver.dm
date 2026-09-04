/obj/screen/maneuver
	name = "Prepare Maneuver"
	icon_state = "maneuver_off"
	screen_loc = ui_pull_resist
	use_supplied_ui_color = TRUE
	use_supplied_ui_alpha = TRUE

/obj/screen/maneuver/handle_click(mob/user, params)
	if(isliving(user))
		var/mob/living/user_living = user
		user_living.prepare_maneuver()

/obj/screen/maneuver/examined_by(mob/user, distance, infix, suffix)
	SHOULD_CALL_PARENT(FALSE)
	var/mob/living/user_living = user
	if(istype(user_living) && user_living.prepared_maneuver)
		to_chat(user, SPAN_NOTICE("You are prepared to [user_living.prepared_maneuver.name]."))
	else
		to_chat(user, SPAN_NOTICE("You are not prepared to perform a maneuver."))
	return TRUE

/obj/screen/maneuver/on_update_icon()
	var/mob/living/owner = owner_ref?.resolve()
	icon_state = (istype(owner) && owner.prepared_maneuver) ? "maneuver_on" : "maneuver_off"
	..()
