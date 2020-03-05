/client/verb/ooc(message as text)
	set name = "OOC"
	set category = "OOC"

	sanitize_and_communicate(/decl/communication_channel/ooc, src, message)
	mob.log_individual_message(sanitize(message), INDIVIDUAL_OOC_LOG, key_name(src, include_name = FALSE))

/client/verb/looc(message as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view. Remember: Just because you see someone that doesn't mean they see you."
	set category = "OOC"

	sanitize_and_communicate(/decl/communication_channel/ooc/looc, src, message)
