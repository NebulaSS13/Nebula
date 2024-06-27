/mob/living/human
	var/skin_state = SKIN_NORMAL

/mob/living/human/proc/reset_skin()
	if(skin_state == SKIN_THREAT)
		skin_state = SKIN_NORMAL
		update_skin()