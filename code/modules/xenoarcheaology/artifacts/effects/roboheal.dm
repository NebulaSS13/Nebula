/datum/artifact_effect/roboheal
	name = "robotic healing"
	var/last_message

/datum/artifact_effect/roboheal/New()
	..()
	origin_type = pick(EFFECT_ELECTRO, EFFECT_PARTICLE)

/datum/artifact_effect/roboheal/DoEffectTouch(var/mob/user)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		to_chat(R, "<span class='notice'>Your systems report damaged components mending by themselves!</span>")
		R.heal_overall_damage(rand(10,30), rand(10,30))
		return 1

/datum/artifact_effect/roboheal/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/silicon/robot/M in range(effect_range,T))
			if(world.time - last_message > 200)
				to_chat(M, "<span class='notice'>SYSTEM ALERT: Beneficial energy field detected!</span>")
				last_message = world.time
			M.heal_overall_damage(1, 1)
		return 1

/datum/artifact_effect/roboheal/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/silicon/robot/M in range(effect_range,T))
			if(world.time - last_message > 200)
				to_chat(M, "<span class='notice'>SYSTEM ALERT: Structural damage has been repaired by energy pulse!</span>")
				last_message = world.time
			M.heal_overall_damage(10, 10)
		return 1
