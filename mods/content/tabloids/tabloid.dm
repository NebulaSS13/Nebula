/obj/item/tabloid
	name       = "tabloid magazine"
	desc       = "It's one of those trashy tabloid magazines. It looks pretty out of date."
	icon       = 'mods/content/tabloids/icons/magazine.dmi'
	icon_state = "magazine"
	randpixel  = 6
	material   = /decl/material/solid/organic/paper
	matter     = list(/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT)
	var/headline
	var/article_body

/obj/item/tabloid/Initialize()
	. = ..()
	var/list/tabloid_headlines = get_tabloid_headlines()
	name       = SAFEPICK(get_tabloid_publishers()) || initial(name)
	icon_state = SAFEPICK(get_tabloid_states())     || initial(icon_state)
	headline   = SAFEPICK(tabloid_headlines)
	if(length(tabloid_headlines) && tabloid_headlines[headline])
		article_body = tabloid_headlines[headline]

/obj/item/tabloid/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(headline)
		. += "The headline screams, \"[headline]\""

/obj/item/tabloid/attack_self(mob/user)
	. = ..()
	if(!.)
		user.visible_message(SPAN_NOTICE("\The [user] leafs idly through \the [src]."))
		if(headline)
			to_chat(user, "Most of it is the usual tabloid garbage, but the headline story, \"[headline]\", holds your attention for awhile.")
			if(article_body)
				to_chat(user, article_body)
		else
			to_chat(user, "It's the usual tabloid garbage. You find nothing of interest.")
		return TRUE
