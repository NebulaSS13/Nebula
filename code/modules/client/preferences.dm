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
	/// doohickeys for savefiles
	var/is_guest = FALSE
	/// Cached varialbe for checking byond membership. Also handles days of membership left.
	var/is_byond_member

	/// Holder so it doesn't default to slot 1, rather the last one used
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
	QDEL_NULL(player_setup)
	QDEL_NULL(panel)
	QDEL_LIST_ASSOC_VAL(char_render_holders)

/datum/preferences/proc/setup()
	player_setup = new(src)
	gender = pick(MALE, FEMALE)
	real_name = get_random_name()

	var/decl/species/species = get_species_by_key(global.using_map.default_species)
	blood_type = pickweight(species.blood_types)

	if(client)
		if(IsGuestKey(client.key))
			is_guest = TRUE
		else
			load_data()
			is_byond_member = client.IsByondMember()

	load_preferences()
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

		stage = "load_preferences"
		load_preferences()
		if(SScharacter_setup.initialized)
			stage = "load_character"
			load_character()
		else
			SScharacter_setup.queue_load_character(src)
	catch(var/exception/E)
		load_failed = "{[stage]} [EXCEPTION_TEXT(E)]"
		throw E

// separated out to avoid stalling SScharacter_setup's Initialize
/datum/preferences/proc/lateload_character()
	try
		load_character()
	catch(var/exception/E)
		load_failed = "{lateload_character} [EXCEPTION_TEXT(E)]"
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

	if(!user || !user.client)
		return

	if(!get_mob_by_key(client_ckey))
		to_chat(user, "<span class='danger'>No mob exists for the given client!</span>")
		close_load_dialog(user)
		return

	if(!char_render_holders)
		update_preview_icon()
	show_character_previews()

	// This is a bit out of place; we do this here because it means that loading and viewing
	// a character slot is sufficient to refresh our comment history. Otherwise, you would
	// have to go back and edit your comments every X days for them to stay visible.
	if(comments_record_id)
		for(var/record_id in SScharacter_info._comment_holders_by_id)
			var/datum/character_information/record = SScharacter_info._comment_holders_by_id[record_id]
			if(record)
				for(var/datum/character_comment/comment in record.comments)
					if(comment.author_id == comments_record_id)
						comment.last_updated = REALTIMEOFDAY

	var/dat = list("<center>")
	if(is_guest)
		dat += SPAN_WARNING("Please create an account to save your preferences. If you have an account and are seeing this, please adminhelp for assistance.")
	else if(load_failed)
		dat += SPAN_DANGER("Loading your savefile failed: [load_failed]<br>Please adminhelp for assistance.")
	else

		dat += "<b>Slot</b> - "
		dat += "<a href='byond://?src=\ref[src];load=1'>Load slot</a> - "
		dat += "<a href='byond://?src=\ref[src];save=1'>Save slot</a> - "
		dat += "<a href='byond://?src=\ref[src];resetslot=1'>Reset slot</a> - "
		dat += "<a href='byond://?src=\ref[src];reload=1'>Reload slot</a><br>"

		dat += "<b>Preview</b> - "
		dat += "<a href='byond://?src=\ref[src];cycle_bg=1'>Cycle background</a> - "
		dat += "<a href='byond://?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"]</a> - "
		dat += "<a href='byond://?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"]</a>"

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)
	return JOINTEXT(dat)

/datum/preferences/proc/open_setup_window(mob/user)

	if(!SScharacter_setup.initialized)
		return

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

/datum/preferences/proc/update_character_previews(mob/living/mannequin)
	if(!client)
		return

	var/obj/screen/setup_preview/bg/BG = LAZYACCESS(char_render_holders, "BG")
	if(!BG)
		BG = new
		BG.pref = src
		LAZYSET(char_render_holders, "BG", BG)
		client.screen |= BG
	BG.icon_state = bgstate
	BG.color = global.using_map.char_preview_bgstate_options[bgstate]

	var/static/list/default_preview_screen_locs = list(
		"1" = "character_preview_map:1:16,4:36",
		"2" = "character_preview_map:1:16,3:31",
		"4" = "character_preview_map:1:16,2:26",
		"8" = "character_preview_map:1:16,1:21"
	)

	var/list/preview_screen_locs = mannequin?.get_preview_screen_locs() || default_preview_screen_locs
	for(var/D in global.cardinal)
		var/obj/screen/setup_preview/O = LAZYACCESS(char_render_holders, "[D]")
		if(!O)
			O = new
			O.pref = src
			LAZYSET(char_render_holders, "[D]", O)
			client.screen |= O
		mannequin.set_dir(D) // necessary to update direction-dependent over/underlays like tails.
		var/mutable_appearance/MA = new /mutable_appearance(mannequin)
		O.appearance = MA
		O.dir = D
		O.screen_loc = preview_screen_locs[num2text(D)]
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
	if(!user)
		return
	if(isliving(user))
		return
	if(href_list["preference"] == "open_whitelist_forum")
		if(get_config_value(/decl/config/text/forumurl))
			direct_output(user, link(get_config_value(/decl/config/text/forumurl)))
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
		bgstate = next_in_list(bgstate, global.using_map.char_preview_bgstate_options)
	else
		return FALSE

	update_preview_icon()
	update_setup_window(usr)
	return 1

