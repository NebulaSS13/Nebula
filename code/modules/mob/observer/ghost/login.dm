/mob/observer/ghost/Login()
	..()

	if (ghost_image)
		ghost_image.appearance = src
		ghost_image.appearance_flags = RESET_ALPHA
	SSghost_images.queue_image_update(src)
	change_light_color(DARKTINT_GOOD)
