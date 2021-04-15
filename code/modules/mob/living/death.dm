/mob/living/death(gibbed, deathmessage="seizes up and falls limp...", show_dead_message)
	. = ..(gibbed, deathmessage, show_dead_message)
	if(hiding)
		hiding = FALSE
	if(.)
		stop_aiming(no_message=1)
