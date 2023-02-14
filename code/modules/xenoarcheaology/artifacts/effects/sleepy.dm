//todo
/datum/artifact_effect/sleepy
	name = "sleepy"
	var/static/list/sleepy_messages = list(
		"You feel like taking a nap.",
		"You feel a yawn coming on.",
		"You feel a little tired."
	)

/datum/artifact_effect/sleepy/New()
	..()
	origin_type = pick(EFFECT_PSIONIC, EFFECT_ORGANIC)

/datum/artifact_effect/sleepy/DoEffectTouch(var/mob/living/toucher)
	if(istype(toucher))
		if(ishuman(toucher))
			sleepify(toucher, rand(5,25), 50, 100)
			return 1

/datum/artifact_effect/sleepy/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/human/H in range(effect_range,T))
			sleepify(H, 2, 25, 10)
		return 1

/datum/artifact_effect/sleepy/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/human/H in range(effect_range, T))
			sleepify(H, rand(5,15), 50, 50)
		return 1

/datum/artifact_effect/sleepy/proc/sleepify(mob/living/human/H, speed, limit, message_prob)
	var/weakness = GetAnomalySusceptibility(H)
	if(prob(weakness * 100))
		if(H.isSynthetic())
			if(prob(message_prob))
				to_chat(H, SPAN_WARNING("SYSTEM ALERT: CPU cycles slowing down."))
			return
		if(prob(message_prob))
			to_chat(H, SPAN_NOTICE(pick(sleepy_messages)))
		H.set_status(STAT_DROWSY, min(GET_STATUS(H, STAT_DROWSY) + speed * weakness, limit * weakness))
		H.set_status(STAT_BLURRY, min(GET_STATUS(H, STAT_BLURRY) + speed * weakness, limit * weakness))