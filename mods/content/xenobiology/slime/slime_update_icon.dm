/mob/living/slime/on_update_icon()

	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	icon = (stat != DEAD && is_adult) ? slime_data.adult_icon : slime_data.baby_icon // dead adults have no icon
	icon_state = initial(icon_state)
	if(stat == DEAD)
		icon_state = "[icon_state]-[cores ? "dead" : "nocore"]"
	else if(feeding_on)
		icon_state = "[icon_state]-eat"
	reset_layer()

	..()

	var/datum/mob_controller/slime/slime_ai = ai
	if(stat != DEAD && istype(slime_ai) && slime_ai.mood)
		add_overlay(image(slime_data.mood_icon, "aslime-[slime_ai.mood]"))

	var/list/new_underlays
	for(var/atom/movable/AM in contents)
		var/mutable_appearance/MA = new(AM)
		MA.layer = FLOAT_LAYER
		MA.plane = FLOAT_PLANE
		MA.add_filter("slime_mask", 1, list(type = "alpha", render_source="slime_\ref[src]"))
		LAZYADD(new_underlays, MA)
	underlays = new_underlays

/mob/living/slime/get_base_layer()
	if(stat != DEAD && feeding_on)
		var/atom/feed_mob = feeding_on.resolve()
		if(istype(feed_mob))
			return max(ABOVE_HUMAN_LAYER, feed_mob.layer + 0.5)
	return ..()
