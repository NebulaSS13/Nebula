/datum/mob_controller
	/// A prob chance of speaking.
	var/speak_chance = 0
	/// Strings shown when this mob speaks and is not understood.
	var/list/emote_speech
	/// Hearable emotes that this mob can randomly perform.
	var/list/emote_hear
	/// Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps
	var/list/emote_see

// The mob will periodically make a noise or perform an emote.
/datum/mob_controller/proc/try_bark()
	//Speaking
	if(prob(speak_chance))
		var/action = pick(
			LAZYLEN(emote_speech); "emote_speech",
			LAZYLEN(emote_hear);   "emote_hear",
			LAZYLEN(emote_see);    "emote_see"
		)
		var/do_emote
		var/emote_type = VISIBLE_MESSAGE
		switch(action)
			if("emote_speech")
				if(length(emote_speech))
					body.say(pick(emote_speech))
			if("emote_hear")
				do_emote = SAFEPICK(emote_hear)
				emote_type = AUDIBLE_MESSAGE
			if("emote_see")
				do_emote = SAFEPICK(emote_see)

		if(istext(do_emote))
			body.custom_emote(emote_type, "[do_emote].")
		else if(ispath(do_emote, /decl/emote))
			body.emote(do_emote)
