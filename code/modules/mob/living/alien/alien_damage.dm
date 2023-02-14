/mob/living/carbon/alien/explosion_act(severity)
	..()
	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1)
			b_loss += 500
			gib()
		if (2.0)
			b_loss += 60
			f_loss += 60
			SET_STATUS_MAX(src, STAT_TINNITUS, 30)
			SET_STATUS_MAX(src, STAT_DEAF, 120)
		if(3)
			b_loss += 30
			if (prob(50))
				SET_STATUS_MAX(src, STAT_PARA, 1)
			SET_STATUS_MAX(src, STAT_TINNITUS, 15)
			SET_STATUS_MAX(src, STAT_DEAF, 60)
	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)
	updatehealth()
