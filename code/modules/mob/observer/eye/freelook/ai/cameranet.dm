// CAMERA NET
//
// The datum containing all the chunks.

/datum/visualnet/camera
	// The security cameras on the map, no matter if they work or not. This list only contains cameras of type /obj/machinery/camera.
	var/list/cameras
	chunk_type = /datum/chunk/camera
	valid_source_types = list(/obj/machinery/camera, /mob/living/silicon/ai)

/datum/visualnet/camera/New()
	cameras = list()
	..()

/datum/visualnet/camera/Destroy()
	cameras.Cut()
	. = ..()

// Add a camera to a chunk.
/datum/visualnet/camera/add_source(obj/machinery/camera/c)
	if(istype(c))
		if(c in cameras)
			return FALSE
		. = ..(c, c.can_use())
		if(.)
			ADD_SORTED(cameras, c, /proc/cmp_camera_ctag_asc)
	else if(isAI(c))
		var/mob/living/silicon/AI = c
		return ..(AI, AI.stat != DEAD)
	else
		return ..()

/datum/visualnet/camera/remove_source(obj/machinery/camera/c)
	if(istype(c) && cameras.Remove(c))
		. = ..(c, c.can_use())
	if(isAI(c))
		var/mob/living/silicon/AI = c
		return ..(AI, AI.stat != DEAD)
	else
		. = ..()

/datum/visualnet/camera/is_valid_source(atom/source)
	. = ..()
	if(.)
		return
	return istype(get_extension(source, /datum/extension/network_device), /datum/extension/network_device/camera)