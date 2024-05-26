//Fake attack
/datum/hallucination/fakeattack
	min_power = 30

/datum/hallucination/fakeattack/can_affect(var/mob/living/victim)
	. = ..() && (locate(/mob/living) in oview(victim,1))

/datum/hallucination/fakeattack/start()
	. = ..()
	for(var/mob/living/assailant in oview(holder,1))
		to_chat(holder, SPAN_DANGER("\The [assailant] has punched \the [holder]!"))
		holder.playsound_local(get_turf(holder),"punch",50)

//Fake injection
/datum/hallucination/fakeattack/hypo
	min_power = 30

/datum/hallucination/fakeattack/hypo/start()
	. = ..()
	to_chat(holder, SPAN_NOTICE("You feel a tiny prick!"))
