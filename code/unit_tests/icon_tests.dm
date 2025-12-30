/datum/unit_test/icon_test
	name = "ICON STATE template"
	abstract_type = /datum/unit_test/icon_test

/datum/unit_test/icon_test/food_shall_have_icon_states
	name = "ICON STATE: Food And Drink Subtypes Shall Have Icon States"
	var/list/check_types = list(
		/obj/item/chems/condiment,
		/obj/item/chems/drinks,
		/obj/item/food
	)
	// We skip lumps because they are invisible, they are only ever inside utensils.
	var/list/skip_types = list(/obj/item/food/lump)

/datum/unit_test/icon_test/food_shall_have_icon_states/proc/assemble_skipped_types()
	skip_types |= typesof(/obj/item/food/grown)
	skip_types |= typesof(/obj/item/food/processed_grown)

/datum/unit_test/icon_test/food_shall_have_icon_states/start_test()

	assemble_skipped_types()

	var/list/failures = list()
	for(var/check_type in check_types)
		for(var/check_subtype in typesof(check_type))
			var/obj/item/thing = check_subtype
			if(TYPE_IS_ABSTRACT(thing))
				continue
			var/skip = FALSE
			for(var/skip_type in skip_types)
				if(ispath(check_subtype, skip_type))
					skip = TRUE
					break
			if(skip)
				continue
			thing = atom_info_repository.get_instance_of(thing)
			if(!istype(thing) || QDELETED(thing))
				failures += "invalid instance ([check_subtype])"
			else
				if(!thing.icon)
					failures += "null icon ([check_subtype])"
				if(!istext(thing.icon_state))
					failures += "null or invalid icon_state ([check_subtype])"
				else if(!check_state_in_icon(thing.icon_state, thing.icon))
					failures += "missing icon state '[thing.icon_state]' in icon '[thing.icon]' ([check_subtype])"

	if(length(failures))
		fail("Food subtypes had missing icons or icon states:\n[jointext(failures, "\n")].")
	else
		pass("All food subtypes had valid icon states.")
	return 1

/datum/unit_test/icon_test/turfs_shall_have_icon_states
	name = "ICON STATE: Turf Subtypes Shall Have Icon States"
	var/list/except_types = list(
		/turf/mimic_edge,
		/turf/open
	)

/datum/unit_test/icon_test/turfs_shall_have_icon_states/start_test()
	var/list/failures = list()
	for(var/turf_type in subtypesof(/turf))
		var/turf/turf_prototype = turf_type
		if(TYPE_IS_ABSTRACT(turf_prototype))
			continue
		var/excepted = FALSE
		for(var/exception_path in except_types)
			if(ispath(turf_type, exception_path))
				excepted = TRUE
				break
		if(excepted)
			continue
		var/test_icon_state = initial(turf_prototype.icon_state)
		var/test_icon = initial(turf_prototype.icon)
		if(isnull(test_icon_state))
			failures += "[turf_prototype] - null icon state"
		if(!test_icon)
			failures += "[turf_prototype] - null icon"
		if(!isnull(test_icon_state) && test_icon && !check_state_in_icon(test_icon_state, test_icon))
			failures += "[turf_prototype] - state [test_icon_state] not in icon [test_icon]"
	if(length(failures))
		fail("Turf subtypes had missing icons or icon states:\n[jointext(failures, "\n")].")
	else
		pass("All turf subtypes had valid icon states.")
	return 1

/datum/unit_test/icon_test/signs_shall_have_existing_icon_states
	name = "ICON STATE: Signs shall have existing icon states"
	var/list/skip_types = list(
		// Posters use a decl to set their icon and handle their own validation.
		/obj/structure/sign/poster
	)

/datum/unit_test/icon_test/signs_shall_have_existing_icon_states/start_test()
	var/list/failures = list()
	for(var/sign_type in typesof(/obj/structure/sign))

		var/obj/structure/sign/sign = sign_type
		if(TYPE_IS_ABSTRACT(sign))
			continue

		var/skip = FALSE
		for(var/skip_type in skip_types)
			if(ispath(sign_type, skip_type))
				skip = TRUE
				break
		if(skip)
			continue

		var/check_state = initial(sign.icon_state)
		if(!check_state)
			failures += "[sign] - null icon_state"
			continue
		var/check_icon = initial(sign.icon)
		if(!check_icon)
			failures += "[sign] - null icon_state"
			continue
		if(!check_state_in_icon(check_state, check_icon))
			failures += "[sign] - missing icon_state '[check_state]' in icon '[check_icon]"
	if(failures.len)
		fail("Signs with missing icon states:\n\t-[jointext(failures, "\n\t-")]")
	else
		pass("All signs have valid icon states.")
	return 1

