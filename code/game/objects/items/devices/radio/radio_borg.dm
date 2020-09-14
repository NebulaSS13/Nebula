/obj/item/radio/borg
	icon = 'icons/obj/robot_component.dmi' // Cyborgs radio icons should look like the component.
	icon_state = "radio"
	canhear_range = 0
	peer_to_peer = TRUE
	cell = null
	power_usage = 0
	var/shut_up = 1

/obj/item/radio/borg/can_receive_message(var/check_network_membership)
	. = ..()
	if(.)
		var/mob/living/silicon/robot/myborg = loc
		if(istype(myborg))
			var/datum/robot_component/CO = myborg.get_component("radio")
			if(!CO || !myborg.is_component_functioning("radio") || !myborg.cell_use_power(CO.active_usage))
				. = FALSE

/obj/item/radio/borg/ert
	encryption_keys = list(/obj/item/encryptionkey/ert)

/obj/item/radio/borg/syndicate
	encryption_keys = list(/obj/item/encryptionkey/syndicate)

/obj/item/radio/borg/Initialize()
	. = ..()
	if(!isrobot(loc))
		. = INITIALIZE_HINT_QDEL
		CRASH("Invalid spawn location: [log_info_line(loc)]")

/obj/item/radio/borg/talk_into()
	. = ..()
	if (isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		var/datum/robot_component/C = R.components["radio"]
		R.cell_use_power(C.active_usage)

/obj/item/radio/borg/attackby(obj/item/W, mob/user)
	. = ..()

/obj/item/radio/borg/Topic(href, href_list)
	if(..())
		return 1
	if (href_list["mode"])
		var/enable_peer_to_peer = text2num(href_list["mode"])
		if(enable_peer_to_peer != peer_to_peer)
			peer_to_peer = !peer_to_peer
			if(peer_to_peer)
				to_chat(usr, SPAN_NOTICE("Ad hoc local transmission is enabled. You will not need a network hub to communicate by radio, but will have limited range."))
			else
				to_chat(usr, SPAN_NOTICE("Ad hoc local transmission is disabled. You will now require a network hub for radio communication."))
		. = 1
	if (href_list["shutup"]) // Toggle loudspeaker mode, AKA everyone around you hearing your radio.
		var/do_shut_up = text2num(href_list["shutup"])
		if(do_shut_up != shut_up)
			shut_up = !shut_up
			if(shut_up)
				canhear_range = 0
				to_chat(usr, "<span class='notice'>Loadspeaker disabled.</span>")
			else
				canhear_range = 3
				to_chat(usr, "<span class='notice'>Loadspeaker enabled.</span>")
		. = 1

	if(.)
		SSnano.update_uis(src)
