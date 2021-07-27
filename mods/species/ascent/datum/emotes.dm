/decl/emote_sounds/human/ascent
/decl/emote_sounds/human/ascent/sound_config_paths(var/list/paths_list = list())
	paths_list |= "mods/species/ascent/sound/ascent_emotes.json"
	return ..(paths_list)

/decl/species/mantid
	default_emotes = list(
		/decl/emote/audible/ascent_purr,
		/decl/emote/audible/ascent_hiss,
		/decl/emote/audible/ascent_snarl,
		/decl/emote/visible/ascent_flicker,
		/decl/emote/visible/ascent_glint,
		/decl/emote/visible/ascent_glimmer,
		/decl/emote/visible/ascent_pulse,
		/decl/emote/visible/ascent_shine,
		/decl/emote/visible/ascent_dazzle
	)

/mob/living/silicon/robot/flying/ascent
	default_emotes = list(
		/decl/emote/audible/ascent_purr,
		/decl/emote/audible/ascent_hiss,
		/decl/emote/audible/ascent_snarl
	)

/decl/emote/audible/ascent_purr
	key = "purr"
	emote_message_3p = "USER purrs."

/decl/emote/audible/ascent_hiss
	key ="hiss"
	emote_message_3p = "USER hisses."

/decl/emote/audible/ascent_snarl
	key = "snarl"
	emote_message_3p = "USER snarls."

/decl/emote/visible/ascent_flicker
	key = "flicker"
	emote_message_3p = "USER flickers prismatically."

/decl/emote/visible/ascent_glint
	key = "glint"
	emote_message_3p = "USER glints."

/decl/emote/visible/ascent_glimmer
	key = "glimmer"
	emote_message_3p = "USER glimmers."

/decl/emote/visible/ascent_pulse
	key = "pulse"
	emote_message_3p = "USER pulses with light."

/decl/emote/visible/ascent_shine
	key = "shine"
	emote_message_3p = "USER shines brightly!"

/decl/emote/visible/ascent_dazzle
	key = "dazzle"
	emote_message_3p = "USER dazzles!"
