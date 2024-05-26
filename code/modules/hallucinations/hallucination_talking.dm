//Hearing someone talking to/about you.
/datum/hallucination/talking/can_affect(var/mob/living/victim)
	return ..() && (locate(/mob/living) in oview(victim))

/datum/hallucination/talking/start()
	. = ..()
	var/sanity = 5 //even insanity needs some sanity
	for(var/mob/living/talker in oview(holder))
		if(talker.stat)
			continue
		var/message
		if(prob(80))
			var/list/names = list()
			var/lastname = copytext(holder.real_name, findtext(holder.real_name, " ")+1)
			var/firstname = copytext(holder.real_name, 1, findtext(holder.real_name, " "))
			if(lastname) names += lastname
			if(firstname) names += firstname
			if(!names.len)
				names += holder.real_name
			var/add = prob(20) ? ", [pick(names)]" : ""
			var/list/phrases = list("[prob(50) ? "Hey, " : ""][pick(names)]!","[prob(50) ? "Hey, " : ""][pick(names)]?","Get out[add]!","Go away[add].","What are you doing[add]?","Where's your ID[add]?")
			if(holder.hallucination_power > 50)
				phrases += list("What did you come here for[add]?","Don't touch me[add].","You're not getting out of here[add].", "You are a failure, [pick(names)].","Just kill yourself already, [pick(names)].","Put on some clothes[add].","Take off your clothes[add].")
			message = pick(phrases)
			to_chat(holder,"<span class='game say'><span class='name'>[talker.name]</span> [holder.say_quote(message)], <span class='message'><span class='body'>\"[message]\"</span></span></span>")
		else
			to_chat(holder,"<B>[talker.name]</B> points at [holder.name]")
			to_chat(holder,"<span class='game say'><span class='name'>[talker.name]</span> says something softly.</span>")

		var/speech_state = holder.check_speech_punctuation_state(message)
		if(speech_state)
			var/image/speech_bubble = image('icons/mob/talk.dmi', talker, speech_state)
			addtimer(CALLBACK(src, PROC_REF(qdel_image), speech_bubble), 3 SECONDS)
			show_image(holder, speech_bubble)

		sanity-- //don't spam them in very populated rooms.
		if(!sanity)
			break

/datum/hallucination/talking/proc/qdel_image(var/image/speech_bubble)
	qdel(speech_bubble)
