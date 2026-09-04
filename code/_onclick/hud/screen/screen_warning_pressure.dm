/obj/screen/warning/pressure
	name        = "pressure"
	icon        = 'icons/mob/screen/styles/status_pressure.dmi'
	icon_state  = "pressure0"
	screen_loc  = ui_temp
	base_state  = "pressure"
	check_alert = /decl/hud_element/pressure

/obj/screen/warning/pressure/handle_click(mob/user, params)
	switch(icon_state)
		if("pressure2")
			to_chat(user, SPAN_DANGER("The air pressure here is crushing!"))
		if("pressure1")
			to_chat(user, SPAN_WARNING("The air pressure here is dangerously high."))
		if("pressure-1")
			to_chat(user, SPAN_WARNING("The air pressure here is dangerously low."))
		if("pressure-2")
			to_chat(user, SPAN_DANGER("There is nearly no air pressure here!"))
		else
			to_chat(user, SPAN_NOTICE("The local air pressure is comfortable."))
