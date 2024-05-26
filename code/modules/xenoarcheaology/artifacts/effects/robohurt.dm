/datum/artifact_effect/robohurt
	name = "robotic harm"
	var/last_message

/datum/artifact_effect/robohurt/New()
	..()
	origin_type = pick(EFFECT_ELECTRO, EFFECT_PARTICLE)

/datum/artifact_effect/robohurt/DoEffectTouch(var/mob/user)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		to_chat(R, "<span class='danger'>Your systems report severe damage has been inflicted!</span>")
		R.take_damage(rand(10,50), damage_flags = DAM_DISPERSED, do_update_health = FALSE)
		R.take_damage(rand(10,50), BURN, damage_flags = DAM_DISPERSED)
		return 1

/datum/artifact_effect/robohurt/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/silicon/robot/M in range(effect_range,T))
			if(world.time - last_message > 200)
				to_chat(M, "<span class='danger'>SYSTEM ALERT: Harmful energy field detected!</span>")
				last_message = world.time
			M.take_damage(1, damage_flags = DAM_DISPERSED, do_update_health = FALSE)
			M.take_damage(1, BURN, damage_flags = DAM_DISPERSED)
		return 1

/datum/artifact_effect/robohurt/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/silicon/robot/M in range(effect_range,T))
			if(world.time - last_message > 200)
				to_chat(M, "<span class='danger'>SYSTEM ALERT: Structural damage inflicted by energy pulse!</span>")
				last_message = world.time
				M.take_damage(10, damage_flags = DAM_DISPERSED, do_update_health = FALSE)
				M.take_damage(10, BURN, damage_flags = DAM_DISPERSED)
		return 1
