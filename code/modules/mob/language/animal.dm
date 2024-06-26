/decl/language/animal
	name = "Animal Noises" // translate them!
	desc = "Some varieties of animal can communicate amongst themselves, apparently."
	colour = "say_quote"
	key = "a"
	shorthand = "A"
	hidden_from_codex = TRUE

/decl/language/animal/can_be_understood_by(var/mob/living/speaker, var/mob/living/listener)
	if(!istype(listener) || listener.universal_understand || listener.universal_speak)
		return TRUE
	if(!istype(speaker) || speaker.universal_speak)
		return TRUE
	if(istype(speaker, listener.type) || istype(listener, speaker.type))
		return TRUE
	if(isanimal(speaker))
		var/mob/living/simple_animal/critter = speaker
		if(istype(listener, critter.base_animal_type))
			return TRUE
	if(isanimal(listener))
		var/mob/living/simple_animal/critter = listener
		if(istype(speaker, critter.base_animal_type))
			return TRUE
	return FALSE

/decl/language/animal/scramble(mob/living/speaker, input, list/known_languages)
	if(istype(speaker.ai) && length(speaker.ai.emote_speech))
		return DEFAULTPICK(speaker.ai.emote_speech, "...")
	return "..."

/decl/language/animal/get_spoken_verb(mob/living/speaker, msg_end)
	if(istype(speaker) && length(speaker.speak_emote))
		return pick(speaker.speak_emote)
	. = ..()
