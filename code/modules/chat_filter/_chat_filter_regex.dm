/decl/chat_filter/regexp
	filter_category = /decl/chat_filter/regexp
	var/regex/filter_regex

/decl/chat_filter/regexp/match(var/message)
	. = filter_regex && findtext(message, filter_regex)
