/datum/chatter_line
	var/speaker
	var/subject
	var/message

/datum/chatter_line/New(var/_speaker, var/_subject, var/_message)
	..()
	speaker = _speaker
	subject = _subject
	message = _message
