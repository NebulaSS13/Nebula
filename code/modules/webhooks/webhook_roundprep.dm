/decl/webhook/roundprep
	id = WEBHOOK_ROUNDPREP

// Data expects a "url" field pointing to the current hosted server and port to connect on.
/decl/webhook/roundprep/get_message(var/list/data)
	. = ..()
	var/desc = "The server has been started!\n"
	desc += "Map: **[station_name()]**\n"
	desc += "Address: <[get_world_url()]>"

	.["embeds"] = list(list(
		"title" = "New round preparation.",
		"description" = desc,
		"color" = COLOR_WEBHOOK_DEFAULT
	))
