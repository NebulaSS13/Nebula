/datum/artifact_effect/badfeeling
	name = "badfeeling"
	origin_type = EFFECT_PSIONIC
	var/static/list/messages = list("You feel worried.",
		"Something doesn't feel right.",
		"You get a strange feeling in your gut.",
		"Your instincts are trying to warn you about something.",
		"Someone just walked over your grave.",
		"There's a strange feeling in the air.",
		"There's a strange smell in the air.",
		"The tips of your fingers feel tingly.",
		"You feel witchy.",
		"You have a terrible sense of foreboding.",
		"You've got a bad feeling about this.",
		"Your scalp prickles.",
		"The light seems to flicker.",
		"The shadows seem to lengthen.",
		"The walls are getting closer.",
		"Something is wrong.")

	var/static/list/drastic_messages = list("You've got to get out of here!",
		"Someone's trying to kill you!",
		"There's something out there!",
		"What's happening to you?",
		"OH GOD!",
		"HELP ME!")

/datum/artifact_effect/badfeeling/DoEffectTouch(var/mob/user)
	if(ishuman(user))
		affect_human(user, 50, 50)
		return 1

/datum/artifact_effect/badfeeling/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/human/H in range(effect_range,T))
			affect_human(H, 5, 10)
		return 1

/datum/artifact_effect/badfeeling/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/human/H in range(effect_range,T))
			affect_human(H, 50, 50)
		return 1

/datum/artifact_effect/badfeeling/proc/affect_human(mob/living/human/H, message_prob, dizziness_prob)
	if(H.stat)
		return
	if(prob(message_prob))
		if(prob(75))
			to_chat(H, SPAN_WARNING(pick(messages)))
		else
			to_chat(H, SPAN_DANGER(pick(drastic_messages)))

	if(prob(dizziness_prob))
		ADJ_STATUS(H, STAT_DIZZY, rand(3,5))