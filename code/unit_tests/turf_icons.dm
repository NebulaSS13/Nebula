/datum/unit_test/turf_floor_icons_shall_be_valid
	name = "TURF ICONS: Turfs Shall Have All Required Icon States"
	var/turf/floor/floor
	var/original_type
	var/list/tested_types = list(
		/turf/floor,
		/turf/wall,
		/turf/unsimulated
	)
	var/list/excepted_types = list(
		/turf/unsimulated/map
	)

/datum/unit_test/turf_floor_icons_shall_be_valid/setup_test()

	. = ..()

	// We only care about the base turf icon instance, not updating them etc.
	floor = locate(world.maxx, world.maxy, 1)
	original_type = floor?.type
	SSair.suspend()
	SSairflow.suspend()
	SSfluids.suspend()
	SSicon_update.suspend()
	SSambience.suspend()
	SSoverlays.suspend()
	SSmaterials.suspend()

/datum/unit_test/turf_floor_icons_shall_be_valid/start_test()

	if(!isturf(floor))
		fail("Unable to locate an appropriate turf at [world.maxx],[world.maxy],1.")
		return 1

	var/list/validate_types = list()
	for(var/test_type in tested_types)
		validate_types |= typesof(test_type)
	for(var/test_type in excepted_types)
		validate_types -= typesof(test_type)

	var/list/failures = list()
	for(var/turf/floor_type as anything in validate_types)
		if(TYPE_IS_ABSTRACT(floor_type))
			continue
		floor = floor.ChangeTurf(floor_type, FALSE, FALSE, FALSE, FALSE, FALSE)
		if(istype(floor, floor_type))
			var/list/turf_failures = floor.validate_turf()
			if(length(turf_failures))
				failures[floor_type] = turf_failures
		else
			failures[floor_type] = list("failed to change base turf to type")

	if(length(failures))
		var/list/fail_strings = list()
		for(var/failed_type in failures)
			fail_strings += "[failed_type]:\n- [jointext(failures[failed_type], "\n- ")]"
		fail("[length(failures)] floor types were missing icon_states:\n[jointext(fail_strings, "\n")]")
	else
		pass("All floor types had all required icon_states.")
	return 1

/datum/unit_test/turf_floor_icons_shall_be_valid/teardown_test()

	. = ..()

	if(isturf(floor))
		REMOVE_ACTIVE_FLUID(floor)
		SSair.tiles_to_update    -= floor
		SSairflow.processing     -= floor
		SSoverlays.processing    -= floor
		SSicon_update.queue_refs -= floor
		AMBIENCE_DEQUEUE_TURF(floor)
		if(floor.reagents)
			floor.reagents.clear_reagents()
			SSmaterials.active_holders -= floor.reagents
		if(!istype(floor, original_type))
			floor.ChangeTurf(original_type)

	floor = null
	SSair.wake()
	SSairflow.wake()
	SSfluids.wake()
	SSicon_update.wake()
	SSambience.wake()
	SSoverlays.wake()
	SSmaterials.wake()

/turf/proc/validate_turf()
	SHOULD_CALL_PARENT(TRUE)
	. = list()
	if(isnull(icon))
		. += "null icon"
	if(!istext(icon_state))
		. += "null or invalid icon_state '[icon_state]'"
	if(icon && icon_state && !check_state_in_icon(icon_state, icon))
		. += "missing initial icon_state '[icon_state]' from '[icon]'"

/turf/wall/proc/get_turf_validation_single_states()
	return list(
		"fwall_open",
		"blank"
	)

// TODO: add some support to 'simple' walls for falsewalls?
/turf/wall/brick/get_turf_validation_single_states()
	return list(
		"blank"
	)

/turf/wall/log/get_turf_validation_single_states()
	return list(
		"blank"
	)

/turf/wall/natural/get_turf_validation_single_states()
	return list(
		"blank",
		"ramp-single",
		"ramp-blend-full",
		"ramp-blend-left",
		"ramp-blend-right",
		"ramp-single-shine",
		"ramp-blend-full-shine",
		"ramp-blend-left-shine",
		"ramp-blend-right-shine"
	)

