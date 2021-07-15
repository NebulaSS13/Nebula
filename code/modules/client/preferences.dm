#define EQUIP_PREVIEW_LOADOUT 1
#define EQUIP_PREVIEW_JOB 2
#define EQUIP_PREVIEW_ALL (EQUIP_PREVIEW_LOADOUT|EQUIP_PREVIEW_JOB)

#define SAVE_RESET -1

/* PLACEHOLDER VERB UNTIL SAVE INIT (or whatever the issue is) IS FIXED */
var/global/list/time_prefs_fixed = list()
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
	// doohickeys for savefiles
	var/is_guest = FALSE
	// Holder so it doesn't default to slot 1, rather the last one used
	var/default_slot = 1

	// Cache, mapping slot record ids to character names
	// Saves reading all the slot records when listing
	var/list/slot_names = null

	// NON-PREFERENCE STUFF
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	// Populated with an error message if loading fails.
	var/load_failed = null

	//game-preferences
	//Saved changlog filesize to detect if there was a change
	var/lastchangelog = ""

	//Mob preview
	//Should only be a key-value list of north/south/east/west = obj/screen.
	var/list/char_render_holders
	var/static/list/preview_screen_locs = list(
		"1" = "character_preview_map:1,5:-12",
		"2" = "character_preview_map:1,3:15",
		"4"  = "character_preview_map:1,2:10",
		"8"  = "character_preview_map:1,1:5",
		"BG" = "character_preview_map:1,1 to 1,5"
	)

	var/client/client = null
	var/client_ckey = null

	var/datum/category_collection/player_setup_collection/player_setup
	var/datum/browser/panel

/datum/preferences/New(client/C)
	if(istype(C))

		client = C
		client_ckey = C.ckey

		setup_preferences()

	..()

/datum/preferences/Destroy()
	. = ..()
	QDEL_LIST_ASSOC_VAL(char_render_holders)

/datum/preferences/proc/setup()
	if(!length(global.skills))
		GET_DECL(/decl/hierarchy/skill)
	player_setup = new(src)
	gender = pick(MALE, FEMALE)
	real_name = get_random_name()
	b_type = RANDOM_BLOOD_TYPE

	if(client)
		if(IsGuestKey(client.key))
			is_guest = TRUE
		else
			load_data()

	sanitize_preferences()
	update_preview_icon()

/datum/preferences/proc/load_data()
	load_failed = null
	var/stage = "pre"
	try
		var/pref_path = get_path(client_ckey, "preferences")
		if(!fexists(pref_path))
			stage = "migrate"
			// Try to migrate legacy savefile-based preferences
			if(!migrate_legacy_preferences())
				// If there's no old save, there'll be nothing to load.
				return

		stage = "load"
		load_preferences()
		load_character()
	catch(var/exception/E)
		load_failed = "{[stage]} [E]"
		throw E

/datum/preferences/proc/migrate_legacy_preferences()
	// We make some assumptions here:
	// - all relevant savefiles were version 17, which covers anything saved from 2018+
	// - legacy saves were only made on the current map
	// - a maximum of 40 slots were used

	var/legacy_pref_path = get_path(client.ckey, "preferences", "sav")
	if(!fexists(legacy_pref_path))
		return 0

	var/savefile/S = new(legacy_pref_path)
	if(S["version"] != 17)
		return 0

	// Legacy version 17 ~= new version 1
	var/datum/pref_record_reader/dm_savefile/savefile_reader = new(S, 1)

	player_setup.load_preferences(savefile_reader)
	var/orig_slot = default_slot

	// searching for a legacy entry
	for(var/slot = 1 to 40)
		if(!S.dir.Find("character[slot]"))
			continue
		default_slot = slot
		player_setup.load_character(savefile_reader)
		save_character(override_key = "character_[slot]")

	// searching in saved dirs
	for(var/dir in S.dir)
		S.cd = "/[dir]"
		for(var/slot = 1 to 40)
			if(!S.dir.Find("character[slot]"))
				continue
			default_slot = slot
			player_setup.load_character(savefile_reader)
			save_character(override_key = "character_[dir]_[slot]")
			S.cd = "/[dir]"
		S.cd = "/"

	default_slot = orig_slot
	save_preferences()

	return 1

/datum/preferences/proc/get_content(mob/user)
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

	var/dat = list("<center>")
	if(is_guest)
		dat += "Please create an account to save your preferences. If you have an account and are seeing this, please adminhelp for assistance."
	else if(load_failed)
		dat += "Loading your savefile failed. Please adminhelp for assistance."
	else

		dat += "<b>Slot</b> - "
		dat += "<a href='?src=\ref[src];load=1'>Load slot</a> - "
		dat += "<a href='?src=\ref[src];save=1'>Save slot</a> - "
		dat += "<a href='?src=\ref[src];resetslot=1'>Reset slot</a> - "
		dat += "<a href='?src=\ref[src];reload=1'>Reload slot</a><br>"

		dat += "<b>Preview</b> - "
		dat += "<a href='?src=\ref[src];cycle_bg=1'>Cycle background</a> - "
		dat += "<a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"]</a> - "
		dat += "<a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"]</a>"

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)
	return JOINTEXT(dat)

