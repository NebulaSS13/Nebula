#define TRACKING_POSSIBLE 0
#define TRACKING_NO_COVERAGE 1
#define TRACKING_TERMINATE 2

/mob/living/silicon/ai/var/max_locations = 10
/mob/living/silicon/ai/var/stored_locations[0]

/proc/InvalidPlayerTurf(turf/T)
	return !(T && isPlayerLevel(T.z))

/mob/living/silicon/ai/proc/get_camera_list()
	if(src.stat == DEAD)
		return

	var/list/T = list()
	for (var/obj/machinery/camera/C in cameranet.cameras)
		T[text("[][]", C.c_tag, (C.can_use() ? null : " (Deactivated)"))] = C

	track = new()
	track.cameras = T
	return T


/mob/living/silicon/ai/proc/ai_camera_list(var/camera in get_camera_list())
	set category = "Silicon Commands"
	set name = "Show Camera List"

	if(check_unable())
		return

	if (!camera)
		return 0

	var/obj/machinery/camera/C = track.cameras[camera]
	src.eyeobj.setLoc(C)

	return

/mob/living/silicon/ai/proc/ai_store_location(camera_loc as text)
	set category = "Silicon Commands"
	set name = "Store Camera Location"
	set desc = "Stores your current camera location by the given name"

	camera_loc = sanitize(camera_loc)
	if(!camera_loc)
		to_chat(src, SPAN_WARNING("Must supply a location name."))
		return

	if(stored_locations.len >= max_locations)
		to_chat(src, SPAN_WARNING("Cannot store additional locations, remove one first."))
		return

	if(camera_loc in stored_locations)
		to_chat(src, SPAN_WARNING("There is already a stored location by that name."))
		return

	var/L = src.eyeobj.getLoc()
	if (InvalidPlayerTurf(get_turf(L)))
		to_chat(src, SPAN_WARNING("Unable to store this location."))
		return

	stored_locations[camera_loc] = L
	to_chat(src, "Location '[camera_loc]' stored.")

/mob/living/silicon/ai/proc/sorted_stored_locations()
	return sortTim(stored_locations, /proc/cmp_text_asc)

/mob/living/silicon/ai/proc/ai_goto_location(loc in sorted_stored_locations())
	set category = "Silicon Commands"
	set name = "Goto Camera Location"
	set desc = "Returns to the selected camera location"

	if (!(loc in stored_locations))
		to_chat(src, SPAN_WARNING("Location [loc] not found."))
		return

	var/L = stored_locations[loc]
	src.eyeobj.setLoc(L)

/mob/living/silicon/ai/proc/ai_remove_location(loc in sorted_stored_locations())
	set category = "Silicon Commands"
	set name = "Delete Camera Location"
	set desc = "Deletes the selected camera location"

	if (!(loc in stored_locations))
		to_chat(src, SPAN_WARNING("Location [loc] not found."))
		return

	stored_locations.Remove(loc)
	to_chat(src, "Location [loc] removed.")

// Used to allow the AI is write in mob names/camera name from the CMD line.
/datum/trackable
	var/list/names = list()
	var/list/namecounts = list()
	var/list/humans = list()
	var/list/others = list()
	var/list/cameras = list()

/mob/living/silicon/ai/proc/trackable_mobs()
	if(usr.stat == DEAD)
		return list()

	var/datum/trackable/TB = new()
	for(var/mob/living/M in SSmobs.mob_list)
		if(M == usr)
			continue
		if(M.tracking_status() != TRACKING_POSSIBLE)
			continue

		var/name = M.name
		if (name in TB.names)
			TB.namecounts[name]++
			name = text("[] ([])", name, TB.namecounts[name])
		else
			TB.names.Add(name)
			TB.namecounts[name] = 1
		if(ishuman(M))
			TB.humans[name] = M
		else
			TB.others[name] = M

	var/list/targets = sortTim(TB.humans, /proc/cmp_text_asc) + sortTim(TB.others, /proc/cmp_text_asc)
	src.track = TB
	return targets

