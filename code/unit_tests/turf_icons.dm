/datum/unit_test/turf_floor_icons_shall_be_valid
	name = "TURF ICONS: Floors Shall Have All Required Icon States"
	var/turf/floor/floor
	var/original_type

/datum/unit_test/turf_floor_icons_shall_be_valid/start_test()

	if(!isturf(floor))
		fail("Unable to locate an appropriate turf at [world.maxx],[world.maxy],1.")
		return 1

	var/list/failures = list()
	for(var/floor_type in typesof(/turf/floor))
		var/turf/floor/check_floor = floor_type
		if(TYPE_IS_ABSTRACT(check_floor))
			continue
		floor = floor.ChangeTurf(floor_type, FALSE, FALSE, FALSE, FALSE, FALSE)
		if(istype(floor))
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

/datum/unit_test/turf_floor_icons_shall_be_valid/teardown_test()

	. = ..()

	if(isturf(floor))
		REMOVE_ACTIVE_FLUID(floor)
		SSair.tiles_to_update    -= floor
		SSairflow.processing     -= floor
		SSoverlays.processing    -= floor
		SSicon_update.queue_refs -= floor
		AMBIENCE_UNQUEUE_TURF(floor)
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

// Procs used for validation below.
/turf/floor/proc/validate_turf()
	. = list()
	if(isnull(icon))
		. += "null icon"
	if(!istext(icon_state))
		. += "null or invalid icon_state '[icon_state]'"
	if(icon && icon_state && !check_state_in_icon(icon_state, icon))
		. += "missing initial icon_state '[icon_state]' from '[icon]"
	if(base_icon)
		if(!istext(base_icon_state))
			. += "base_icon set, but null or invalid base_icon_state set: '[base_icon_state]'"
		else if(!check_state_in_icon(base_icon_state, base_icon))
			. += "base_icon_state '[base_icon_state]' not found in base_icon '[base_icon]'"
	else if(base_icon_state)
		. += "null base_icon but base_icon_state set"

/turf/floor/natural/validate_turf()
	. = ..()
	if(icon_edge_layer != -1 && !isnum(icon_edge_layer))
		. += "invalid icon_edge_layer '[icon_edge_layer]'"

	if(icon && icon_state)
		if(possible_states)
			for(var/i = 0 to possible_states)
				if(!check_state_in_icon(num2text(i), icon))
					. += "missing icon_state [i] from icon '[icon]'"

		if(icon_edge_layer >= 0)
			for(var/checkdir in (icon_has_corners ? global.alldirs : global.cardinal))
				if(icon_edge_states)
					for(var/i = 0 to icon_edge_states)
						var/check_state = "edge[checkdir][i]"
						if(!check_state_in_icon(check_state, icon))
							. += "missing edge state '[check_state]' in icon '[icon]'"
				var/check_state = "edge[checkdir]"
				if(!check_state_in_icon(check_state, icon))
					. += "missing edge state '[check_state]' in icon '[icon]'"
