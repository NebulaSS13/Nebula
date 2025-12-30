/datum/artifact_effect/robohurt
	name = "robotic harm"
	var/last_message

/datum/artifact_effect/robohurt/New()
	..()
	origin_type = pick((XA_EFFECT_ELECTRO), (XA_EFFECT_PARTICLE))

/datum/artifact_effect/robohurt/DoEffectTouch(var/mob/user)
	if(isrobot(user))
		var/mob/living/silicon/robot/robot = user
		to_chat(robot, "<span class='danger'>Your systems report severe damage has been inflicted!</span>")
		robot.take_overall_damage(rand(10,50), rand(10,50))
		return 1

/datum/artifact_effect/robohurt/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/silicon/robot/M in range(effect_range,T))
			if(world.time - last_message > 200)
				to_chat(M, "<span class='danger'>SYSTEM ALERT: Harmful energy field detected!</span>")
				last_message = world.time
			M.take_overall_damage(1,1)
		return 1

/datum/artifact_effect/robohurt/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/silicon/robot/M in range(effect_range,T))
			if(world.time - last_message > 200)
				to_chat(M, "<span class='danger'>SYSTEM ALERT: Structural damage inflicted by energy pulse!</span>")
				last_message = world.time
			M.take_overall_damage(10,10)
		return 1
