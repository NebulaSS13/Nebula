/mob/proc/do_jitter(amplitude)
	pixel_x = default_pixel_x + rand(-amplitude, amplitude)
	pixel_y = default_pixel_y + rand(-amplitude/3, amplitude/3)

//handles up-down floaty effect in space and zero-gravity
/mob/var/is_floating = 0

/mob/proc/update_floating()

	if(anchored || buckled || has_gravity())
		stop_floating()
		return

	if(check_space_footing())
		stop_floating()
		return

	start_floating()
	return

/mob/proc/start_floating()

	is_floating = 1

	var/amplitude = 2 //maximum displacement from original position
	var/period = 36 //time taken for the mob to go up > down > original position, in deciseconds. Should be multiple of 4

	var/top = default_pixel_z + amplitude
	var/bottom = default_pixel_z - amplitude
	var/half_period = period / 2
	var/quarter_period = period / 4

	animate(src, pixel_z = top, time = quarter_period, easing = SINE_EASING | EASE_OUT, loop = -1)		//up
	animate(pixel_z = bottom, time = half_period, easing = SINE_EASING, loop = -1)						//down
	animate(pixel_z = default_pixel_z, time = quarter_period, easing = SINE_EASING | EASE_IN, loop = -1)			//back

/mob/proc/stop_floating()
	animate(src, pixel_z = default_pixel_z, time = 5, easing = SINE_EASING | EASE_IN) //halt animation
	//reset the pixel offsets to zero
	is_floating = 0

/atom/movable/proc/do_attack_animation(atom/A, atom/movable/weapon)

	set waitfor = FALSE

	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/turn_dir = 1

	var/direction = get_dir(src, A)
	if(direction & NORTH)
		pixel_y_diff = 8
		turn_dir = rand(50) ? -1 : 1
	else if(direction & SOUTH)
		pixel_y_diff = -8
		turn_dir = rand(50) ? -1 : 1

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8
		turn_dir = -1

	var/matrix/initial_transform = matrix(transform)
	var/matrix/rotated_transform = transform.Turn(15 * turn_dir)

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, transform = rotated_transform, time = 2, easing = BACK_EASING | EASE_IN)
	animate(pixel_x = pixel_x, pixel_y = pixel_y, transform = initial_transform, time = 2, easing = BACK_EASING | EASE_IN)

	if(buckled_mob)
		buckled_mob.do_attack_animation(A, weapon)

	sleep(4)
	reset_offsets()

/mob/proc/clear_shown_overlays(var/list/show_to, var/image/I)
	for(var/client/C in show_to)
		C.images -= I

/mob/do_attack_animation(atom/A, atom/movable/weapon)
	..()
	is_floating = 0 // If we were without gravity, the bouncing animation got stopped, so we make sure we restart the bouncing after the next movement.

	// What are we attacking with?
	if(!weapon)
		weapon = get_active_hand()
		if(!weapon)
			return

	// Create an image to show to viewers.
	// Reset plane and layer so that it doesn't inherit the UI settings from equipped items.
	var/image/I = new(loc = A)
	I.appearance = weapon
	I.plane = DEFAULT_PLANE
	I.layer = A.layer + 0.1
	I.pixel_x = 0
	I.pixel_y = 0
	I.pixel_z = 0
	I.pixel_w = 0

	// Who can see the attack?
	var/list/viewing = list()
	for(var/mob/M in viewers(A))
		if(M.client)
			viewing |= M.client

	for(var/client/C in viewing)
		C.images += I
	addtimer(CALLBACK(src, .proc/clear_shown_overlays, viewing, I), 5)

	// Scale the icon.
	I.transform *= 0.75
	// Set the direction of the icon animation.
	var/direction = get_dir(src, A)
	if(direction & NORTH)
		I.pixel_y = -16
	else if(direction & SOUTH)
		I.pixel_y = 16

	if(direction & EAST)
		I.pixel_x = -16
	else if(direction & WEST)
		I.pixel_x = 16

	if(!direction) // Attacked self?!
		I.pixel_z = 16

	// And animate the attack!
	animate(I, alpha = 175, pixel_x = 0, pixel_y = 0, pixel_z = 0, time = 3)

/mob/proc/spin(spintime, speed)
	spawn()
		var/D = dir
		while(spintime >= speed)
			sleep(speed)
			switch(D)
				if(NORTH)
					D = EAST
				if(SOUTH)
					D = WEST
				if(EAST)
					D = SOUTH
				if(WEST)
					D = NORTH
			set_dir(D)
			spintime -= speed
	return

/mob/proc/phase_in(var/turf/T)
	if(!T)
		return

	playsound(T, 'sound/effects/phasein.ogg', 25, 1)
	playsound(T, 'sound/effects/sparks2.ogg', 50, 1)
	anim(src,'icons/mob/mob.dmi',,"phasein",,dir)

/mob/proc/phase_out(var/turf/T)
	if(!T)
		return
	playsound(T, "sparks", 50, 1)
	anim(src,'icons/mob/mob.dmi',,"phaseout",,dir)
