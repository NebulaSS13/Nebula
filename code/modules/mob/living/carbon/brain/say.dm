/mob/living/brain/say(var/message, var/decl/language/speaking, var/verb = "says", var/alt_name = "", whispering)
	var/obj/item/mmi/container = get_container()
	if(silent || !istype(container))
		return
	if(prob(container.emp_damage*4))
		if(prob(10))
			return
		message = Gibberish(message, (container.emp_damage*6))
	. = ..(message, speaking, verb, alt_name, whispering)
	if(istype(container, /obj/item/mmi/radio_enabled))
		var/obj/item/mmi/radio_enabled/R = container
		if(R.radio)
			R.radio.hear_talk(src, sanitize(message), verb, speaking)
