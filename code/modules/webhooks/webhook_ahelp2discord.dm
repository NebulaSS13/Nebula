/decl/webhook/ahelp_sent
	id = WEBHOOK_AHELP_SENT

/decl/webhook/ahelp_sent/get_message(var/list/data)
	.= ..()
	.["embeds"] = list(list(
		"title"       = LAZYACCESS(data, "name") || "undefined",
		"description" = LAZYACCESS(data, "body") || "undefined",
		"color"       = COLOR_WEBHOOK_DEFAULT
	))

/decl/webhook/ahelp_sent/get_mentions()
	. = !length(global.admins) && ..()
