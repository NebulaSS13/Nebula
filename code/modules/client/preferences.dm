#define SAVE_RESET -1

/* PLACEHOLDER VERB UNTIL SAVE INIT (or whatever the issue is) IS FIXED */
var/list/time_prefs_fixed = list()
/client/verb/fix_preferences()
	set name = "Reload Preferences"
	set category = "OOC"
	if(world.time < global.time_prefs_fixed[ckey])
		to_chat(usr, SPAN_WARNING("Your character preferences should have already been loaded. If they are still not loaded, please wait a minute and try again, or inform the developers."))
		return
	global.time_prefs_fixed[ckey] = world.time + (1 MINUTE)
	SScharacter_setup.preferences_datums -= ckey
	QDEL_NULL(prefs)
	to_chat(src, SPAN_DANGER("<font size = '3'>Your cached preferences have been cleared, please reconnect to the server to reload your characters.</font>"))
	sleep(1 SECOND)
	del(src)
/* END PLACEHOLDER VERB */

/datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change

	//Mob preview
	var/list/char_render_holders		//Should only be a key-value list of north/south/east/west = obj/screen.
	var/static/list/preview_screen_locs = list(
		"1" = "character_preview_map:1,5:-12",
		"2" = "character_preview_map:1,3:15",
		"4"  = "character_preview_map:1,2:10",
		"8"  = "character_preview_map:1,1:5",
		"BG" = "character_preview_map:1,1 to 1,5"
	)

	var/client/client = null
	var/client_ckey = null

	var/savefile/loaded_preferences
	var/savefile/loaded_character
	var/datum/category_collection/player_setup_collection/player_setup
	var/datum/browser/panel

/datum/preferences/New(client/C)
	if(istype(C))
		client = C
		client_ckey = C.ckey
		SScharacter_setup.preferences_datums[C.ckey] = src
		if(SScharacter_setup.initialized)
			setup()
		else
			SScharacter_setup.prefs_awaiting_setup += src
	..()

/datum/preferences/Destroy()
	. = ..()
	QDEL_LIST_ASSOC_VAL(char_render_holders)

/datum/preferences/proc/setup()
	if(!length(GLOB.skills))
		GET_DECL(/decl/hierarchy/skill)
	player_setup = new(src)
	gender = pick(MALE, FEMALE)
	real_name = get_random_name()
	b_type = RANDOM_BLOOD_TYPE

	if(client && !IsGuestKey(client.key))
		load_path(client.ckey)
		load_preferences()
		load_and_update_character()
	sanitize_preferences()
	if(client && istype(client.mob, /mob/new_player))
		var/mob/new_player/np = client.mob
		np.show_lobby_menu(TRUE)

/datum/preferences/proc/load_and_update_character(var/slot)
	load_character(slot)
	if(update_setup(loaded_preferences, loaded_character))
		SScharacter_setup.queue_preferences_save(src)
		save_character()

/datum/preferences/proc/ShowChoices(mob/user)
	if(!SScharacter_setup.initialized)
		return
	if(!user || !user.client)
		return

	if(!get_mob_by_key(client_ckey))
		to_chat(user, "<span class='danger'>No mob exists for the given client!</span>")
		close_load_dialog(user)
		return

	if(!char_render_holders)
		update_preview_icon()
	show_character_previews()

	var/dat = "<html><body><center>"

	if(path)
		dat += "Slot - "
		dat += "<a href='?src=\ref[src];load=1'>Load slot</a> - "
		dat += "<a href='?src=\ref[src];save=1'>Save slot</a> - "
		dat += "<a href='?src=\ref[src];resetslot=1'>Reset slot</a> - "
		dat += "<a href='?src=\ref[src];reload=1'>Reload slot</a>"

	else
		dat += "Please create an account to save your preferences."

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)

	dat += "</html></body>"
	winshow(user, "preferences_window", TRUE)
	var/datum/browser/popup = new(user, "preferences_browser", "Character Setup", 800, 800)
	popup.set_content(dat)
	popup.open(FALSE) // Skip registring onclose on the browser pane
	onclose(user, "preferences_window", src) // We want to register on the window itself

