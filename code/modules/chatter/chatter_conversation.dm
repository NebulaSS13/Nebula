
/datum/chatter_conversation
	var/current_line
	var/list/chatter_lines

/datum/chatter_conversation/proc/step_to_next_line()
	current_line++
	. = current_line <= length(chatter_lines)

/datum/chatter_conversation/proc/step_to_previous_line()
	current_line--
	. = current_line >= 1

/datum/chatter_conversation/proc/get_message_details()
	var/datum/chatter_line/chat = chatter_lines[current_line]
	return list(chat.speaker, chat.subject, chat.message)

/datum/chatter_conversation/proc/reset()
	current_line = 1

/datum/chatter_conversation/New()
	..()
	create_lines()

/datum/chatter_conversation/proc/create_lines()
	return