// CAMERA

// An addition to deactivate which removes/adds the camera from the chunk list based on if it works or not.

/obj/machinery/camera/proc/update_coverage()
	cameranet.update_visibility(src)
	invalidateCameraCache()

// Mobs
/mob/living/silicon/ai/Initialize()
	. = ..()
	cameranet.add_source(src)

/mob/living/silicon/ai/Destroy()
	cameranet.remove_source(src)
	. = ..()

/mob/living/silicon/ai/rejuvenate()
	var/was_dead = stat == DEAD
	..()
	if(was_dead && stat != DEAD)
		// Arise!
		cameranet.update_visibility(src, FALSE)

/mob/living/silicon/ai/death(gibbed)
	. = ..()
	if(.)
		// If true, the mob went from living to dead (assuming everyone has been overriding as they should...)
		cameranet.update_visibility(src, FALSE)
