/mob/living/exosuit/can_grab(atom/movable/target, target_zone, defer_hand = FALSE)
	return FALSE

/mob/living/exosuit/can_be_grabbed(mob/grabber, target_zone)
	return FALSE

/mob/living/exosuit/reset_offsets(var/anim_time = 2)
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y
	pixel_z = default_pixel_z

/mob/living/exosuit/reset_plane()
	plane = initial(plane)

/mob/living/exosuit/reset_layer()
	layer = initial(layer)

/mob/living/exosuit/reset_plane_and_layer()
	reset_plane()
	reset_layer()