/datum/preferences/proc/open_setup_window(mob/user)
	winshow(user, "preferences_window", TRUE)
	var/datum/browser/popup = new(user, "preferences_browser", "Character Setup", 800, 800)
	var/content = {"
	<script type='text/javascript'>
		function update_content(data){
			document.getElementById('content').innerHTML = data
		}
	</script>
	<html><body>
		<div id='content'>[get_content(user)]</div>
	</body></html>
	"}
	popup.set_content(content)
	popup.open(FALSE) // Skip registring onclose on the browser pane
	onclose(user, "preferences_window", src) // We want to register on the window itself

/datum/preferences/proc/update_setup_window(mob/user)
	send_output(user, url_encode(get_content(user)), "preferences_browser:update_content")

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

	for(var/D in global.cardinal)
		var/obj/screen/setup_preview/O = LAZYACCESS(char_render_holders, "[D]")
		if(!O)
			O = new
			O.pref = src
			LAZYSET(char_render_holders, "[D]", O)
			client.screen |= O
		O.appearance = MA
		O.dir = D
		O.screen_loc = preview_screen_locs["[D]"]
	update_setup_window(usr)

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
	update_setup_window(usr)
	return 1

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return TRUE

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
			return TRUE
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		sanitize_preferences()
		close_load_dialog(usr)

		if(isnewplayer(client.mob))
			var/mob/new_player/M = client.mob
			M.show_lobby_menu()

	else if(href_list["resetslot"])
		if(real_name != input("This will reset the current slot. Enter the character's full name to confirm."))
			return FALSE
		load_character(SAVE_RESET)
		sanitize_preferences()
	else if(href_list["close"])
		// User closed preferences window, cleanup anything we need to.
		clear_character_previews()
		return TRUE
	else if(href_list["toggle_preview_value"])
		equip_preview_mob ^= text2num(href_list["toggle_preview_value"])
	else if(href_list["cycle_bg"])
		bgstate = next_in_list(bgstate, bgstate_options)
	else
		return FALSE

	update_preview_icon()
	update_setup_window(usr)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, is_preview_copy = FALSE)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()
	character.personal_aspects = list()
	character.set_species(species)
	character.set_bodytype((character.species.get_bodytype_by_name(bodytype) || character.species.default_bodytype), TRUE)

	if(be_random_name)
		var/decl/cultural_info/culture = GET_DECL(cultural_info[TAG_CULTURE])
		if(culture) real_name = culture.get_random_name(gender)

	if(config.humans_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(global.last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(global.last_names)]"

	character.fully_replace_character_name(real_name)

	character.set_gender(gender)
	character.b_type = b_type

	character.eye_colour = eye_colour

	character.h_style = h_style
	character.hair_colour = hair_colour

	character.f_style = f_style
	character.facial_hair_colour = facial_hair_colour

	character.skin_colour = skin_colour
	character.skin_tone = skin_tone

	character.h_style = h_style
	character.f_style = f_style

	character.species.handle_limbs_setup(character)

	QDEL_NULL_LIST(character.worn_underwear)
	character.worn_underwear = list()

	for(var/underwear_category_name in all_underwear)
		var/datum/category_group/underwear/underwear_category = global.underwear.categories_by_name[underwear_category_name]
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
		var/datum/sprite_accessory/marking/mark_datum = global.body_marking_styles_list[M]
		var/mark_color = "[body_markings[M]]"

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O)
				O.markings[M] = list("color" = mark_color, "datum" = mark_datum)

	if(LAZYLEN(appearance_descriptors))
		character.appearance_descriptors = appearance_descriptors.Copy()

	character.force_update_limbs()
	character.update_mutations(0)
	character.update_body(0)
	character.update_underwear(0)
	character.update_hair(0)
	character.update_icon()
	character.update_transform()

	if(length(aspects))
		for(var/atype in aspects)
			character.personal_aspects |= GET_DECL(atype)
		character.need_aspect_sort = TRUE
		character.apply_aspects(ASPECTS_PHYSICAL)

	if(is_preview_copy)
		return

	if(length(aspects))
		character.apply_aspects(ASPECTS_MENTAL)

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

	if(!character.isSynthetic())
		character.set_nutrition(rand(140,360))
		character.set_hydration(rand(140,360))

	return character

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat  = list()
	dat += "<body>"
	dat += "<tt><center>"

	dat += "<b>Select a character slot to load</b><hr>"
	for(var/i=1, i<= config.character_slots, i++)
		var/name = (slot_names && slot_names[get_slot_key(i)]) || "Character[i]"
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
	set waitfor = FALSE

	if(!client)
		return

	client.apply_fps(clientfps)

	if(client.get_preference_value(/datum/client_preference/fullscreen_mode) != PREF_OFF)
		client.toggle_fullscreen(client.get_preference_value(/datum/client_preference/fullscreen_mode))


/datum/preferences/proc/setup_preferences(initialization = FALSE)
	// This proc will be called twice if SScharacter_setup is not initialized,
	// so, don't create prefs again.

	if(istype(client))

		// Preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum).
		SScharacter_setup.preferences_datums[client.ckey] = src

		if(initialization || SScharacter_setup.initialized)
			setup()
		else
			SScharacter_setup.queue_prefs(src)
