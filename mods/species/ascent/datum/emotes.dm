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

/mob/living/silicon/robot/flying/ascent/get_default_emotes()
	var/static/list/default_emotes = list(
		/decl/emote/audible/ascent_purr,
		/decl/emote/audible/ascent_hiss,
		/decl/emote/audible/ascent_snarl
	)
	return default_emotes

/decl/emote/audible/ascent_purr
	key = "apurr"
	emote_message_3p = "$USER$ purrs."
	emote_sound = 'mods/species/ascent/sounds/ascent1.ogg'

/decl/emote/audible/ascent_hiss
	key = "ahiss"
	emote_message_3p = "$USER$ hisses."
	emote_sound = 'mods/species/ascent/sounds/razorweb.ogg'

/decl/emote/audible/ascent_snarl
	key = "asnarl"
	emote_message_3p = "$USER$ snarls."
	emote_sound = 'mods/species/ascent/sounds/razorweb_hiss.ogg'

/decl/emote/visible/ascent_flicker
	key = "aflicker"
	emote_message_3p = "$USER$ flickers prismatically."

/decl/emote/visible/ascent_glint
	key = "aglint"
	emote_message_3p = "$USER$ glints."

/decl/emote/visible/ascent_glimmer
	key = "aglimmer"
	emote_message_3p = "$USER$ glimmers."

/decl/emote/visible/ascent_pulse
	key = "apulse"
	emote_message_3p = "$USER$ pulses with light."

/decl/emote/visible/ascent_shine
	key = "ashine"
	emote_message_3p = "$USER$ shines brightly!"

/decl/emote/visible/ascent_dazzle
	key = "adazzle"
	emote_message_3p = "$USER$ dazzles!"
