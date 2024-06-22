/mob/living/slime/get_default_emotes()
	var/static/list/default_emotes = list(
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
	return default_emotes

/decl/emote/slime
	key = "nomood"
	var/mood

/decl/emote/slime/do_extra(atom/user)
	if(ismob(user))
		var/mob/user_mob = user
		var/datum/mob_controller/slime/slime_ai = user_mob.ai
		if(istype(slime_ai))
			slime_ai.mood = mood
			user.update_icon()

/decl/emote/slime/mob_can_use(mob/living/user, assume_available = FALSE)
	return isslime(user) && ..()

/decl/emote/slime/pout
	key = "slimepout"
	mood = "pout"

/decl/emote/slime/sad
	key = "slimesad"
	mood = "sad"

/decl/emote/slime/angry
	key = "slimeangry"
	mood = "angry"

/decl/emote/slime/frown
	key = "slimefrown"
	mood = "mischevous"

/decl/emote/slime/smile
	key = "slimesmile"
	mood = ":3"
