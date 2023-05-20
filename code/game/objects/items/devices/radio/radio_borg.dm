/obj/item/radio/borg
	icon = 'icons/obj/robot_component.dmi' // Cyborgs radio icons should look like the component.
	icon_state = "radio"
	canhear_range = 0
	cell = null
	power_usage = 0
	is_spawnable_type = FALSE
	var/shut_up = 1

/obj/item/radio/borg/can_receive_message(var/check_network_membership)
	. = ..() && isrobot(loc)
	if(.)
		var/mob/living/silicon/robot/R = loc
		if(!R.handle_radio_transmission())
			return FALSE

/obj/item/radio/borg/ert
	encryption_keys = list(/obj/item/encryptionkey/ert)

/obj/item/radio/borg/syndicate
	encryption_keys = list(/obj/item/encryptionkey/hacked)

/obj/item/radio/borg/Initialize()
	. = ..()
	if(!isrobot(loc))
		. = INITIALIZE_HINT_QDEL
		CRASH("Invalid spawn location: [log_info_line(loc)]")

/obj/item/radio/borg/talk_into(mob/living/M, message, message_mode, var/verb = "says", var/decl/language/speaking = null)
	. = ..()
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = src.loc
		R.handle_radio_transmission()

/obj/item/radio/borg/OnTopic(mob/user, href_list, datum/topic_state/state)
	if((. = ..()))
		return

	if (href_list["shutup"]) // Toggle loudspeaker mode, AKA everyone around you hearing your radio.
		var/do_shut_up = text2num(href_list["shutup"])
		if(do_shut_up != shut_up)
			shut_up = !shut_up
			if(shut_up)
				canhear_range = 0
				to_chat(usr, SPAN_NOTICE("Loudspeaker disabled."))
			else
				canhear_range = 3
				to_chat(usr, SPAN_NOTICE("Loudspeaker enabled."))
			. = TOPIC_REFRESH
