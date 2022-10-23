var/global/const/PREF_YES = "Yes"
var/global/const/PREF_NO = "No"
var/global/const/PREF_ALL_SPEECH = "All Speech"
var/global/const/PREF_NEARBY = "Nearby"
var/global/const/PREF_ALL_EMOTES = "All Emotes"
var/global/const/PREF_ALL_CHATTER = "All Chatter"
var/global/const/PREF_SHORT = "Short"
var/global/const/PREF_LONG = "Long"
var/global/const/PREF_SHOW = "Show"
var/global/const/PREF_HIDE = "Hide"
var/global/const/PREF_FANCY = "Fancy"
var/global/const/PREF_PLAIN = "Plain"
var/global/const/PREF_PRIMARY = "Primary"
var/global/const/PREF_ALL = "All"
var/global/const/PREF_ON = "On"
var/global/const/PREF_OFF = "Off"
var/global/const/PREF_BASIC = "Basic"
var/global/const/PREF_FULL = "Full"
var/global/const/PREF_MIDDLE_CLICK = "Middle click"
var/global/const/PREF_ALT_CLICK = "Alt click"
var/global/const/PREF_DOUBLE_CLICK = "Double click"
var/global/const/PREF_CTRL_CLICK = "Ctrl click"
var/global/const/PREF_CTRL_SHIFT_CLICK = "Ctrl+shift click"
var/global/const/PREF_HEAR = "Hear"
var/global/const/PREF_SILENT = "Silent"
var/global/const/PREF_SHORTHAND = "Shorthand"
var/global/const/PREF_NON_ANTAG = "Non-Antag Only"
var/global/const/PREF_NEVER = "Never"
var/global/const/PREF_ALWAYS = "Always"
var/global/const/PREF_MYSELF = "Only Against Self"
var/global/const/PREF_DARKMODE = "Darkmode"
var/global/const/PREF_LIGHTMODE = "Lightmode"
var/global/list/_client_preferences
var/global/list/_client_preferences_by_key
var/global/list/_client_preferences_by_type

/proc/get_client_preferences()
	if(!_client_preferences)
		_client_preferences = list()
		for(var/ct in subtypesof(/datum/client_preference))
			var/datum/client_preference/client_type = ct
			if(initial(client_type.description))
				_client_preferences += new client_type()
	return _client_preferences

/proc/get_client_preference(var/datum/client_preference/preference)
	if(istype(preference))
		return preference
	if(ispath(preference))
		return get_client_preference_by_type(preference)
	return get_client_preference_by_key(preference)

/proc/get_client_preference_by_key(var/preference)
	if(!_client_preferences_by_key)
		_client_preferences_by_key = list()
		for(var/ct in get_client_preferences())
			var/datum/client_preference/client_pref = ct
			_client_preferences_by_key[client_pref.key] = client_pref
	return _client_preferences_by_key[preference]

/proc/get_client_preference_by_type(var/preference)
	if(!_client_preferences_by_type)
		_client_preferences_by_type = list()
		for(var/ct in get_client_preferences())
			var/datum/client_preference/client_pref = ct
			_client_preferences_by_type[client_pref.type] = client_pref
	return _client_preferences_by_type[preference]

/datum/client_preference
	var/description
	var/key
	var/list/options = list(PREF_YES, PREF_NO)
	var/default_value

/datum/client_preference/New()
	. = ..()

	if(!default_value)
		default_value = options[1]

/datum/client_preference/proc/may_set(client/given_client)
	return TRUE

/datum/client_preference/proc/changed(var/mob/preference_mob, var/new_value)
	return

/*********************
* Player Preferences *
*********************/

/datum/client_preference/play_admin_midis
	description ="Play admin midis"
	key = "SOUND_MIDI"

/datum/client_preference/play_lobby_music
	description ="Play lobby music"
	key = "SOUND_LOBBY"

/datum/client_preference/play_lobby_music/changed(var/mob/preference_mob, var/new_value)
	if(new_value == PREF_YES && isnewplayer(preference_mob))
		global.using_map.lobby_track.play_to(preference_mob)
	else
		sound_to(preference_mob, sound(null, repeat = 0, wait = 0, volume = 85, channel = sound_channels.lobby_channel))

/datum/client_preference/play_game_music
	description = "Play in-game music"
	key = "SOUND_GAMEMUSIC"

/datum/client_preference/play_instruments
	description ="Play instruments"
	key = "SOUND_INSTRUMENTS"

/datum/client_preference/play_ambiance
	description ="Play ambience"
	key = "SOUND_AMBIENCE"

