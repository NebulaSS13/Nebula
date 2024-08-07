
/mob
	var/list/screens = list()

/mob/proc/set_fullscreen(condition, screen_name, screen_type, arg)
	condition ? overlay_fullscreen(screen_name, screen_type, arg) : clear_fullscreen(screen_name)

/mob/proc/overlay_fullscreen(category, type, severity)
	var/obj/screen/fullscreen/screen = screens[category]

	if(screen)
		if(screen.type != type)
			clear_fullscreen(category, FALSE)
			screen = null
		else if(!severity || severity == screen.severity)
			return null

	if(!screen)
		screen = new type(null, src)

	screen.icon_state = "[initial(screen.icon_state)][severity]"
	screen.severity = severity

	screens[category] = screen
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
	var/obj/screen/fullscreen/screen = screens[category]
	if(!screen)
		return

	screens -= category

	if(animated)
		show_screen(screen, animated)
	else
		if(client)
			client.screen -= screen
		qdel(screen)

/mob/proc/clear_fullscreens()
	for(var/category in screens)
		clear_fullscreen(category)

/mob/proc/hide_fullscreens()
	if(client)
		for(var/category in screens)
			client.screen -= screens[category]

/mob/proc/reload_fullscreen()
	if(client)
		var/largest_bound = max(client.last_view_x_dim, client.last_view_y_dim)
		for(var/category in screens)
			var/obj/screen/fullscreen/screen = screens[category]
			screen.transform = null
			if(screen.screen_loc != ui_entire_screen && largest_bound > 7)
				var/matrix/M = matrix()
				M.Scale(ceil(client.last_view_x_dim/7), ceil(client.last_view_y_dim/7))
				screen.transform = M
			client.screen |= screen

