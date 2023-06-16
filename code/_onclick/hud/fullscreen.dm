
/mob
	var/list/_screens

/mob/proc/set_fullscreen(condition, screen_name, screen_type, arg)
	condition ? overlay_fullscreen(screen_name, screen_type, arg) : clear_fullscreen(screen_name)

/mob/proc/overlay_fullscreen(category, type, severity)
	var/obj/screen/fullscreen/screen = LAZYACCESS(_screens, category)

	if(screen)
		if(screen.type != type)
			clear_fullscreen(category, FALSE)
			screen = null
		else if(!severity || severity == screen.severity)
			return null

	if(!screen)
		screen = new type()

	screen.icon_state = "[initial(screen.icon_state)][severity]"
	screen.severity = severity

	LAZYSET(_screens, category, screen)
	screen.transform = null
	if(screen && client && (stat != DEAD || screen.allstate))
		client.screen += screen
	return screen

/mob/proc/show_screen(var/screen, var/animated)
	set waitfor = FALSE
	animate(screen, alpha = 0, time = animated)
	sleep(animated)
	if(screen && client)
		client.screen -= screen
		qdel(screen)

/mob/proc/clear_fullscreen(category, animated = 10)
	var/obj/screen/fullscreen/screen = LAZYACCESS(_screens, category)
	if(!screen)
		return

	LAZYREMOVE(_screens, category)

	if(animated)
		show_screen(screen, animated)
	else
		if(client)
			client.screen -= screen
		qdel(screen)

/mob/proc/clear_fullscreens()
	for(var/category in _screens)
		clear_fullscreen(category)

/mob/proc/hide_fullscreens()
	if(client)
		for(var/category in _screens)
			client.screen -= _screens[category]

/mob/proc/reload_fullscreen()
	if(client)
		var/largest_bound = max(client.last_view_x_dim, client.last_view_y_dim)
		for(var/category in _screens)
			var/obj/screen/fullscreen/screen = _screens[category]
			screen.transform = null
			if(screen.screen_loc != ui_entire_screen && largest_bound > 7)
				var/matrix/M = matrix()
				M.Scale(CEILING(client.last_view_x_dim/7), CEILING(client.last_view_y_dim/7))
				screen.transform = M
			client.screen |= screen

/obj/screen/fullscreen
	icon = 'icons/mob/screen/full.dmi'
	icon_state = "default"
	screen_loc = ui_center_fullscreen
	plane = FULLSCREEN_PLANE
	layer = FULLSCREEN_LAYER
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	var/severity = 0
	var/allstate = 0 //shows if it should show up for dead people too

/obj/screen/fullscreen/Destroy()
	severity = 0
	return ..()

/obj/screen/fullscreen/brute
	icon_state = "brutedamageoverlay"
	layer = DAMAGE_LAYER

/obj/screen/fullscreen/oxy
	icon_state = "oxydamageoverlay"
	layer = DAMAGE_LAYER

/obj/screen/fullscreen/crit
	icon_state = "passage"
	layer = CRIT_LAYER

/obj/screen/fullscreen/blind
	icon_state = "blackimageoverlay"
	layer = BLIND_LAYER

/obj/screen/fullscreen/blackout
	icon = 'icons/mob/screen/fill.dmi'
	icon_state = "black"
	screen_loc = ui_entire_screen
	layer = BLIND_LAYER

/obj/screen/fullscreen/impaired
	icon_state = "impairedoverlay"
	layer = IMPAIRED_LAYER

/obj/screen/fullscreen/blurry
	icon = 'icons/mob/screen/fill.dmi'
	screen_loc = ui_entire_screen
	icon_state = "blurry"
	alpha = 100

/obj/screen/fullscreen/flash
	icon = 'icons/mob/screen/fill.dmi'
	screen_loc = ui_entire_screen
	icon_state = "flash"

/obj/screen/fullscreen/flash/noise
	icon_state = "noise"

/obj/screen/fullscreen/high
	icon = 'icons/mob/screen/fill.dmi'
	screen_loc = ui_entire_screen
	icon_state = "druggy"
	alpha = 180
	blend_mode = BLEND_MULTIPLY

/obj/screen/fullscreen/noise
	icon = 'icons/effects/static.dmi'
	icon_state = "1 light"
	screen_loc = ui_entire_screen
	alpha = 127

/obj/screen/fullscreen/fadeout
	icon = 'icons/mob/screen/fill.dmi'
	icon_state = "black"
	screen_loc = ui_entire_screen
	alpha = 0
	allstate = 1

/obj/screen/fullscreen/fadeout/Initialize()
	. = ..()
	animate(src, alpha = 255, time = 10)

/obj/screen/fullscreen/scanline
	icon = 'icons/effects/static.dmi'
	icon_state = "scanlines"
	screen_loc = ui_entire_screen
	alpha = 50

/obj/screen/fullscreen/fishbed
	icon_state = "fishbed"
	allstate = 1

/obj/screen/fullscreen/pain
	icon_state = "brutedamageoverlay6"
	alpha = 0

/obj/screen/fullscreen/blueprints
	icon = 'icons/effects/blueprints.dmi'
	icon_state = "base"
	screen_loc = ui_entire_screen
	alpha = 100
