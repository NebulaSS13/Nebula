/decl/webhook/ahelp_sent
	id = WEBHOOK_AHELP_SENT

/decl/webhook/ahelp_sent/get_message(var/list/data)
	.= ..()
	.["embeds"] = list(list(
		"title" = "[data["name"]]",
		"description" = data["body"],
		"color" = COLOR_WEBHOOK_DEFAULT
	))

/decl/webhook/ahelp_sent/get_mentions()
	if(!length(GLOB.admins))
		return mentions