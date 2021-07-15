/mob/living/carbon/alien/diona/on_update_icon()
	..()
	if(stat == DEAD)
		icon_state = "[initial(icon_state)]_dead"
	else if(incapacitated(INCAPACITATION_KNOCKOUT))
		icon_state = "[initial(icon_state)]_sleep"
	else
		icon_state = "[initial(icon_state)]"
		if(eyes)
			add_overlay(eyes)
		if(flower)
			add_overlay(flower)
		var/datum/extension/hattable/hattable = get_extension(src, /datum/extension/hattable)
		var/image/I = hattable?.get_hat_overlay(src)
		if(I)
			add_overlay(I)
