/decl/chat_filter/regexp/markdown
	filter_category = /decl/chat_filter/regexp/markdown
	can_modify_message = TRUE
	var/format_char
	var/format_replace_proc

/decl/chat_filter/regexp/markdown/New()
	..()
	filter_regex = regex("([format_char])(.+)([format_char])", "g")

/decl/chat_filter/regexp/markdown/replace(var/message, var/match)
	. = filter_regex.Replace(message, format_replace_proc)

/proc/chatFilterRegexBold(full_match, prefix_char, message_body, suffix_char)
	. = "<b>[message_body]</b>"

/decl/chat_filter/regexp/markdown/bold
	name = "Bold"
	summary = "Applies <b>bold</b> to speech and emote text that is surrounded by *asterisks*."
	format_char = "\\*"
	format_replace_proc = /proc/chatFilterRegexBold

/proc/chatFilterRegexItalic(full_match, prefix_char, message_body, suffix_char)
	. = "<i>[message_body]</i>"

/decl/chat_filter/regexp/markdown/italic
	name = "Italics"
	summary = "Applies <i>italics</i> to speech and emote text that is surrounded by _underscores_."
	format_char = "_"
	format_replace_proc = /proc/chatFilterRegexItalic
