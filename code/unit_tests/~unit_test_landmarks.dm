/obj/effect/landmark/test/safe_turf
	name = "safe_turf"
	desc = "A safe turf should be an as large block as possible of livable, passable turfs, preferably at least 3x3 with the marked turf as the center"
	flags = LANDMARK_IS_UNIQUE | LANDMARK_IS_MANDATORY | LANDMARK_HAS_UNIQUE_AREA

/obj/effect/landmark/test/space_turf
	name = "space_turf"
	desc = "A space turf should be an as large block as possible of space, preferably at least 3x3 with the marked turf as the center"
	flags = LANDMARK_IS_UNIQUE | LANDMARK_IS_MANDATORY | LANDMARK_HAS_UNIQUE_AREA

/obj/effect/landmark/test/west
	name = "west side"
	desc = "The west turf of a 2x1 area"
	flags = LANDMARK_IS_UNIQUE | LANDMARK_IS_MANDATORY

/obj/effect/landmark/test/east
	name = "east side"
	desc = "The east turf of a 2x1 area"
	flags = LANDMARK_IS_UNIQUE | LANDMARK_IS_MANDATORY

/obj/effect/landmark/test/virtual_spawn/one
	flags = LANDMARK_IS_UNIQUE | LANDMARK_IS_MANDATORY
/obj/effect/landmark/test/virtual_spawn/two
	flags = LANDMARK_IS_UNIQUE | LANDMARK_IS_MANDATORY
/obj/effect/landmark/test/virtual_spawn/three
	flags = LANDMARK_IS_UNIQUE | LANDMARK_IS_MANDATORY

/datum/unit_test/proc/get_safe_turf()
	check_cleanup = TRUE
	if(!safe_landmark)
		safe_landmark = locate(/obj/effect/landmark/test/safe_turf)
	return get_turf(safe_landmark)

/datum/unit_test/proc/get_space_turf()
	check_cleanup = TRUE
	if(!space_landmark)
		space_landmark = locate(/obj/effect/landmark/test/space_turf)
	return get_turf(space_landmark)
