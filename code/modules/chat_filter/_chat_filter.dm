var/global/list/chat_blockers_in_use
var/global/list/chat_modifiers_in_use

/proc/_get_chat_filters_in_use()
	global.chat_blockers_in_use = list()
	global.chat_modifiers_in_use = list()
	for(var/decl/chat_filter/chat_filter in decls_repository.get_decls_of_type_unassociated(/decl/chat_filter))
		if(chat_filter.disabled)
			continue
		if(chat_filter.can_deny_message)
			global.chat_blockers_in_use += chat_filter
		if(chat_filter.can_modify_message)
			global.chat_modifiers_in_use += chat_filter

/proc/get_chat_blockers_in_use()
	if(!global.chat_blockers_in_use)
		_get_chat_filters_in_use()
	return global.chat_blockers_in_use

/proc/get_chat_modifiers_in_use()
	if(!global.chat_modifiers_in_use)
		_get_chat_filters_in_use()
	return global.chat_modifiers_in_use

/proc/filter_block_message(var/mob/speaker, var/msg)
	for(var/decl/chat_filter/chat_filter in get_chat_blockers_in_use())
		var/match = chat_filter.match(msg)
		if(match)
			var/deny_msg = chat_filter.deny(speaker, match)
			if(deny_msg)
				to_chat(speaker, SPAN_WARNING(deny_msg))
				return TRUE

/proc/filter_modify_message(var/msg)
	. = msg
	for(var/decl/chat_filter/chat_filter in get_chat_modifiers_in_use())
		var/match = chat_filter.match(.)
		if(match)
			. = chat_filter.replace(., match)

/decl/chat_filter
	abstract_type = /decl/chat_filter
	var/name
	var/disabled
	var/summary
	var/can_modify_message = FALSE
	var/can_deny_message = FALSE

/decl/chat_filter/proc/match(var/message)
	return

/decl/chat_filter/proc/deny(var/match)
	return

/decl/chat_filter/proc/replace(var/message, var/match)
	. = message

/client/verb/check_message_filters()
	set name = "Check Message Filters"
	set category = "OOC"
	var/list/blockers_in_use = get_chat_blockers_in_use()
	if(length(blockers_in_use))
		to_chat(usr, "<b>The following filters are being used to block messages:</b><hr>")
		for(var/decl/chat_filter/chat_filter in blockers_in_use)
			to_chat(usr, "<b>[chat_filter.name]</b><br>[chat_filter.summary]<hr>")
	else
		to_chat(usr, "<b>There are no filters being used to block messages currently.</b>")

/client/verb/check_message_modifiers()
	set name = "Check Message Modifiers"
	set category = "OOC"
	var/list/modifiers_in_use = get_chat_modifiers_in_use()
	if(length(modifiers_in_use))
		to_chat(usr, "<b>The following filters can be used to modify messages:</b><hr>")
		for(var/decl/chat_filter/chat_filter in modifiers_in_use)
			to_chat(usr, "<b>[chat_filter.name]</b><br>[chat_filter.summary]<hr>")
	else
		to_chat(usr, "<b>There are no available filters for modifying messages currently.</b>")
