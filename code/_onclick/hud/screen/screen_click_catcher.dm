var/global/list/click_catchers
/proc/get_click_catchers()
	if(!global.click_catchers)
		global.click_catchers = list()
		var/ox = -(round(config.max_client_view_x*0.5))
		for(var/i = 0 to config.max_client_view_x)
			var/oy = -(round(config.max_client_view_y*0.5))
			var/tx = ox + i
			for(var/j = 0 to config.max_client_view_y)
				var/ty = oy + j
				var/obj/screen/click_catcher/CC = new
				CC.screen_loc = "CENTER[tx < 0 ? tx : "+[tx]"],CENTER[ty < 0 ? ty : "+[ty]"]"
				CC.x_offset = tx
				CC.y_offset = ty
				global.click_catchers += CC
	return global.click_catchers

/obj/screen/click_catcher
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "click_catcher"
	plane = CLICKCATCHER_PLANE
	mouse_opacity = MOUSE_OPACITY_PRIORITY
	screen_loc = "CENTER-7,CENTER-7"
	requires_owner = FALSE
	is_global_screen = TRUE
	var/x_offset = 0
	var/y_offset = 0

/obj/screen/click_catcher/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	return QDEL_HINT_LETMELIVE

/obj/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["middle"] && iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		var/turf/origin = get_turf(usr)
		if(isturf(origin))
			var/turf/clicked = locate(origin.x + x_offset, origin.y + y_offset, origin.z)
			if(clicked)
				clicked.Click(location, control, params)
	. = 1
