/decl/emote_sounds/human
/decl/emote_sounds/human/sound_config_paths(var/list/paths_list = list())
	paths_list |= "[EMOTE_SOUNDS_CONFIG_PATH]/human.json"
	return ..(paths_list)

/decl/emote_sounds/human/monkey
/decl/emote_sounds/human/monkey/sound_config_paths(var/list/paths_list = list())
	paths_list |= "[EMOTE_SOUNDS_CONFIG_PATH]/monkey.json"
	return ..(paths_list)

/decl/emote_sounds/alien
/decl/emote_sounds/alien/sound_config_paths(var/list/paths_list = list())
	paths_list |= "[EMOTE_SOUNDS_CONFIG_PATH]/alien.json"
	return ..(paths_list)

/decl/emote_sounds/silicon
/decl/emote_sounds/silicon/sound_config_paths(var/list/paths_list = list())
	paths_list |= "[EMOTE_SOUNDS_CONFIG_PATH]/silicon.json"
	return ..(paths_list)
