/datum/artifact_effect/goodfeeling
	name = "good feeling"
	origin_type = EFFECT_PSIONIC
	var/static/list/messages = list("You feel good.",
		"Everything seems to be going alright.",
		"You've got a good feeling about this.",
		"Your instincts tell you everything is going to be getting better.",
		"There's a good feeling in the air.",
		"Something smells... good.",
		"The tips of your fingers feel tingly.",
		"You've got a good feeling about this.",
		"You feel happy.",
		"You fight the urge to smile.",
		"Your scalp prickles.",
		"All the colours seem a bit more vibrant.",
		"Everything seems a little lighter.",
		"The troubles of the world seem to fade away.")

	var/static/list/drastic_messages = list("You want to hug everyone you meet!",
		"Everything is going so well!",
		"You feel euphoric.",
		"You feel giddy.",
		"You're so happy suddenly, you almost want to dance and sing.",
		"You feel like the world is out to help you.")

/datum/artifact_effect/goodfeeling/DoEffectTouch(var/mob/user)
	if(ishuman(user))
		affect_human(user, 50, 50)
		return 1

/datum/artifact_effect/goodfeeling/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/human/H in range(effect_range,T))
			affect_human(H, 5, 5)
		return 1

/datum/artifact_effect/goodfeeling/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/human/H in range(effect_range,T))
			affect_human(H, 50, 50)
		return 1

/datum/artifact_effect/goodfeeling/proc/affect_human(mob/living/human/H, message_prob, dizziness_prob)
	if(H.stat)
		return
	if(prob(message_prob))
		if(prob(75))
			to_chat(H, SPAN_NOTICE(pick(messages)))
		else
			to_chat(H, SPAN_NOTICE(pick(drastic_messages)))

	if(prob(dizziness_prob))
		ADJ_STATUS(H, STAT_DIZZY, rand(3,5))
