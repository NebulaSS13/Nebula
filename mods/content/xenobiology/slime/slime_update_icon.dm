/mob/living/slime/on_update_icon()

	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	icon = (stat != DEAD && is_adult) ? slime_data.adult_icon : slime_data.baby_icon // dead adults have no icon
	icon_state = initial(icon_state)
	if(stat == DEAD)
		icon_state = "[icon_state]_[cores ? "dead" : "nocore"]"
		layer = initial(layer)
	else if(feeding_on)
		var/mob/feed_mob = feeding_on.resolve()
		icon_state = "[icon_state]_eat"
		layer = feed_mob.layer + 0.5
	else
		layer = initial(layer)

	..()

	var/datum/ai/slime/slime_ai = ai
	if(stat != DEAD && istype(slime_ai) && slime_ai.mood)
		add_overlay(image(slime_data.mood_icon, "aslime-[slime_ai.mood]"))

	var/list/new_underlays
	for(var/atom/movable/AM in contents)
		var/mutable_appearance/MA = new(AM)
		MA.layer = FLOAT_LAYER
		MA.plane = FLOAT_PLANE
		// Revisit this on 514, alpha filters are behaving strangely on 513
		//MA.filters = filter(type="alpha", render_source="slime_\ref[src]", flags=MASK_INVERSE) 
		LAZYADD(new_underlays, MA)
	underlays = new_underlays
