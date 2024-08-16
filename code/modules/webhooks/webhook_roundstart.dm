/decl/webhook/roundstart
	id = WEBHOOK_ROUNDSTART

// Data expects a "url" field pointing to the current hosted server and port to connect on.
/decl/webhook/roundstart/get_message(var/list/data)
	. = ..()
	var/desc = "Gamemode: **[SSticker.master_mode]**\nPlayers: **[global.player_list.len]**"
	var/url = LAZYACCESS(data, "url")
	if(url)
		desc += "\nAddress: <[url]>"
	.["embeds"] = list(list(
		"title"       = "Round has started.",
		"description" = desc,
		"color"       = COLOR_WEBHOOK_DEFAULT
	))
