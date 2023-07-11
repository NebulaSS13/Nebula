/datum/unit_test/icon_test
	name = "ICON STATE template"
	template = /datum/unit_test/icon_test
/datum/unit_test/icon_test/sprite_accessories_shall_have_existing_icon_states
	name = "ICON STATE - Sprite accessories shall have existing icon states"

/datum/unit_test/icon_test/sprite_accessories_shall_have_existing_icon_states/start_test()
	var/sprite_accessory_subtypes = list(
		/decl/sprite_accessory/hair,
		/decl/sprite_accessory/facial_hair
	)

	var/list/failed_sprite_accessories = list()
	var/icon_state_cache = list()
	var/duplicates_found = FALSE

	for(var/sprite_accessory_main_type in sprite_accessory_subtypes)
		var/sprite_accessories_by_name = list()
		for(var/sprite_accessory_type in subtypesof(sprite_accessory_main_type))
			var/failed = FALSE
			var/decl/sprite_accessory/sat = sprite_accessory_type
			var/sat_name = initial(sat.name)
			if(sat_name)
				group_by(sprite_accessories_by_name, sat_name, sat)
			else
				failed = TRUE
				log_bad("[sat] - Did not have a name set.")

			var/sat_icon = initial(sat.icon)
			if(sat_icon)
				var/sat_icon_states = icon_state_cache[sat_icon]
				if(!sat_icon_states)
					sat_icon_states = icon_states(sat_icon)
					icon_state_cache[sat_icon] = sat_icon_states

				var/sat_icon_state = initial(sat.icon_state)
				if(sat_icon_state)
					sat_icon_state = "[sat_icon_state]_s"
					if(!(sat_icon_state in sat_icon_states))
						failed = TRUE
						log_bad("[sat] - \"[sat_icon_state]\" did not exist in '[sat_icon]'.")
				else
					failed = TRUE
					log_bad("[sat] - Did not have an icon state set.")
			else
				failed = TRUE
				log_bad("[sat] - Did not have an icon set.")

			if(failed)
				failed_sprite_accessories += sat

		if(number_of_issues(sprite_accessories_by_name, "Sprite Accessory Names"))
			duplicates_found = TRUE

	if(failed_sprite_accessories.len || duplicates_found)
		fail("One or more sprite accessory issues detected.")
	else
		pass("All sprite accessories were valid.")

	return 1

/datum/unit_test/icon_test/posters_shall_have_icon_states
	name = "ICON STATE - Posters Shall Have Icon States"

/datum/unit_test/icon_test/posters_shall_have_icon_states/start_test()
	var/contraband_icons = icon_states('icons/obj/contraband.dmi')
	var/list/invalid_posters = list()

	var/list/all_posters = decls_repository.get_decls_of_subtype(/decl/poster_design)
	for(var/poster_design in all_posters)
		var/decl/poster_design/P = all_posters[poster_design]
		if(!(P.icon_state in contraband_icons))
			invalid_posters += poster_design

	if(invalid_posters.len)
		fail("/decl/poster_design with missing icon states: [english_list(invalid_posters)]")
	else
		pass("All /decl/poster_design subtypes have valid icon states.")
	return 1

/datum/unit_test/icon_test/item_modifiers_shall_have_icon_states
	name = "ICON STATE - Item Modifiers Shall Have Icon Sates"
	var/list/icon_states_by_type

/datum/unit_test/icon_test/item_modifiers_shall_have_icon_states/start_test()
	var/list/bad_modifiers = list()
	var/item_modifiers = list_values(decls_repository.get_decls(/decl/item_modifier))

	for(var/im in item_modifiers)
		var/decl/item_modifier/item_modifier = im
		for(var/type_setup_type in item_modifier.type_setups)
			var/list/type_setup = item_modifier.type_setups[type_setup_type]
			var/list/icon_states = icon_states_by_type[type_setup_type]

			if(!icon_states)
				var/obj/item/I = type_setup_type
				icon_states = icon_states(initial(I.icon))
				LAZYSET(icon_states_by_type, type_setup_type, icon_states)

			if(!(type_setup["icon_state"] in icon_states))
				bad_modifiers += type_setup_type

	if(bad_modifiers.len)
		fail("Item modifiers with missing icon states: [english_list(bad_modifiers)]")
	else
		pass("All item modifiers have valid icon states.")
	return 1

/datum/unit_test/icon_test/signs_shall_have_existing_icon_states
	name = "ICON STATE - Signs shall have existing icon states"

/datum/unit_test/icon_test/signs_shall_have_existing_icon_states/start_test()
	var/list/failures = list()
	for(var/sign_type in typesof(/obj/structure/sign))
		var/obj/structure/sign/sign = sign_type
		if(TYPE_IS_ABSTRACT(sign))
			continue
		var/check_state = initial(sign.icon_state)
		if(!check_state)
			failures += "[sign] - null icon_state"
			continue
		var/check_icon = initial(sign.icon)
		if(!check_icon)
			failures += "[sign] - null icon_state"
			continue
		if(!check_state_in_icon(check_state, check_icon, TRUE))
			failures += "[sign] - missing icon_state '[check_state]' in icon '[check_icon]"
	if(failures.len)
		fail("Signs with missing icon states: [english_list(failures)]")
	else
		pass("All signs have valid icon states.")
	return 1

/datum/unit_test/icon_test/floor_decals_shall_have_existing_icon_states
	name = "ICON STATE - Floor decals shall have existing icon states"
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
		if(!check_state_in_icon(check_state, check_icon, TRUE))
			failures += "[decal] - missing icon_state '[check_state]' in icon '[check_icon]"
	if(failures.len)
		fail("Decals with missing icon states: [english_list(failures)]")
	else
		pass("All decals have valid icon states.")
	return 1
