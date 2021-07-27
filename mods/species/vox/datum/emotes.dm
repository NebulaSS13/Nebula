/decl/emote_sounds/human/vox
/decl/emote_sounds/human/vox/sound_config_paths(var/list/paths_list = list())
	paths_list |= "mods/species/vox/sound/vox_emotes.json"
	return ..(paths_list)

/decl/species/vox
	default_emotes = list(
		/decl/emote/audible/vox_shriek
	)

/decl/emote/audible/vox_shriek
	key ="shriek"
	emote_message_3p = "USER SHRIEKS!"