var/global/list/ckey_to_actions = list()
var/global/list/ckey_to_act_time = list()
var/global/list/ckey_punished_for_spam = list() // this round; to avoid redundant record-keeping.

// Should be checked on all instant client verbs.
/proc/user_acted(client/C, admin_message = "was kicked due to possible spam abuse.", client_message = "Possible spam abuse detected; you are being kicked from the server.")
	var/ckey = C && C.ckey
	if(!ckey)
		return FALSE
	if(get_config_value(/decl/config/toggle/do_not_prevent_spam))
		return TRUE
	var/time = world.time
	if(global.ckey_to_act_time[ckey] + (get_config_value(/decl/config/num/act_interval) SECONDS) < time)
		global.ckey_to_act_time[ckey] = time
		global.ckey_to_actions[ckey] = 1
		return TRUE
	if(global.ckey_to_actions[ckey] <= get_config_value(/decl/config/num/max_acts_per_interval))
		global.ckey_to_actions[ckey]++
		return TRUE

	// Punitive action
	. = FALSE
	if(admin_message)
		log_and_message_admins(admin_message, C)
	if(client_message)
		to_chat(C, SPAN_DANGER(client_message))
	if(global.ckey_punished_for_spam[ckey])
		qdel(C)
		return
	global.ckey_punished_for_spam[ckey] = TRUE
	notes_add(ckey, "\[AUTO\] Kicked for possible spam abuse.")
	qdel(C)

/client/Center()
	if(!user_acted(src))
		return
	return ..()

/client/DblClick()
	if(!user_acted(src))
		return
	return ..()

/client/MouseDrop(src_object, over_object, src_location, over_location, src_control, over_control, params)
	. = user_acted(src) && ..()
