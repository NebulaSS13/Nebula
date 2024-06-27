/decl/chat_filter/regexp
	abstract_type = /decl/chat_filter/regexp
	var/regex/filter_regex

/decl/chat_filter/regexp/match(var/message)
	filter_regex.index = 0 // we use the global flag, so we need to reset this for every match or else repeat messages will break
	. = filter_regex && filter_regex.Find(message)
