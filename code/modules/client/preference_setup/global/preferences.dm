var/const/PREF_YES = "Yes"
var/const/PREF_NO = "No"
var/const/PREF_ALL_SPEECH = "All Speech"
var/const/PREF_NEARBY = "Nearby"
var/const/PREF_ALL_EMOTES = "All Emotes"
var/const/PREF_ALL_CHATTER = "All Chatter"
var/const/PREF_SHORT = "Short"
var/const/PREF_LONG = "Long"
var/const/PREF_SHOW = "Show"
var/const/PREF_HIDE = "Hide"
var/const/PREF_FANCY = "Fancy"
var/const/PREF_PLAIN = "Plain"
var/const/PREF_PRIMARY = "Primary"
var/const/PREF_ALL = "All"
var/const/PREF_OFF = "Off"
var/const/PREF_BASIC = "Basic"
var/const/PREF_FULL = "Full"
var/const/PREF_MIDDLE_CLICK = "Middle click"
var/const/PREF_ALT_CLICK = "Alt click"
var/const/PREF_CTRL_CLICK = "Ctrl click"
var/const/PREF_CTRL_SHIFT_CLICK = "Ctrl+shift click"
var/const/PREF_HEAR = "Hear"
var/const/PREF_SILENT = "Silent"
var/const/PREF_SHORTHAND = "Shorthand"
var/const/PREF_NEVER = "Never"
var/const/PREF_NON_ANTAG = "Non-Antag Only"
var/const/PREF_ALWAYS = "Always"

var/list/_client_preferences
var/list/_client_preferences_by_key
var/list/_client_preferences_by_type

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
	var/list/options = list(global.PREF_YES, global.PREF_NO)
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
	if(new_value == global.PREF_YES)
		if(isnewplayer(preference_mob))
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
	if(new_value == global.PREF_NO)
		sound_to(preference_mob, sound(null, repeat = 0, wait = 0, volume = 0, channel = sound_channels.lobby_channel))
		sound_to(preference_mob, sound(null, repeat = 0, wait = 0, volume = 0, channel = sound_channels.ambience_channel))

/datum/client_preference/ghost_ears
	description ="Ghost ears"
	key = "CHAT_GHOSTEARS"
	options = list(global.PREF_ALL_SPEECH, global.PREF_NEARBY)

/datum/client_preference/ghost_sight
	description ="Ghost sight"
	key = "CHAT_GHOSTSIGHT"
	options = list(global.PREF_ALL_EMOTES, global.PREF_NEARBY)

/datum/client_preference/ghost_radio
	description ="Ghost radio"
	key = "CHAT_GHOSTRADIO"
	options = list(global.PREF_ALL_CHATTER, global.PREF_NEARBY)

/datum/client_preference/language_display
	description = "Display Language Names"
	key = "LANGUAGE_DISPLAY"
	options = list(global.PREF_SHORTHAND, global.PREF_FULL, global.PREF_OFF)

/datum/client_preference/ghost_follow_link_length
	description ="Ghost Follow Links"
	key = "CHAT_GHOSTFOLLOWLINKLENGTH"
	options = list(global.PREF_SHORT, global.PREF_LONG)

/datum/client_preference/chat_tags
	description ="Chat tags"
	key = "CHAT_SHOWICONS"
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/datum/client_preference/show_typing_indicator
	description ="Typing indicator"
	key = "SHOW_TYPING"
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/datum/client_preference/show_typing_indicator/changed(var/mob/preference_mob, var/new_value)
	if(new_value == global.PREF_HIDE)
		preference_mob.remove_typing_indicator()

/datum/client_preference/show_ooc
	description ="OOC chat"
	key = "CHAT_OOC"
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/datum/client_preference/show_aooc
	description ="AOOC chat"
	key = "CHAT_AOOC"
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/datum/client_preference/show_looc
	description ="LOOC chat"
	key = "CHAT_LOOC"
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/datum/client_preference/show_dsay
	description ="Dead chat"
	key = "CHAT_DEAD"
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/datum/client_preference/anon_say
	description = "Anonymous Chat"
	key = "CHAT_ANONSAY"
	options = list(global.PREF_NO, global.PREF_YES)