/datum/client_preference/play_ambiance/changed(var/mob/preference_mob, var/new_value)
	if(new_value == PREF_NO)
		sound_to(preference_mob, sound(null, repeat = 0, wait = 0, volume = 0, channel = sound_channels.lobby_channel))
		sound_to(preference_mob, sound(null, repeat = 0, wait = 0, volume = 0, channel = sound_channels.ambience_channel))
		sound_to(preference_mob, sound(null, repeat = 0, wait = 0, volume = 0, channel = sound_channels.weather_channel))

/datum/client_preference/ghost_ears
	description ="Ghost ears"
	key = "CHAT_GHOSTEARS"
	options = list(
		PREF_ALL_SPEECH,
		PREF_NEARBY
	)

/datum/client_preference/ghost_sight
	description ="Ghost sight"
	key = "CHAT_GHOSTSIGHT"
	options = list(
		PREF_ALL_EMOTES,
		PREF_NEARBY
	)

/datum/client_preference/ghost_radio
	description ="Ghost radio"
	key = "CHAT_GHOSTRADIO"
	options = list(
		PREF_ALL_CHATTER,
		PREF_NEARBY
	)

/datum/client_preference/language_display
	description = "Display Language Names"
	key = "LANGUAGE_DISPLAY"
	options = list(PREF_SHORTHAND, PREF_FULL, PREF_OFF)

/datum/client_preference/ghost_follow_link_length
	description ="Ghost Follow Links"
	key = "CHAT_GHOSTFOLLOWLINKLENGTH"
	options = list(PREF_SHORT, PREF_LONG)

/datum/client_preference/chat_tags
	description ="Chat tags"
	key = "CHAT_SHOWICONS"
	options = list(PREF_SHOW, PREF_HIDE)

/datum/client_preference/show_typing_indicator
	description ="Typing indicator"
	key = "SHOW_TYPING"
	options = list(PREF_SHOW, PREF_HIDE)

/datum/client_preference/show_typing_indicator/changed(var/mob/preference_mob, var/new_value)
	if(preference_mob)
		SStyping.update_preference(preference_mob.client, (new_value == PREF_SHOW))

/datum/client_preference/show_ooc
	description ="OOC chat"
	key = "CHAT_OOC"
	options = list(PREF_SHOW, PREF_HIDE)

/datum/client_preference/show_aooc
	description ="AOOC chat"
	key = "CHAT_AOOC"
	options = list(PREF_SHOW, PREF_HIDE)

/datum/client_preference/show_looc
	description ="LOOC chat"
	key = "CHAT_LOOC"
	options = list(PREF_SHOW, PREF_HIDE)

/datum/client_preference/show_dsay
	description ="Dead chat"
	key = "CHAT_DEAD"
	options = list(PREF_SHOW, PREF_HIDE)

/datum/client_preference/anon_say
	description = "Anonymous Chat"
	key = "CHAT_ANONSAY"
	options = list(PREF_NO, PREF_YES)

/datum/client_preference/show_progress_bar
	description ="Progress Bar"
	key = "SHOW_PROGRESS"
	options = list(PREF_SHOW, PREF_HIDE)

/datum/client_preference/browser_style
	description = "Fake NanoUI Browser Style"
	key = "BROWSER_STYLED"
	options = list(PREF_FANCY, PREF_PLAIN)

/datum/client_preference/fullscreen_mode
	description = "Fullscreen Mode"
	key = "FULLSCREEN"
	options = list(PREF_NO, PREF_BASIC, PREF_FULL)

/datum/client_preference/fullscreen_mode/changed(mob/preference_mob, new_value)
	if(preference_mob.client)
		preference_mob.client.toggle_fullscreen(new_value)

/datum/client_preference/autohiss
	description = "Autohiss"
	key = "AUTOHISS"
	options = list(PREF_OFF, PREF_BASIC, PREF_FULL)

/datum/client_preference/hardsuit_activation
	description = "Hardsuit Module Activation Key"
	key = "HARDSUIT_ACTIVATION"
	options = list(PREF_MIDDLE_CLICK, PREF_CTRL_CLICK, PREF_ALT_CLICK, PREF_CTRL_SHIFT_CLICK)

/datum/client_preference/holster_on_intent
	description = "Draw gun based on intent"
	key = "HOLSTER_ON_INTENT"

/datum/client_preference/show_credits
	description = "Show End Titles"
	key = "SHOW_CREDITS"

/datum/client_preference/show_ckey_credits
	description = "Show Ckey in End Credits"
	key = "SHOW_CKEY_CREDITS"
	options = list(PREF_HIDE, PREF_SHOW)

