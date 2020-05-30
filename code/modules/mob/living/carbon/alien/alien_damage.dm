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
			ear_damage += 30
			ear_deaf += 120
		if(3)
			b_loss += 30
			if (prob(50))
				Paralyse(1)
			ear_damage += 15
			ear_deaf += 60
	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)
	updatehealth()