/mob/living/silicon/ai/proc/ai_camera_track(var/target_name in trackable_mobs())
	set category = "Silicon Commands"
	set name = "Follow With Camera"
	set desc = "Select who you would like to track."

	if(src.stat == DEAD)
		to_chat(src, "You can't follow [target_name] with cameras because you are dead!")
		return
	if(!target_name)
		src.cameraFollow = null

	var/mob/target = (isnull(track.humans[target_name]) ? track.others[target_name] : track.humans[target_name])
	src.track = null
	ai_actual_track(target)

/mob/living/silicon/ai/proc/ai_cancel_tracking(var/forced = 0)
	if(!cameraFollow)
		return

	to_chat(src, "Follow camera mode [forced ? "terminated" : "ended"].")
	cameraFollow.tracking_cancelled()
	cameraFollow = null

/mob/living/silicon/ai/proc/ai_actual_track(mob/living/target)
	if(!istype(target))	return
	var/mob/living/silicon/ai/U = usr

	if(target == U.cameraFollow)
		return

	if(U.cameraFollow)
		U.ai_cancel_tracking()
	U.cameraFollow = target
	to_chat(U, "Tracking target...")
	target.tracking_initiated()

	spawn (0)
		while (U.cameraFollow == target)
			if (U.cameraFollow == null)
				return

			switch(target.tracking_status())
				if(TRACKING_NO_COVERAGE)
					to_chat(U, "Target is not near any active cameras.")
					sleep(100)
					continue
				if(TRACKING_TERMINATE)
					U.ai_cancel_tracking(1)
					return

			if(U.eyeobj)
				U.eyeobj.setLoc(get_turf(target), 0)
			else
				view_core()
				return
			sleep(10)

/obj/machinery/camera/attack_ai(mob/living/silicon/ai/user)
	if (!istype(user))
		return
	if (!can_use())
		return
	user.eyeobj.setLoc(get_turf(src))

/mob/living/silicon/ai/attack_ai(var/mob/user)
	ai_camera_list()

/mob/living/proc/near_camera()
	if (!isturf(loc))
		return 0
	else if(!cameranet.is_visible(src))
		return 0
	return 1

/mob/living/proc/tracking_status()
	// Easy checks first.
	var/obj/item/card/id/id = GetIdCard()
	if(id && id.prevent_tracking())
		return TRACKING_TERMINATE
	if(InvalidPlayerTurf(get_turf(src)))
		return TRACKING_TERMINATE
	if(invisibility >= INVISIBILITY_LEVEL_ONE) //cloaked
		return TRACKING_TERMINATE
	if(digitalcamo)
		return TRACKING_TERMINATE
	if(istype(loc,/obj/effect/dummy))
		return TRACKING_TERMINATE

	 // Now, are they viewable by a camera? (This is last because it's the most intensive check)
	return near_camera() ? TRACKING_POSSIBLE : TRACKING_NO_COVERAGE

/mob/living/silicon/robot/tracking_status()
	. = ..()
	if(. == TRACKING_NO_COVERAGE)
		var/datum/extension/network_device/camera/robot/D = get_extension(src, /datum/extension/network_device)
		return D && D.is_functional() ? TRACKING_POSSIBLE : TRACKING_NO_COVERAGE

/mob/living/human/tracking_status()
	if(is_cloaked())
		. = TRACKING_TERMINATE
	else
		. = ..()

	if(. == TRACKING_TERMINATE)
		return

	if(. == TRACKING_NO_COVERAGE)
		var/turf/T = get_turf(src)
		if(T && isStationLevel(T.z) && hassensorlevel(src, VITALS_SENSOR_TRACKING))
			return TRACKING_POSSIBLE

/mob/living/proc/tracking_initiated()

/mob/living/silicon/robot/tracking_initiated()
	tracking_entities++
	if(tracking_entities == 1 && has_zeroth_law())
		to_chat(src, SPAN_WARNING("Internal camera is currently being accessed."))

/mob/living/proc/tracking_cancelled()

/mob/living/silicon/robot/tracking_cancelled()
	tracking_entities--
	if(!tracking_entities && has_zeroth_law())
		to_chat(src, SPAN_NOTICE("Internal camera is no longer being accessed."))


#undef TRACKING_POSSIBLE
#undef TRACKING_NO_COVERAGE
#undef TRACKING_TERMINATE
