
/decl/emote/visible/tail
	abstract_type = /decl/emote/visible/tail

/decl/emote/visible/tail/mob_can_use(mob/living/user, assume_available = FALSE)
	return ishuman(user) && ..()

/decl/emote/visible/tail/swish
	key = "swish"

/decl/emote/visible/tail/swish/do_emote(mob/living/user)
	var/mob/living/human/human_user = user
	if(istype(human_user))
		human_user.animate_tail_once()
	return TRUE

/decl/emote/visible/tail/wag
	key = "wag"

/decl/emote/visible/tail/wag/do_emote(mob/living/user)
	var/mob/living/human/human_user = user
	if(istype(human_user))
		human_user.animate_tail_start()
	return TRUE

/decl/emote/visible/tail/sway
	key = "sway"

/decl/emote/visible/tail/sway/do_emote(mob/living/user)
	var/mob/living/human/human_user = user
	if(istype(human_user))
		human_user.animate_tail_start()
	return TRUE

/decl/emote/visible/tail/qwag
	key = "qwag"

/decl/emote/visible/tail/qwag/do_emote(mob/living/user)
	var/mob/living/human/human_user = user
	if(istype(human_user))
		human_user.animate_tail_fast()
	return TRUE

/decl/emote/visible/tail/fastsway
	key = "fastsway"

/decl/emote/visible/tail/fastsway/do_emote(mob/living/user)
	var/mob/living/human/human_user = user
	if(istype(human_user))
		human_user.animate_tail_fast()
	return TRUE

/decl/emote/visible/tail/swag
	key = "swag"

/decl/emote/visible/tail/swag/do_emote(mob/living/user)
	var/mob/living/human/human_user = user
	if(istype(human_user))
		human_user.animate_tail_stop()
	return TRUE

/decl/emote/visible/tail/stopsway
	key = "stopsway"

/decl/emote/visible/tail/stopsway/do_emote(mob/living/user)
	var/mob/living/human/human_user = user
	if(istype(human_user))
		human_user.animate_tail_stop()
	return TRUE
