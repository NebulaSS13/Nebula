/mob/living/brain/say(var/message, var/decl/language/speaking, var/verb = "says", var/alt_name = "", whispering)
	var/obj/item/brain_interface/container = get_container()
	if(GET_STATUS(src, STAT_SILENCE) || !istype(container))
		return
	if(prob(container.emp_damage*4))
		if(prob(10))
			return
		message = Gibberish(message, (container.emp_damage*6))
	. = ..(message, speaking, verb, alt_name, whispering)
	if(istype(container, /obj/item/brain_interface))
		var/obj/item/radio/radio = locate() in container
		if(radio)
			radio.hear_talk(src, sanitize(message), verb, speaking)
