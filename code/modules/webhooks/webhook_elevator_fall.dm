/decl/webhook/elevator_fall
	id = WEBHOOK_ELEVATOR_FALL

// Data expects a "text" field containing a message.
/decl/webhook/elevator_fall/get_message(var/list/data)
	. = ..()
	.["embeds"] = list(list(
		"title"       = "What a shame.",
		"description" = LAZYACCESS(data, "text") || "undefined",
		"color"       = COLOR_WEBHOOK_DEFAULT
	))
