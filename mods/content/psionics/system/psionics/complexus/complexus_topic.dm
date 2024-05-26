/datum/ability_handler/psionics/CanUseTopic(var/mob/user, var/datum/topic_state/state = global.default_topic_state)
	return (user.client && check_rights(R_ADMIN, FALSE, user.client))

/datum/ability_handler/psionics/Topic(var/href, var/list/href_list)
	. = ..()
	if(!. && check_rights(R_ADMIN))
		if(href_list["remove_psionics"])
			if(owner?.get_ability_handler(/datum/ability_handler/psionics) == src && !QDELETED(src))
				log_and_message_admins("removed all psionics from [key_name(owner)].")
				to_chat(owner, SPAN_NOTICE("<b>Your psionic powers vanish abruptly, leaving you cold and empty.</b>"))
				QDEL_NULL(src)
			. = TRUE
		if(href_list["trigger_psi_latencies"])
			log_and_message_admins("triggered psi latencies for [key_name(owner)].")
			check_latency_trigger(100, "outside intervention", redactive = TRUE)
			. = TRUE
		if(.)
			var/datum/admins/admin = global.admins[usr.key]
			if(istype(admin))
				admin.show_player_panel(owner)