/datum/unit_test/icon_test/random_spawners_shall_have_existing_icon_states
	name = "ICON STATE: Random spawners shall have existing icon states"

/datum/unit_test/icon_test/random_spawners_shall_have_existing_icon_states/start_test()
	var/list/failures = list()
	for(var/test_type in subtypesof(/obj/random))
		var/obj/random/prototype = test_type
		if(TYPE_IS_ABSTRACT(prototype))
			continue
		var/test_icon = initial(prototype.icon)
		if(!test_icon)
			failures += "[test_type] - no icon"
		var/test_icon_state = initial(prototype.icon_state)
		if(!test_icon_state)
			failures += "[test_type] - no icon_state"
		if(test_icon_state && test_icon && !check_state_in_icon(test_icon_state, test_icon))
			failures += "[test_type] - icon_state [test_icon_state] not present in [test_icon]"
	if(length(failures))
		fail("Some random spawners have an invalid icon state:\n[jointext(failures, "\n")]")
	else
		pass("All random spawners had a valid icon state.")
	return 1

/datum/unit_test/icon_test/floor_decals_shall_have_existing_icon_states
	name = "ICON STATE: Floor decals shall have existing icon states"
	var/static/list/excepted_types = list(
		/obj/effect/floor_decal/reset,
		/obj/effect/floor_decal/undo
	)
/datum/unit_test/icon_test/floor_decals_shall_have_existing_icon_states/start_test()
	var/list/failures = list()
	for(var/decal_type in typesof(/obj/effect/floor_decal))
		var/obj/effect/floor_decal/decal = decal_type
		if(TYPE_IS_ABSTRACT(decal) || is_path_in_list(decal_type, excepted_types))
			continue
		var/check_state = initial(decal.icon_state)
		if(!check_state)
			failures += "[decal] - null icon_state"
			continue
		var/check_icon = initial(decal.icon)
		if(!check_icon)
			failures += "[decal] - null icon_state"
			continue
		if(!check_state_in_icon(check_state, check_icon))
			failures += "[decal] - missing icon_state '[check_state]' in icon '[check_icon]"
	if(failures.len)
		fail("Decals with missing icon states:\n\t-[jointext(failures, "\n\t-")]")
	else
		pass("All decals have valid icon states.")
	return 1

/datum/unit_test/icon_test/bgstate
	name = "ICON STATE: Character Previews Will Have Background States"

/datum/unit_test/icon_test/bgstate/start_test()
	var/obj/screen/setup_preview/preview = /obj/screen/setup_preview
	var/test_icon = initial(preview.icon)
	if(!test_icon)
		fail("Missing test icon.")
		return 1

	var/list/check_icons = list('icons/effects/128x48.dmi') // pAI preview
	check_icons |= test_icon

	var/list/failures = list()
	for(var/bgicon in check_icons)
		for(var/bgstate in global.using_map.char_preview_bgstate_options)
			if(!check_state_in_icon(bgstate, bgicon))
				failures += "[bgicon] - [bgstate]"

	if(failures.len)
		fail("Missing preview background icon states:\n\t-[jointext(failures, "\n\t-")]")
	else
		pass("All preview icons have all background icon states.")
	return 1

/datum/unit_test/icon_test/smartfridges
	name = "ICON STATE: Smartfridges Will Have All Needed Icon States"

/datum/unit_test/icon_test/smartfridges/start_test()
	var/list/failures = list()
	var/list/test_icons = list()
	var/list/test_contents_overlays = list()
	for(var/obj/machinery/smartfridge/fridge as anything in typesof(/obj/machinery/smartfridge))
		if(TYPE_IS_ABSTRACT(fridge) || !fridge::simulated)
			continue
		var/fridge_icon = fridge::icon
		if(fridge_icon)
			test_icons |= fridge_icon
		else
			failures += "[fridge] has null icon"
		var/fridge_state = fridge::icon_state
		if(fridge_state != ICON_STATE_WORLD)
			failures += "[fridge] has non-world icon_state '[fridge_state]'"
		var/fridge_contents_icon = fridge::overlay_contents_icon
		if(fridge_contents_icon)
			test_contents_overlays |= fridge_contents_icon

	for(var/test_icon in test_icons)
		var/static/list/fridge_states = list(
			"world",
			"world-vend",
			"world-deny",
			"world-off",
			"world-broken",
			"world-panel",
			"world-top",
			"world-top-broken",
			"world-broken",
			"world-sidepanel",
			"world-sidepanel-broken"
		)
		for(var/test_state in fridge_states)
			if(!check_state_in_icon(test_state, test_icon))
				failures += "[test_icon] missing icon_state [test_state]"

	for(var/test_icon in test_contents_overlays)
		var/static/list/test_overlays = list(
			"empty",
			"1",
			"2",
			"3",
			"4",
			"empty-off",
			"1-off",
			"2-off",
			"3-off",
			"4-off"
		)
		for(var/test_overlay in test_overlays)
			if(!check_state_in_icon(test_overlay, test_icon))
				failures += "[test_icon] missing overlay [test_overlay]"

	if(length(failures))
		fail("Missing smartfridge icons or icon states:\n\t-[jointext(failures, "\n\t-")]")
	else
		pass("All smartfridges have all icons and icon states.")
	return 1

