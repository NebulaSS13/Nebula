/obj/screen/look_upward
	name                  = "up hint"
	icon_state            = "uphint0"
	screen_loc            = ui_up_hint
	use_supplied_ui_color = TRUE
	use_supplied_ui_alpha = TRUE

/obj/screen/look_upward/handle_click(mob/user, params)
	if(isliving(user))
		var/mob/living/L = user
		L.lookup()

/obj/screen/look_upward/on_update_icon()
	var/mob/owner = owner_ref?.resolve()
	var/turf/above = istype(owner) ? GetAbove(get_turf(owner)) : null
	icon_state = "uphint[!!(istype(above) && TURF_IS_MIMICKING(above))]"
	..()
