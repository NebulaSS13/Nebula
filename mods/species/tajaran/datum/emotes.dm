/decl/emote_sounds/human/tajaran
/decl/emote_sounds/human/tajaran/sound_config_paths(var/list/paths_list = list())
	paths_list |= "mods/species/tajaran/sound/tajaran_emotes.json"
	return ..(paths_list)

/decl/species/tajaran
	default_emotes = list(
		/decl/emote/human/swish,
		/decl/emote/human/wag,
		/decl/emote/human/sway,
		/decl/emote/human/qwag,
		/decl/emote/human/fastsway,
		/decl/emote/human/swag,
		/decl/emote/human/stopsway,
		/decl/emote/audible/purr,
		/decl/emote/audible/purrlong
	)

/decl/emote/audible/purr
	key = "purr"
	emote_message_3p = "USER purrs."

/decl/emote/audible/purrlong
	key = "purrl"
	emote_message_3p = "USER purrs."