/datum/unit_test/icon_test/vendors
	name = "ICON STATE: Vending Machines Will Have All Needed Icon States"

/datum/unit_test/icon_test/vendors/start_test()
	var/list/failures = list()
	var/list/test_icons = list()

	for(var/obj/machinery/vending/vendor as anything in typesof(/obj/machinery/vending))
		if(TYPE_IS_ABSTRACT(vendor) || !vendor::simulated)
			continue
		var/vendor_icon = vendor::icon
		if(vendor_icon)
			test_icons |= vendor_icon
		else
			failures += "[vendor] has null icon"
		var/vendor_state = vendor::icon_state
		if(vendor_state != ICON_STATE_WORLD)
			failures += "[vendor] has non-world icon_state '[vendor_state]'"

	for(var/test_icon in test_icons)
		var/static/list/vendor_states = list(
			"world",
			"world-vend",
			"world-deny",
			"world-off",
			"world-broken",
			"world-panel",
		)
		for(var/test_state in vendor_states)
			if(!check_state_in_icon(test_state, test_icon))
				failures += "[test_icon] missing icon_state [test_state]"

	if(length(failures))
		fail("Missing vendor icons or icon states:\n\t-[jointext(failures, "\n\t-")]")
	else
		pass("All vendors have all icons and icon states.")
	return 1


/datum/unit_test/HUDS_shall_have_icon_states
	name = "ICON STATE: HUD overlays shall have appropriate icon_states"

/datum/unit_test/HUDS_shall_have_icon_states/start_test()
	var/failed_jobs = 0
	var/failed_sanity_checks = 0

	// Throwing implants and health HUDs in here.
	// Antag HUDs are tested by special role validation.

	var/static/list/implant_hud_states = list(
		"hud_imp_blank"    = "Blank",
		"hud_imp_loyal"    = "Loyalty",
		"hud_imp_unknown"  = "Unknown",
		"hud_imp_tracking" = "Tracking",
		"hud_imp_chem"     = "Chemical",
	)
	for(var/implant_hud_state in implant_hud_states)
		if(!check_state_in_icon(implant_hud_state, global.using_map.implant_hud_icons))
			log_bad("Sanity Check - Missing map [implant_hud_states[implant_hud_state]] implant HUD icon_state '[implant_hud_state]' from icon [global.using_map.implant_hud_icons]")
			failed_sanity_checks++

	var/static/list/med_hud_states = list(
		"blank"    = "Blank",
		"flatline" = "Flatline",
		"0"        = "Dead",
		"1"        = "Healthy",
		"2"        = "Lightly injured",
		"3"        = "Moderately injured",
		"4"        = "Severely injured",
		"5"        = "Dying",
	)
	for(var/med_hud_state in med_hud_states)
		if(!check_state_in_icon(med_hud_state, global.using_map.med_hud_icons))
			log_bad("Sanity Check - Missing map [med_hud_states[med_hud_state]] medical HUD icon_state '[med_hud_state]' from icon [global.using_map.med_hud_icons]")
			failed_sanity_checks++
	var/static/list/global_states = list(
		""           = "Default/unnamed",
		"hudunknown" = "Unknown role",
		"hudhealthy" = "Healthy mob",
		"hudill"     = "Diseased mob",
		"huddead"    = "Dead mob"
	)
	for(var/global_state in global_states)
		if(!check_state_in_icon(global_state, global.using_map.hud_icons))
			log_bad("Sanity Check - Missing map [global_states[global_state]] HUD icon_state '[global_state]' from icon [global.using_map.hud_icons]")
			failed_sanity_checks++

	for(var/job_name in SSjobs.titles_to_datums)
		var/datum/job/job = SSjobs.titles_to_datums[job_name]
		if(!check_state_in_icon(job.hud_icon_state, job.hud_icon))
			log_bad("[job.title] - Missing HUD icon: [job.hud_icon_state] in icon [job.hud_icon]")
			failed_jobs++

	if(failed_sanity_checks || failed_jobs)
		fail("[global.using_map.type] - [failed_sanity_checks] failed sanity check\s, [failed_jobs] job\s with missing HUD icon.")
	else
		pass("All jobs have a HUD icon.")
	return 1
