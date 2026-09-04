/obj/item/organ/internal/brain_interface/radio_enabled
	name = "radio-enabled neural interface"
	desc = "A complex life support shell that interfaces between a brain and an electronic device. This one comes with a built-in radio."
	origin_tech = @'{"biotech":4}'
	VAR_PRIVATE/weakref/_radio

/obj/item/organ/internal/brain_interface/radio_enabled/empty
	holding_brain = null

/obj/item/organ/internal/brain_interface/radio_enabled/get_radio()
	var/obj/item/radio/radio_instance = _radio?.resolve()
	if(radio_instance && (!istype(radio_instance) || QDELETED(radio_instance) || radio_instance.loc != src))
		radio_instance = null
		_radio = null
	return radio_instance?.get_radio()

/obj/item/organ/internal/brain_interface/radio_enabled/Initialize()
	_radio = weakref(new /obj/item/radio(src))
	. = ..()

/obj/item/organ/internal/brain_interface/radio_enabled/Destroy()
	var/obj/item/radio/radio_instance = get_radio()
	if(radio_instance)
		qdel(radio_instance)
	_radio = null
	return ..()

/obj/item/organ/internal/brain_interface/proc/toggle_radio_broadcasting()
	set name = "Toggle Broadcasting"
	set desc = "Toggle broadcasting channel on or off."
	set category = "Brain Interface"
	set src in view(1)
	set popup_menu = 0

	if(usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You must be alive and conscious to interact with \the [src]."))
		return

	var/obj/item/radio/radio_instance = get_radio()
	if(istype(radio_instance))
		radio_instance.broadcasting = !radio_instance.broadcasting
		to_chat(usr, SPAN_NOTICE("You adjust the radio on \the [src]. It is [radio_instance.broadcasting ? "now broadcasting" : "no longer broadcasting"]."))
	else
		verbs -= /obj/item/organ/internal/brain_interface/proc/toggle_radio_broadcasting

/obj/item/organ/internal/brain_interface/proc/toggle_radio_listening()
	set name = "Toggle Listening"
	set desc = "Toggle listening channel on or off."
	set category = "Brain Interface"
	set src in view(1)

	set popup_menu = 0
	if(usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You must be alive and conscious to interact with \the [src]."))
		return
	var/obj/item/radio/radio_instance = get_radio()
	if(radio_instance)
		radio_instance.listening = !radio_instance.listening
		to_chat(usr, SPAN_NOTICE("You adjust the radio on \the [src]. It is [radio_instance.listening ? "now receiving broadcasts" : "no longer receiving broadcasts"]."))
	else
		verbs -= /obj/item/organ/internal/brain_interface/proc/toggle_radio_listening
