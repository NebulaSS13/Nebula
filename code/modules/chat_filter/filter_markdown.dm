/decl/chat_filter/regexp/markdown
	abstract_type = /decl/chat_filter/regexp/markdown
	can_modify_message = TRUE
	var/format_char
	var/format_replace_proc

/decl/chat_filter/regexp/markdown/Initialize()
	. = ..()
	filter_regex = regex("([REGEX_QUOTE(format_char)])(.+?)([REGEX_QUOTE(format_char)])", "g")

/decl/chat_filter/regexp/markdown/replace(var/message, var/match)
	. = filter_regex.Replace(message, format_replace_proc)

/proc/chatFilterRegexBold(full_match, prefix_char, message_body, suffix_char)
	. = "<b>[trim(message_body)]</b>"

/decl/chat_filter/regexp/markdown/bold
	name = "Bold"
	summary = "Applies <b>bold</b> to speech and emote text that is surrounded by *asterisks*."
	format_char = "*"
	format_replace_proc = /proc/chatFilterRegexBold

/proc/chatFilterRegexItalic(full_match, prefix_char, message_body, suffix_char)
	. = "<i>[trim(message_body)]</i>"

/decl/chat_filter/regexp/markdown/italic
	name = "Italics"
	summary = "Applies <i>italics</i> to speech and emote text that is surrounded by _underscores_."
	format_char = "_"
	format_replace_proc = /proc/chatFilterRegexItalic
