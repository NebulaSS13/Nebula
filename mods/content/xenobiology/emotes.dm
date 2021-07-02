/mob/living/slime
	default_emotes = list(
		/decl/emote/audible/moan,
		/decl/emote/visible/twitch,
		/decl/emote/visible/sway,
		/decl/emote/visible/shiver,
		/decl/emote/visible/bounce,
		/decl/emote/visible/jiggle,
		/decl/emote/visible/lightup,
		/decl/emote/visible/vibrate,
		/decl/emote/slime,
		/decl/emote/slime/pout,
		/decl/emote/slime/sad,
		/decl/emote/slime/angry,
		/decl/emote/slime/frown,
		/decl/emote/slime/smile
		)
		
/decl/emote/slime
	key = "nomood"
	var/mood

/decl/emote/slime/do_extra(var/mob/living/slime/user)
	var/datum/ai/slime/slime_ai = user.ai
	if(istype(slime_ai))
		slime_ai.mood = mood
		user.update_icon()

/decl/emote/slime/check_user(var/atom/user)
	return isslime(user)

/decl/emote/slime/pout
	key = "pout"
	mood = "pout"

/decl/emote/slime/sad
	key = "sad"
	mood = "sad"

/decl/emote/slime/angry
	key = "angry"
	mood = "angry"

/decl/emote/slime/frown
	key = "frown"
	mood = "mischevous"

/decl/emote/slime/smile
	key = "smile"
	mood = ":3"
