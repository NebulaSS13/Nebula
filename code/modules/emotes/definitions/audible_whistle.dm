/decl/emote/audible/whistle
	key = "whistle"
	emote_message_1p = "You whistle a tune."
	emote_message_3p = "$USER$ whistles a tune."
	emote_message_muffled = "$USER$ makes a light spitting noise, a poor attempt at a whistle."
	emote_message_synthetic_1p = "You whistle a robotic tune."
	emote_message_synthetic_3p = "$USER$ whistles a robotic tune."

/decl/emote/audible/whistle/Initialize()
	bodytype_emote_sound = key
	return ..()

/decl/emote/audible/whistle/quiet
	key = "qwhistle"
	emote_message_1p = "You whistle quietly."
	emote_message_3p = "$USER$ whistles quietly."
	emote_message_synthetic_1p = "You whistle robotically."
	emote_message_synthetic_3p = "$USER$ whistles robotically."

/decl/emote/audible/whistle/wolf
	key = "wwhistle"
	emote_message_1p = "You whistle inappropriately."
	emote_message_3p = "$USER$ whistles inappropriately."
	emote_message_synthetic_1p = "You beep inappropriately."
	emote_message_synthetic_3p = "$USER$ beeps inappropriately."

/decl/emote/audible/whistle/summon
	key = "swhistle"
	emote_message_1p = "You give an ear-piercing whistle."
	emote_message_3p = "$USER$ gives an ear-piercing whistle."
	emote_message_synthetic_1p = "You synthesise an ear-piercing whistle."
	emote_message_synthetic_3p = "$USER$ synthesises an ear-piercing whistle."
	bodytype_broadcast_sound = "swhistle"
	emote_cooldown = 20 SECONDS
	broadcast_distance = 65

/decl/emote/audible/whistle/summon/broadcast_emote_to(var/send_sound, var/mob/target, var/origin_z, var/direction)
	. = ..()
	if (.)
		var/turf/T = get_turf(target)
		if(!T || T.z == origin_z)
			to_chat(target, SPAN_NOTICE("You hear a piercing whistle from somewhere to the [dir2text(direction)]."))
		else if(T.z < origin_z)
			to_chat(target, SPAN_NOTICE("You hear a piercing whistle from somewhere above you, to the [dir2text(direction)]."))
		else
			to_chat(target, SPAN_NOTICE("You hear a piercing whistle from somewhere below you, to the [dir2text(direction)]."))
