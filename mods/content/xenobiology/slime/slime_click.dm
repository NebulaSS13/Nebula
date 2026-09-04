/mob/living/slime/RestrainedClickOn(var/atom/A)
	return FALSE

/mob/living/slime/ResolveUnarmedAttack(var/atom/A)

	. = ..()
	if(.)
		return

	// Eating
	if(feeding_on || (locate(/mob) in contents))
		return FALSE

	//should have already been set if we are attacking a mob, but it doesn't hurt and will cover attacking non-mobs too
	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/mob/living/M = A
	if(!istype(M))
		A.attack_generic(src, (is_adult ? rand(20,40) : rand(5,25)), "glomped") // Basic attack.
		return TRUE

	if(check_intent(I_FLAG_HELP))
		M.visible_message( \
			SPAN_NOTICE("\The [src] gently pokes \the [M]."), \
			SPAN_NOTICE("\The [src] gently pokes you."))
		return TRUE

	var/power = max(0, min(10, (powerlevel + rand(0, 3))))
	if(check_intent(I_FLAG_DISARM))
		var/stun_prob = 1
		if(powerlevel > 0 && !isslime(A))
			switch(power * 10)
				if(0)      stun_prob *= 10
				if(1 to 2) stun_prob *= 20
				if(3 to 4) stun_prob *= 30
				if(5 to 6) stun_prob *= 40
				if(7 to 8) stun_prob *= 60
				if(9) 	   stun_prob *= 70
				if(10) 	   stun_prob *= 95
		if(prob(stun_prob))
			var/shock_damage = max(0, powerlevel-3) * rand(6,10)
			M.electrocute_act(shock_damage, src, 1.0, ran_zone())
		M.visible_message( \
			SPAN_DANGER("\The [src] pounces at \the [M]!"), \
			SPAN_DANGER("\The [src] pounces at you!"))
		if(prob(40))
			SET_STATUS_MAX(src, STAT_WEAK, (power * 0.5))
		return TRUE

	if(check_intent(I_FLAG_GRAB) && slime_attach(M))
		return TRUE

	if(check_intent(I_FLAG_HARM))
		if(prob(15) && !M.current_posture.prone)
			M.visible_message( \
				SPAN_DANGER("\The [src] pounces at \the [M]!"), \
				SPAN_DANGER("\The [src] pounces at you!"))
			SET_STATUS_MAX(M, STAT_WEAK, (power * 0.5))
		else
			A.attack_generic(src, (is_adult ? rand(20,40) : rand(5,25)), "glomped")
		return TRUE
	return FALSE
