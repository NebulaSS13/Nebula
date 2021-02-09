/mob/living/brain/say(var/message, var/decl/language/speaking = null, var/verb="says", var/alt_name="", whispering)
	var/obj/item/mmi/container = get_container()
	if(silent || !istype(container)
		return
	if(prob(emp_damage*4))
		if(prob(10))//10% chane to drop the message entirely
			return
		message = Gibberish(message, (emp_damage*6))
	. = ..(message, speaking, verb, alt_name, whispering)
	if(istype(container, /obj/item/mmi/radio_enabled))
		var/obj/item/mmi/radio_enabled/R = container
		if(R.radio)
			 R.radio.hear_talk(src, sanitize(message), verb, speaking)
