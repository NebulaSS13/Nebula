/*
/obj/item/gun/energy/staff/handle_click_empty()
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(get_turf(src), 'sound/effects/sparks1.ogg', 100, 1)
*/