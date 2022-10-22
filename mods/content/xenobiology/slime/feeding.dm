/mob/living/slime/proc/set_nutrition(var/amt)
	nutrition = Clamp(amt, 0, initial(nutrition))

/mob/living/slime/proc/check_valid_feed_target(var/mob/living/M, var/check_already_feeding = TRUE, var/silent = FALSE)
	if(QDELETED(M) || !istype(M) || !isturf(M.loc))
		return FEED_RESULT_INVALID
	if(M == src)
		if(!silent)
			to_chat(src, SPAN_WARNING("You cannot feed on yourself."))
		return FEED_RESULT_INVALID
	if(check_already_feeding && feeding_on)
		if(!silent)
			to_chat(src, SPAN_WARNING("You are already feeding on \the [feeding_on.resolve()]."))
		return FEED_RESULT_INVALID
	if(!istype(M) || issilicon(M) || isslime(M))
		if(!silent)
			to_chat(src, SPAN_WARNING("You cannot feed on \the [M]."))
		return FEED_RESULT_INVALID
	if(!Adjacent(M))
		if(!silent)
			to_chat(src, SPAN_WARNING("\The [M] is too far away."))
		return FEED_RESULT_INVALID
	if(M.get_blocked_ratio(null, TOX, damage_flags = DAM_DISPERSED | DAM_BIO) >= 1)
		if(!silent)
			to_chat(src, SPAN_WARNING("\The [M] is protected from your feeding."))
		return FEED_RESULT_INVALID
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.species_flags & (SPECIES_FLAG_NO_POISON|SPECIES_FLAG_NO_SCAN))
			if(!silent)
				to_chat(src, SPAN_WARNING("You cannot feed on \the [M]."))
			return FEED_RESULT_INVALID
	if(M.stat == DEAD)
		if(!silent)
			to_chat(src, SPAN_WARNING("\The [src] is dead."))
		return FEED_RESULT_DEAD
	if(M.getCloneLoss() >= M.maxHealth * 1.5)
		if(!silent)
			to_chat(src, SPAN_WARNING("\The [M] is too degraded to feed upon."))
		return FEED_RESULT_DEAD
	if(M.currently_being_eaten_by_a_slime(src))
		if(!silent)
			to_chat(src, SPAN_WARNING("Another slime is already feeding on \the [M]."))
		return FEED_RESULT_INVALID
	return FEED_RESULT_VALID

/mob/living/slime/proc/set_feeding_on(var/mob/living/victim)
	if(feeding_on == weakref(victim))
		return
	if(feeding_on)
		var/mob/feed_mob = feeding_on.resolve()
		events_repository.unregister(/decl/observ/moved, src, src)
		events_repository.unregister(/decl/observ/moved, feed_mob, src)
		events_repository.unregister(/decl/observ/destroyed, feed_mob, src)
		feeding_on = null
	if(victim)
		feeding_on = weakref(victim)
		events_repository.register(/decl/observ/moved, src, src, /mob/living/slime/proc/check_feed_target_position)
		events_repository.register(/decl/observ/moved, victim, src, /mob/living/slime/proc/check_feed_target_position)
		events_repository.register(/decl/observ/destroyed, victim, src, /mob/living/slime/proc/check_feed_target_position)
	var/datum/ai/slime/slime_ai = ai
	if(istype(slime_ai))
		slime_ai.update_mood()
	update_icon()

/mob/living/slime/proc/slime_attach(var/mob/living/M)
	if(check_valid_feed_target(M) == FEED_RESULT_VALID)
		set_feeding_on(M)
		forceMove(get_turf(M))
		M.update_personal_goal(/datum/goal/achievement/dont_let_slime_snack_you, FALSE)

/mob/living/slime/proc/check_feed_target_position()
	var/mob/feed_mob = feeding_on?.resolve()
	if(istype(feed_mob) && !QDELETED(feed_mob) && isturf(feed_mob.loc))
		if(loc == feed_mob.loc)
			return TRUE
		if(Adjacent(feed_mob))
			forceMove(get_turf(feed_mob))
			return TRUE
	set_feeding_on()
	return FALSE

/mob/living/slime/proc/slime_feed()

	if(stat != CONSCIOUS)
		return FALSE

	var/mob/living/feed_mob = feeding_on?.resolve()
	if(!istype(feed_mob) || !check_feed_target_position())
		return FALSE

	var/ate_victim = FALSE
	var/feed_result = check_valid_feed_target(feed_mob, check_already_feeding = FALSE)
	if(feed_result != FEED_RESULT_VALID)
		if(feed_result == FEED_RESULT_DEAD)
			ate_victim = TRUE
		else
			set_feeding_on()
			return FALSE
	else
		var/drained = feed_mob.slime_feed_act(src)
		if(!drained || QDELETED(feed_mob) || check_valid_feed_target(feed_mob, check_already_feeding = FALSE, silent = TRUE) == FEED_RESULT_DEAD)
			ate_victim = TRUE
		if(drained)
			gain_nutrition(drained)
			var/heal_amt = FLOOR(drained*0.5)
			if(heal_amt > 0)
				adjustOxyLoss(-heal_amt)
				adjustBruteLoss(-heal_amt)
				adjustCloneLoss(-heal_amt)

	if(ate_victim && feed_mob)
		if(feed_mob.last_handled_by_mob)
			var/mob/friend = feed_mob.last_handled_by_mob.resolve()
			if(istype(friend) && friend != feed_mob)
				adjust_friendship(friend, 1)
		set_feeding_on()

	return !ate_victim
