/decl/emote_sounds/human/adherent
/decl/emote_sounds/human/adherent/sound_config_paths(var/list/paths_list = list())
	paths_list |= "mods/species/adherent/sound/adherent_emotes.json"
	return ..(paths_list)

/decl/species/adherent
	default_emotes = list(
		/decl/emote/audible/adherent_chime,
		/decl/emote/audible/adherent_ding
	)

/decl/emote/audible/adherent_ding
	key = "ding"
	emote_message_3p = "USER dings."

/decl/emote/audible/adherent_chime
	key = "chime"
	emote_message_3p = "USER chimes."
