/proc/remove_images_from_clients(image/I, list/show_to)
	for(var/client/C in show_to)
		C.images -= I
		qdel(I)

/proc/fade_out(image/I, list/show_to)
	animate(I, alpha = 0, time = 0.5 SECONDS, easing = EASE_IN)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/remove_images_from_clients, I, show_to), 0.5 SECONDS)

/proc/animate_speech_bubble(image/I, list/show_to, duration)
	var/matrix/M = matrix()
	M.Scale(0,0)
	I.transform = M
	I.alpha = 0
	for(var/client/C in show_to)
		C.images += I
	animate(I, transform = 0, alpha = 255, time = 0.2 SECONDS, easing = EASE_IN)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/fade_out, I, show_to), (duration - 0.5 SECONDS))

/proc/animate_receive_damage(atom/A)
	var/pixel_x_diff = rand(-2,2)
	var/pixel_y_diff = rand(-2,2)
	animate(A, pixel_x = A.pixel_x + pixel_x_diff, pixel_y = A.pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = initial(A.pixel_x), pixel_y = initial(A.pixel_y), time = 2)

/proc/animate_throw(atom/A)
	var/ipx = A.pixel_x
	var/ipy = A.pixel_y
	var/mpx = 0
	var/mpy = 0

	if(A.dir & NORTH)
		mpy += 3
	else if(A.dir & SOUTH)
		mpy -= 3
	if(A.dir & EAST)
		mpx += 3
	else if(A.dir & WEST)
		mpx -= 3

	var/x = mpx + ipx
	var/y = mpy + ipy

	animate(A, pixel_x = x, pixel_y = y, time = 0.6, easing = EASE_OUT)

	var/matrix/M = matrix(A.transform)
	animate(transform = turn(A.transform, (mpx - mpy) * 4), time = 0.6, easing = EASE_OUT)
	animate(pixel_x = ipx, pixel_y = ipy, time = 0.6, easing = EASE_IN)
	animate(transform = M, time = 0.6, easing = EASE_IN)
