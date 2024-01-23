//Spiderling skitters
/datum/hallucination/skitter/start()
	. = ..()
	to_chat(holder, SPAN_NOTICE("The spiderling skitters[pick(" away"," around","")]."))
