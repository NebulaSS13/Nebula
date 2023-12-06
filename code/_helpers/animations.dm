/proc/remove_images_from_clients(image/I, list/show_to)
	for(var/client/C in show_to)
		C.images -= I
		qdel(I)

/proc/fade_out(image/I, list/show_to)
	animate(I, alpha = 0, time = 0.5 SECONDS, easing = EASE_IN)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/remove_images_from_clients, I, show_to), 0.5 SECONDS)

/proc/animate_speech_bubble(image/I, list/show_to, duration)
	if(!I)
		return
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

/proc/flick_overlay(image/I, list/show_to, duration)
	for(var/client/C in show_to)
		C.images += I
	addtimer(CALLBACK(GLOBAL_PROC, .proc/remove_images_from_clients, I, show_to), duration)

/atom/movable/proc/do_attack_effect(atom/A, effect) //Simple effects for telegraphing or marking attack locations
	if (effect)
		var/image/I = image('icons/effects/effects.dmi', A, effect, ABOVE_PROJECTILE_LAYER)

		if (!I)
			return

		flick_overlay(I, global.clients, 10)

		// And animate the attack!
		animate(I, alpha = 175, transform = matrix() * 0.75, pixel_x = 0, pixel_y = 0, pixel_z = 0, time = 3)
		animate(time = 1)
		animate(alpha = 0, time = 3, easing = CIRCULAR_EASING|EASE_OUT)

/atom/proc/shake_animation(var/intensity = 8)
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	animate(src, transform=turn(matrix(), intensity*shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=null, pixel_x=init_px, time=6, easing=ELASTIC_EASING)

/atom/proc/SpinAnimation(speed = 10, loops = -1, clockwise = 1, segments = 3, parallel = TRUE)
	if(!segments)
		return
	var/segment = 360/segments
	if(!clockwise)
		segment = -segment
	var/list/matrices = list()
	for(var/i in 1 to segments-1)
		var/matrix/M = matrix(transform)
		M.Turn(segment*i)
		matrices += M
	var/matrix/last = matrix(transform)
	matrices += last

	speed /= segments

	if(parallel)
		animate(src, transform = matrices[1], time = speed, loops , flags = ANIMATION_PARALLEL)
	else
		animate(src, transform = matrices[1], time = speed, loops)
	for(var/i in 2 to segments) //2 because 1 is covered above
		animate(transform = matrices[i], time = speed)
		//doesn't have an object argument because this is "Stacking" with the animate call above
		//3 billion% intentional

// This proc is used to move an atom to a target loc and then interpolite to give the illusion of sliding from start to end.
/proc/do_visual_slide(var/atom/movable/sliding, var/turf/from, var/from_pixel_x, var/from_pixel_y, var/turf/target, var/target_pixel_x, var/target_pixel_y, var/center_of_mass)
	set waitfor = FALSE
	var/start_pixel_x = sliding.pixel_x - ((target.x-from.x) * world.icon_size)
	var/start_pixel_y = sliding.pixel_y - ((target.y-from.y) * world.icon_size)
	// Clear our glide so we don't do an animation when dropped into the target turf.
	var/old_animate_movement = sliding.animate_movement
	sliding.animate_movement = NO_STEPS
	sleep(2 * world.tick_lag) // Due to BYOND being byond, animate_movement has to be set for at least 2 ticks before gliding will be disabled.
	sliding.forceMove(target)
	// Reset our glide_size now that movement has completed.
	sliding.animate_movement = old_animate_movement
	sliding.pixel_x = start_pixel_x
	sliding.pixel_y = start_pixel_y
	if(center_of_mass)
		target_pixel_x -= center_of_mass["x"]
		target_pixel_y -= center_of_mass["y"]
	animate(sliding, pixel_x = target_pixel_x, pixel_y = target_pixel_y, time = 1 SECOND)
