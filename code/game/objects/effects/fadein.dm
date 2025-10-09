/obj/effect/dummy/fadein/Initialize(mapload, fade_dir = SOUTH, atom/donor)
	. = ..()
	set_dir(fade_dir)
	appearance = donor // grab appearance before ghostizing in case they fall over etc
	var/initial_alpha = alpha
	alpha = 0
	switch(dir)
		if(NORTH)
			pixel_z = -32
		if(SOUTH)
			pixel_z =  32
		if(EAST)
			pixel_w = -32
		if(WEST)
			pixel_w =  32
	animate(src, pixel_z = 0, pixel_w = 0, alpha = initial_alpha, time = 1 SECOND)
	QDEL_IN(src, 1 SECOND)
