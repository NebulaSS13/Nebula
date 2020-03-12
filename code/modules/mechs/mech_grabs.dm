/mob/living/exosuit/can_grab(atom/movable/target, target_zone)
	return FALSE

/mob/living/exosuit/can_be_grabbed(mob/grabber, target_zone)
	return FALSE

/mob/living/exosuit/adjust_pixel_offsets_for_grab(var/obj/item/grab/G, var/grab_dir)
	reset_plane_and_layer()
	
/mob/living/exosuit/reset_pixel_offsets_for_grab(var/obj/item/grab/G)
	reset_plane_and_layer()