/datum/preferences/proc/copy_to(mob/living/human/character, is_preview_copy = FALSE)

	if(!player_setup)
		return // WHY IS THIS EVEN HAPPENING.

	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()
	validate_comments_record() // Make sure a record has been generated for this character.
	character.comments_record_id = comments_record_id
	character.traits = null

	var/decl/bodytype/new_bodytype = get_bodytype_decl()
	if(species == character.get_species_name())
		character.set_bodytype(new_bodytype)
	else
		character.change_species(species, new_bodytype)

	if(be_random_name)
		var/decl/cultural_info/culture = GET_DECL(cultural_info[TAG_CULTURE])
		if(culture)
			real_name = culture.get_random_name(gender)

	if(get_config_value(/decl/config/toggle/humans_need_surnames))
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(global.using_map.last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(global.using_map.last_names)]"

	character.fully_replace_character_name(real_name)

	character.set_gender(gender)
	character.blood_type = blood_type

	character.set_eye_colour(eye_colour, skip_update = TRUE)

	character.set_skin_colour(skin_colour, skip_update = TRUE)
	character.skin_tone = skin_tone

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

	if(length(traits))
		for(var/trait_type in traits)
			character.set_trait(trait_type, (traits[trait_type] || TRAIT_LEVEL_EXISTS))

	for(var/obj/item/organ/external/O in character.get_external_organs())
		for(var/decl/sprite_accessory_category/sprite_category in O.get_sprite_accessory_categories())
			if(!sprite_category.clear_in_pref_apply)
				continue
			O.clear_sprite_accessories_by_category(sprite_category.type, skip_update = TRUE)

	for(var/accessory_category in sprite_accessories)
		var/decl/sprite_accessory_category/acc_cat = GET_DECL(accessory_category)
		var/list/accessories = sprite_accessories[accessory_category]
		acc_cat.prepare_character(character, accessories)
		for(var/accessory in accessories)
			var/decl/sprite_accessory/accessory_decl = GET_DECL(accessory)
			var/accessory_metadata = accessories[accessory]
			for(var/bodypart in accessory_decl.body_parts)
				var/obj/item/organ/external/O = GET_EXTERNAL_ORGAN(character, bodypart)
				if(O)
					O.set_sprite_accessory(accessory, accessory_category, accessory_metadata, skip_update = TRUE)

	if(LAZYLEN(appearance_descriptors))
		character.appearance_descriptors = appearance_descriptors.Copy()

	character.force_update_limbs()
	character.update_genetic_conditions(0)
	character.update_body(0)
	character.update_underwear(0)
	character.update_hair(0)
	character.update_icon()
	character.update_transform()

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

	if(!character.isSynthetic())
		character.set_nutrition(rand(140,360))
		character.set_hydration(rand(140,360))

	return character

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat  = list()
	dat += "<body>"
	dat += "<tt><center>"

	dat += "<b>Select a character slot to load</b><hr>"
	var/character_slots = get_config_value(/decl/config/num/character_slots)
	for(var/i = 1 to character_slots)
		var/name = (slot_names && slot_names[get_slot_key(i)]) || "Character[i]"
		if(i==default_slot)
			name = "<b>[name]</b>"
		dat += "<a href='byond://?src=\ref[src];changeslot=[i]'>[name]</a><br>"

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

	if(client.get_preference_value(/datum/client_preference/fullscreen_mode) != PREF_OFF)
		client.toggle_fullscreen(client.get_preference_value(/datum/client_preference/fullscreen_mode))

/datum/preferences/proc/setup_preferences()
	// give them default keybinds
	key_bindings = deepCopyList(global.hotkey_keybinding_list_by_key)

	if(istype(client))
		// Preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum).
		SScharacter_setup.preferences_datums[client.ckey] = src
		setup()

/datum/preferences/proc/set_species(new_species)
	species = new_species
	sanitize_preferences()
	var/decl/species/mob_species = get_species_decl()
	mob_species.handle_post_species_pref_set(src)
	var/decl/bodytype/mob_bodytype = get_bodytype_decl()
	set_bodytype(mob_bodytype)

/datum/preferences/proc/set_bodytype(new_bodytype)
	bodytype = new_bodytype
	sanitize_preferences()
	var/decl/bodytype/mob_bodytype = get_bodytype_decl()
	mob_bodytype.handle_post_bodytype_pref_set(src)