/datum/client_preference/give_personal_goals
	description = "Give Personal Goals"
	key = "PERSONAL_GOALS"
	options = list(PREF_NEVER, PREF_NON_ANTAG, PREF_ALWAYS)

/datum/client_preference/show_department_goals
	description = "Show Departmental Goals"
	key = "DEPT_GOALS"
	options = list(PREF_SHOW, PREF_HIDE)

/datum/client_preference/examine_messages
	description = "Examining messages"
	key = "EXAMINE_MESSAGES"
	options = list(PREF_SHOW, PREF_HIDE)

/datum/client_preference/floating_messages
	description = "Floating chat messages"
	key = "FLOATING_CHAT"
	options = list(PREF_SHOW, PREF_HIDE)

/datum/client_preference/show_status_markers
	description ="Show overhead status markers"
	key = "STATUS_MARKERS"
	options = list(PREF_SHOW, PREF_HIDE)

/datum/client_preference/show_status_markers/changed(mob/preference_mob, new_value)
	. = ..()
	if(preference_mob.client)
		for(var/datum/status_marker_holder/marker as anything in global.status_marker_holders)
			var/marker_image = (preference_mob.status_markers == marker) ? marker.mob_image_personal : marker.mob_image
			if(new_value == PREF_HIDE)
				preference_mob.client.images -= marker_image
			else
				preference_mob.client.images |= marker_image

/datum/client_preference/show_turf_contents
	description = "Show turf contents in side panel"
	key = "TURF_CONTENTS"
	options = list(PREF_ALT_CLICK, PREF_DOUBLE_CLICK, PREF_OFF)

/datum/client_preference/inquisitive_examine
	description = "Show additional information in atom examine (codex, etc)"
	key = "INQUISITIVE_EXAMINE"
	options = list(PREF_ON, PREF_OFF)

/********************
* General Staff Preferences *
********************/

/datum/client_preference/staff
	var/flags

/datum/client_preference/staff/may_set(client/given_client)
	if(ismob(given_client))
		var/mob/M = given_client
		given_client = M.client
	if(!given_client)
		return FALSE
	if(flags)
		return check_rights(flags, 0, given_client)
	else
		return given_client && given_client.holder

/datum/client_preference/staff/show_chat_prayers
	description = "Chat Prayers"
	key = "CHAT_PRAYER"
	options = list(PREF_SHOW, PREF_HIDE)

/datum/client_preference/staff/play_adminhelp_ping
	description = "Adminhelps"
	key = "SOUND_ADMINHELP"
	options = list(PREF_HEAR, PREF_SILENT)

/datum/client_preference/staff/show_rlooc
	description ="Remote LOOC chat"
	key = "CHAT_RLOOC"
	options = list(PREF_SHOW, PREF_HIDE)

/********************
* Admin Preferences *
********************/

/datum/client_preference/staff/show_attack_logs
	description = "Attack Log Messages"
	key = "CHAT_ATTACKLOGS"
	options = list(PREF_SHOW, PREF_HIDE)
	flags = R_ADMIN
	default_value = PREF_HIDE

/********************
* Debug Preferences *
********************/

/datum/client_preference/staff/show_debug_logs
	description = "Debug Log Messages"
	key = "CHAT_DEBUGLOGS"
	options = list(PREF_SHOW, PREF_HIDE)
	default_value = PREF_HIDE
	flags = R_ADMIN|R_DEBUG

/********************
* Area Info Blurb *
********************/

/datum/client_preference/area_info_blurb
	description ="Show area information"
	key = "AREA_INFO"
	default_value = PREF_YES

/datum/client_preference/byond_membership/may_set(client/given_client)
	if(ismob(given_client))
		var/mob/M = given_client
		given_client = M.client
	if(!given_client)
		return FALSE
	return given_client.get_byond_membership()

/*********************
* Darkmode/Lightmode *
*********************/

/datum/client_preference/chat_color_mode
	description ="Chat/interface style"
	key = "CHAT_MODE"
	default_value = PREF_DARKMODE
	options = list(PREF_DARKMODE, PREF_LIGHTMODE)

/datum/client_preference/chat_color_mode/changed(var/mob/preference_mob, var/new_value)
	if(!preference_mob.client)
		return
	if(new_value == PREF_DARKMODE)
		preference_mob.client.activate_darkmode()
	else
		preference_mob.client.deactivate_darkmode()

/******************************
* Help intent attack blocking *
******************************/

/datum/client_preference/help_intent_attack_blocking
	description = "Prevent attacks on help intent"
	key = "ATTACK_ON_HELP"
	default_value = PREF_MYSELF
	options = list(PREF_NEVER, PREF_MYSELF, PREF_ALWAYS)
