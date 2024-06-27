/obj/item/assembly/voice
	name = "voice analyzer"
	desc = "A small electronic device able to record a voice sample, and send a signal when that sample is repeated."
	icon_state = "voice"
	origin_tech = @'{"magnets":1}'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_TRACE
	)
	var/listening = 0
	var/recorded	//the activation message

/obj/item/assembly/voice/Initialize()
	. = ..()
	global.listening_objects += src

/obj/item/assembly/voice/hear_talk(mob/living/M, msg)
	if(listening)
		recorded = msg
		listening = 0
		var/turf/T = get_turf(src)	//otherwise it won't work in hand
		T.visible_message("[html_icon(src)] beeps, \"Activation message is '[recorded]'.\"")
	else
		if(findtext(msg, recorded))
			pulse_device(0)

/obj/item/assembly/voice/activate()
	if(secured)
		if(!holder)
			listening = !listening
			var/turf/T = get_turf(src)
			T.visible_message("[html_icon(src)] beeps, \"[listening ? "Now" : "No longer"] recording input.\"")


/obj/item/assembly/voice/attack_self(mob/user)
	if(!user)	return 0
	activate()
	return 1


/obj/item/assembly/voice/toggle_secure()
	. = ..()
	listening = 0
