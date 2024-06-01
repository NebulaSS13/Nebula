/decl/emote/audible/scream
	key = "scream"
	emote_message_1p = "You scream!"
	emote_message_3p = "$USER$ screams!"

/decl/emote/audible/scream/get_emote_message_1p(var/atom/user, var/atom/target, var/extra_params)
	if(ismob(user))
		var/mob/screamer = user
		var/decl/species/screamer_species = screamer.get_species()
		if(screamer_species?.scream_verb_1p)
			return "You [screamer_species.scream_verb_1p]!"
	. = ..()

/decl/emote/audible/scream/get_emote_message_3p(var/atom/user, var/atom/target, var/extra_params)
	if(ismob(user))
		var/mob/screamer = user
		var/decl/species/screamer_species = screamer.get_species()
		if(screamer_species?.scream_verb_3p)
			return "$USER$ [screamer_species.scream_verb_3p]!"
	. = ..()