/datum/client_preference/show_progress_bar
	description ="Progress Bar"
	key = "SHOW_PROGRESS"
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/datum/client_preference/browser_style
	description = "Fake NanoUI Browser Style"
	key = "BROWSER_STYLED"
	options = list(global.PREF_FANCY, global.PREF_PLAIN)

/datum/client_preference/fullscreen_mode
	description = "Fullscreen Mode"
	key = "FULLSCREEN"
	options = list(global.PREF_BASIC, global.PREF_FULL, global.PREF_NO)
	default_value = global.PREF_NO

/datum/client_preference/fullscreen_mode/changed(mob/preference_mob, new_value)
	if(preference_mob.client)
		preference_mob.client.toggle_fullscreen(new_value)

/datum/client_preference/chat_position
	description = "Alternative Chat Position"
	key = "CHAT_ALT"
	default_value = global.PREF_NO

/datum/client_preference/chat_position/changed(mob/preference_mob, new_value)
	if(preference_mob.client)
		preference_mob.client.update_chat_position(new_value == global.PREF_YES)

/datum/client_preference/autohiss
	description = "Autohiss"
	key = "AUTOHISS"
	options = list(global.PREF_OFF, global.PREF_BASIC, global.PREF_FULL)

/datum/client_preference/hardsuit_activation
	description = "Hardsuit Module Activation Key"
	key = "HARDSUIT_ACTIVATION"
	options = list(global.PREF_MIDDLE_CLICK, global.PREF_CTRL_CLICK, global.PREF_ALT_CLICK, global.PREF_CTRL_SHIFT_CLICK)

/datum/client_preference/holster_on_intent
	description = "Draw gun based on intent"
	key = "HOLSTER_ON_INTENT"

/datum/client_preference/show_credits
	description = "Show End Titles"
	key = "SHOW_CREDITS"

/datum/client_preference/show_ckey_credits
	description = "Show Ckey in End Credits"
	key = "SHOW_CKEY_CREDITS"
	options = list(global.PREF_HIDE, global.PREF_SHOW)

/datum/client_preference/give_personal_goals
	description = "Give Personal Goals"
	key = "PERSONAL_GOALS"
	options = list(global.PREF_NEVER, global.PREF_NON_ANTAG, global.PREF_ALWAYS)

/datum/client_preference/show_department_goals
	description = "Show Departmental Goals"
	key = "DEPT_GOALS"
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/datum/client_preference/examine_messages
	description = "Examining messages"
	key = "EXAMINE_MESSAGES"
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/datum/client_preference/floating_messages
	description = "Floating chat messages"
	key = "FLOATING_CHAT"
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/datum/client_preference/show_status_markers
	description ="Show overhead status markers"
	key = "STATUS_MARKERS"
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/datum/client_preference/show_status_markers/changed(mob/preference_mob, new_value)
	. = ..()
	if(preference_mob.client)
		for(var/datum/status_marker_holder/marker as anything in global.status_marker_holders)
			var/marker_image = (preference_mob.status_markers == marker) ? marker.mob_image_personal : marker.mob_image
			if(new_value == global.PREF_HIDE)
				preference_mob.client.images -= marker_image
			else
				preference_mob.client.images |= marker_image

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
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/datum/client_preference/staff/play_adminhelp_ping
	description = "Adminhelps"
	key = "SOUND_ADMINHELP"
	options = list(global.PREF_HEAR, global.PREF_SILENT)

/datum/client_preference/staff/show_rlooc
	description ="Remote LOOC chat"
	key = "CHAT_RLOOC"
	options = list(global.PREF_SHOW, global.PREF_HIDE)

/********************
* Admin Preferences *
********************/

/datum/client_preference/staff/show_attack_logs
	description = "Attack Log Messages"
	key = "CHAT_ATTACKLOGS"
	options = list(global.PREF_SHOW, global.PREF_HIDE)
	flags = R_ADMIN
	default_value = global.PREF_HIDE

/********************
* Debug Preferences *
********************/

/datum/client_preference/staff/show_debug_logs
	description = "Debug Log Messages"
	key = "CHAT_DEBUGLOGS"
	options = list(global.PREF_SHOW, global.PREF_HIDE)
	default_value = global.PREF_HIDE
	flags = R_ADMIN|R_DEBUG