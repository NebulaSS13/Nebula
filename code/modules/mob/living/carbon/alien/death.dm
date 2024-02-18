/mob/living/carbon/alien/get_death_message(gibbed)
	return death_msg

/mob/living/carbon/alien/death(gibbed)
	. = ..()
	if(. && !gibbed && dead_icon)
		icon_state = dead_icon
