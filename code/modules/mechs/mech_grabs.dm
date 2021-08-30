/mob/living/exosuit/can_grab(atom/movable/target, target_zone)
	return FALSE

/mob/living/exosuit/can_be_grabbed(mob/grabber, target_zone)
	return FALSE

/mob/living/exosuit/refresh_pixel_offsets(var/anim_time = 2)
	reset_plane_and_layer()
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y
	pixel_z = default_pixel_z
