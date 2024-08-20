/mob/living/brain/say(var/message, var/decl/language/speaking, var/verb = "says", whispering)
	if(GET_STATUS(src, STAT_SILENCE) || !is_in_interface())
		return
	if(prob(emp_damage*4))
		if(prob(10))
			return
		message = Gibberish(message, (emp_damage*6))
	. = ..(message, speaking, verb, whispering)
	var/obj/item/radio/radio = get_radio()
	if(radio)
		radio.hear_talk(src, sanitize(message), verb, speaking)

/mob/living/brain/get_radio()
	var/obj/item/organ/internal/brain_interface/container = get_container()
	if(istype(container))
		return container.get_radio()