/turf/wall/proc/get_turf_validation_corner_states()
	. = list("")
	if(!material)
		CRASH("[type] lacks a material!")
	if(material?.wall_flags & WALL_HAS_EDGES)
		. |= "other"
	if(paint_color || (material?.wall_flags & PAINT_PAINTABLE))
		. |= "paint"
	if(stripe_color || (material?.wall_flags & PAINT_STRIPABLE))
		. |= "stripe"

/turf/wall/natural/get_turf_validation_corner_states()
	return list("", "shine")

/turf/wall/log/get_turf_validation_corner_states()
	return list("", "other")

/turf/wall/validate_turf()

	// Walls generate their own icons, icon/icon_state are largely irrelevant other than map previews.
	SHOULD_CALL_PARENT(FALSE)
	. = ..()

	// Check our in-mapper preview icons.
	var/preview_icon = initial(icon)
	if(isnull(preview_icon))
		. += "null initial icon"
	var/preview_icon_state = initial(icon_state)
	if(!istext(preview_icon_state))
		. += "null or invalid initial icon_state '[preview_icon_state]'"
	if(preview_icon && preview_icon_state && !check_state_in_icon(preview_icon_state, preview_icon))
		. += "missing initial initial icon_state '[preview_icon_state]' from '[preview_icon]'"

	// Check for shutters, if this wall expects to have one.
	if(!isnull(shutter_state))
		if(isnull(shutter_icon))
			. += "shutter state is non-null but missing shutter icon"
		else
			var/static/list/shutter_states = list("0", "1", "glow")
			for(var/check_shutter_state in shutter_states)
				if(!check_state_in_icon(check_shutter_state, shutter_icon))
					. += "shutter state '[check_shutter_state]' missing from shutter icon '[shutter_icon]'"

	// Check that our wall icon has all appropriate corner states and overlays.
	var/wall_icon = get_wall_icon()
	if(!wall_icon)
		. += "missing wall_icon"
	else
		// Check for false wall animations and states.
		// didn't we used to have more of these?
		for(var/false_wall_state in get_turf_validation_single_states())
			if(!check_state_in_icon(false_wall_state, wall_icon))
				. += "missing wall icon_state '[false_wall_state]' from icon '[wall_icon]'"

		for(var/wall_icon_state in get_turf_validation_corner_states())
			for(var/blend_index = 0 to 7)
				var/test_state = "[wall_icon_state][blend_index]"
				if(!check_state_in_icon(test_state, wall_icon))
					. += "missing blend state '[test_state]' from icon '[wall_icon]'"

// Procs used for validation below.
/turf/floor/validate_turf()
	. = ..()

	if(!istype(_base_flooring))
		. += "null or invalid _base_flooring ([_base_flooring || "NULL"])"
	if(_flooring && !islist(_flooring) && !istype(_flooring, /decl/flooring))
		. += "invalid post-init type for _flooring ([_flooring || "NULL"])"

	var/decl/flooring/check_flooring = get_topmost_flooring()

	var/initial_floor_broken = initial(_floor_broken)
	if(initial_floor_broken)
		if(!istype(check_flooring))
			. += "non-null initial _floor_broken, but no valid flooring found"
		else if(!length(check_flooring.broken_states))
			. += "non-null initial _floor_broken, but no flooring broken states found in [check_flooring]"
		else if(istext(initial_floor_broken))
			if(!(initial_floor_broken in check_flooring.broken_states))
				. += "non-null initial _floor_broken not found in [check_flooring] broken states"
		else if(initial_floor_broken != TRUE)
			. += "non-TRUE, non-null, non-text initial _floor_broken value."

	var/initial_floor_burned = initial(_floor_burned)
	if(initial_floor_burned)
		if(!istype(check_flooring))
			. += "non-null initial _floor_burned, but no valid flooring found"
		else if(!length(check_flooring.burned_states))
			. += "non-null initial _floor_burned, but no flooring burned states found in [check_flooring]"
		else if(istext(initial_floor_burned))
			if(!(initial_floor_burned in check_flooring.burned_states))
				. += "non-null initial _floor_burned not found in [check_flooring] burned states"
		else if(initial_floor_burned != TRUE)
			. += "non-TRUE, non-null, non-text initial _floor_burned value."

