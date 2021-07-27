/decl/emote_sounds/human/lizard
/decl/emote_sounds/human/lizard/sound_config_paths(var/list/paths_list = list())
	paths_list |= "mods/species/lizard/sound/lizard_emotes.json"
	return ..(paths_list)

/decl/species/lizard
	default_emotes = list(
		/decl/emote/human/swish,
		/decl/emote/human/wag,
		/decl/emote/human/sway,
		/decl/emote/human/qwag,
		/decl/emote/human/fastsway,
		/decl/emote/human/swag,
		/decl/emote/human/stopsway
	)
