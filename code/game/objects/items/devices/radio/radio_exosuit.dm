//The exosuit  radio subtype. It allows pilots to interact and consumes exosuit power
/obj/item/radio/exosuit
	name = "exosuit radio"
	cell = null

/obj/item/radio/exosuit/get_cell()
	. = ..()
	if(!. && istype(loc, /mob/living/exosuit))
		var/mob/living/exosuit/E = loc
		return E.get_cell()

/obj/item/radio/exosuit/nano_host()
	if(istype(loc, /mob/living/exosuit))
		return loc

/obj/item/radio/exosuit/attack_self(var/mob/user)
	var/mob/living/exosuit/exosuit = loc
	if(istype(exosuit) && exosuit.head && exosuit.head.radio && exosuit.head.radio.is_functional())
		user.set_machine(src)
		interact(user)
	else
		to_chat(user, SPAN_WARNING("The radio is too damaged to function."))

/obj/item/radio/exosuit/CanUseTopic()
	. = ..()
	if(.)
		var/mob/living/exosuit/exosuit = loc
		if(istype(exosuit) && exosuit.head && exosuit.head.radio && exosuit.head.radio.is_functional())
			return ..()

/// Overridden solely to change the default topic state supplied.
/obj/item/radio/exosuit/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.mech_topic_state)
	. = ..()
