/obj/item/brain_interface/organic/radio_enabled
	name = "radio-enabled man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."
	origin_tech = "{'biotech':4}"

/obj/item/brain_interface/organic/radio_enabled/empty
	holding_brain = null

/obj/item/brain_interface/organic/radio_enabled/Initialize()
	new /obj/item/radio(src)
	. = ..()

/obj/item/brain_interface/proc/toggle_radio_broadcasting()
	set name = "Toggle Broadcasting"
	set desc = "Toggle broadcasting channel on or off."
	set category = "Brain Interface"
	set src = usr.loc
	set popup_menu = 0
	if(usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You must be alive and conscious to interact with \the [src]."))
		return
	var/obj/item/radio/radio = (locate() in src)
	if(radio)
		radio.broadcasting = !radio.broadcasting
		to_chat(usr, SPAN_NOTICE("You adjust the radio on \the [src]. It is [radio.broadcasting ? "now broadcasting" : "no longer broadcasting"]."))
	else
		verbs -= /obj/item/brain_interface/proc/toggle_radio_broadcasting

/obj/item/brain_interface/proc/toggle_radio_listening()
	set name = "Toggle Listening"
	set desc = "Toggle listening channel on or off."
	set category = "Brain Interface"
	set src = usr.loc
	set popup_menu = 0
	if(usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You must be alive and conscious to interact with \the [src]."))
		return
	var/obj/item/radio/radio = (locate() in src)
	if(radio)
		radio.listening = !radio.listening
		to_chat(usr, SPAN_NOTICE("You adjust the radio on \the [src]. It is [radio.listening ? "now receiving broadcasts" : "no longer receiving broadcasts"]."))
	else
		verbs -= /obj/item/brain_interface/proc/toggle_radio_listening