/datum/preferences/proc/update_character_previews(mutable_appearance/MA)
	if(!client)
		return

	var/obj/screen/setup_preview/bg/BG = LAZYACCESS(char_render_holders, "BG")
	if(!BG)
		BG = new
		BG.icon = 'icons/effects/32x32.dmi'
		BG.pref = src
		LAZYSET(char_render_holders, "BG", BG)
		client.screen |= BG
	BG.icon_state = bgstate
	BG.screen_loc = preview_screen_locs["BG"]

	for(var/D in GLOB.cardinal)
		var/obj/screen/setup_preview/O = LAZYACCESS(char_render_holders, "[D]")
		if(!O)
			O = new
			O.pref = src
			LAZYSET(char_render_holders, "[D]", O)
			client.screen |= O
		O.appearance = MA
		O.dir = D
		O.screen_loc = preview_screen_locs["[D]"]

/datum/preferences/proc/show_character_previews()
	if(!client || !char_render_holders)
		return
	for(var/render_holder in char_render_holders)
		client.screen |= char_render_holders[render_holder]

/datum/preferences/proc/clear_character_previews()
	for(var/index in char_render_holders)
		var/obj/screen/S = char_render_holders[index]
		client?.screen -= S
		qdel(S)
	char_render_holders = null

/datum/preferences/proc/process_link(mob/user, list/href_list)

	if(!user)	return
	if(isliving(user)) return

	if(href_list["preference"] == "open_whitelist_forum")
		if(config.forumurl)
			user << link(config.forumurl)
		else
			to_chat(user, "<span class='danger'>The forum URL is not set in the server configuration.</span>")
			return
	ShowChoices(usr)
	return 1

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["save"])
		save_preferences()
		save_character()
	else if(href_list["reload"])
		load_preferences()
		load_character()
		sanitize_preferences()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		sanitize_preferences()
		close_load_dialog(usr)

		if(isnewplayer(client.mob))
			var/mob/new_player/M = client.mob
			M.show_lobby_menu()

	else if(href_list["resetslot"])
		if(real_name != input("This will reset the current slot. Enter the character's full name to confirm."))
			return 0
		load_character(SAVE_RESET)
		sanitize_preferences()
	else if(href_list["close"])
		// User closed preferences window, cleanup anything we need to.
		clear_character_previews()
		return 1
	else
		return 0

	ShowChoices(usr)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, is_preview_copy = FALSE)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()
	character.set_species(species)

	if(be_random_name)
		var/decl/cultural_info/culture = GET_DECL(cultural_info[TAG_CULTURE])
		if(culture) real_name = culture.get_random_name(gender)

	if(config.humans_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(GLOB.last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(GLOB.last_names)]"

	character.fully_replace_character_name(real_name)

	character.gender = gender
	character.age = age
	character.b_type = b_type

	character.eye_colour = eye_colour

	character.h_style = h_style
	character.hair_colour = hair_colour

	character.f_style = f_style
	character.facial_hair_colour = facial_hair_colour

	character.skin_colour = skin_colour

	character.skin_tone = skin_tone
	character.skin_base = skin_base

	character.h_style = h_style
	character.f_style = f_style

	// Replace any missing limbs.
	for(var/name in global.all_limb_tags)
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O && organ_data[name] != "amputated")
			var/list/organ_data = character.species.has_limbs[name]
			if(!islist(organ_data)) continue
			var/limb_path = organ_data["path"]
			O = new limb_path(character)

	// Destroy/cyborgize organs and limbs. The order is important for preserving low-level choices for robolimb sprites being overridden.
	for(var/name in global.all_limb_tags_by_depth)
		var/status = organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O)
			continue
		O.status = 0
		O.model = null
		if(status == "amputated")
			character.organs_by_name[O.organ_tag] = null
			character.organs -= O
			if(O.children) // This might need to become recursive.
				for(var/obj/item/organ/external/child in O.children)
					character.organs_by_name[child.organ_tag] = null
					character.organs -= child
					qdel(child)
			qdel(O)
		else if(status == "cyborg")
			O.robotize(rlimb_data[name])
		else //normal organ
			O.force_icon = initial(O.force_icon)
			O.SetName(initial(O.name))
			O.desc = initial(O.desc)

	//For species that don't care about your silly prefs
	character.species.handle_limbs_setup(character)
	if(!is_preview_copy)
		for(var/name in list(BP_HEART,BP_EYES,BP_BRAIN,BP_LUNGS,BP_LIVER,BP_KIDNEYS,BP_STOMACH))
			var/status = organ_data[name]
			if(!status)
				continue
			var/obj/item/organ/I = character.get_internal_organ(name)
			if(I)
				if(status == "assisted")
					I.mechassist()
				else if(status == "mechanical")
					I.robotize()

	QDEL_NULL_LIST(character.worn_underwear)
	character.worn_underwear = list()

	for(var/underwear_category_name in all_underwear)
		var/datum/category_group/underwear/underwear_category = GLOB.underwear.categories_by_name[underwear_category_name]
		if(underwear_category)
			var/underwear_item_name = all_underwear[underwear_category_name]
			var/datum/category_item/underwear/UWD = underwear_category.items_by_name[underwear_item_name]
			var/metadata = all_underwear_metadata[underwear_category_name]
			var/obj/item/underwear/UW = UWD.create_underwear(character, metadata)
			if(UW)
				UW.ForceEquipUnderwear(character, FALSE)
		else
			all_underwear -= underwear_category_name

	character.backpack_setup = new(backpack, backpack_metadata["[backpack]"])

	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		O.markings.Cut()

	for(var/M in body_markings)
		var/datum/sprite_accessory/marking/mark_datum = GLOB.body_marking_styles_list[M]
		var/mark_color = "[body_markings[M]]"

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O)
				O.markings[M] = list("color" = mark_color, "datum" = mark_datum)

	character.force_update_limbs()
	character.update_mutations(0)
	character.update_body(0)
	character.update_underwear(0)
	character.update_hair(0)
	character.update_icons()

	if(is_preview_copy)
		return

	for(var/token in cultural_info)
		character.set_cultural_value(token, cultural_info[token], defer_language_update = TRUE)
	character.update_languages()
	for(var/lang in alternate_languages)
		character.add_language(lang)

	character.flavor_texts["general"] = flavor_texts["general"]
	character.flavor_texts["head"] = flavor_texts["head"]
	character.flavor_texts["face"] = flavor_texts["face"]
	character.flavor_texts["eyes"] = flavor_texts["eyes"]
	character.flavor_texts["torso"] = flavor_texts["torso"]
	character.flavor_texts["arms"] = flavor_texts["arms"]
	character.flavor_texts["hands"] = flavor_texts["hands"]
	character.flavor_texts["legs"] = flavor_texts["legs"]
	character.flavor_texts["feet"] = flavor_texts["feet"]

	character.public_record = public_record
	character.med_record = med_record
	character.sec_record = sec_record
	character.gen_record = gen_record
	character.exploit_record = exploit_record

	if(LAZYLEN(character.descriptors))
		for(var/entry in body_descriptors)
			character.descriptors[entry] = body_descriptors[entry]

	if(!character.isSynthetic())
		character.set_nutrition(rand(140,360))
		character.set_hydration(rand(140,360))

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat  = list()
	dat += "<body>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i<= config.character_slots, i++)
			S.cd = GLOB.using_map.character_load_path(S, i)
			S["real_name"] >> name
			if(!name)	name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?src=\ref[src];changeslot=[i]'>[name]</a><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	panel = new(user, "Character Slots", "Character Slots", 300, 390, src)
	panel.set_content(jointext(dat,null))
	panel.open()

/datum/preferences/proc/close_load_dialog(mob/user)
	if(panel)
		panel.close()
		panel = null
	close_browser(user, "window=saves")

/datum/preferences/proc/apply_post_login_preferences()
	set waitfor = 0
	if(!client)
		return
	if(client.get_preference_value(/datum/client_preference/chat_position) == GLOB.PREF_YES)
		client.update_chat_position(TRUE)
	if(client.get_preference_value(/datum/client_preference/fullscreen_mode) != GLOB.PREF_OFF)
		client.toggle_fullscreen(client.get_preference_value(/datum/client_preference/fullscreen_mode))
