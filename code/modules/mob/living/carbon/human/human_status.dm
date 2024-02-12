/mob/living/carbon/human/set_status(condition, amount)
	switch(condition)
		if(STAT_WEAK)
			amount *= species.weaken_mod
		if(STAT_STUN)
			amount *= species.stun_mod
		if(STAT_PARA)
			amount *= species.paralysis_mod
	. = ..()

/mob/living/carbon/human/handle_status_effects()
	if((ssd_check() && species.get_ssd(src)) || player_triggered_sleeping)
		SET_STATUS_MAX(src, STAT_ASLEEP, 2)
	. = ..()
