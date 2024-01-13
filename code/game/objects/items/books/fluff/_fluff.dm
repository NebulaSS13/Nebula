/obj/item/book/fluff
	unique = TRUE
	abstract_type = /obj/item/book/fluff
	var/fluff_text

/obj/item/book/fluff/Initialize()
	. = ..()
	if(!fluff_text)
		log_debug("Fluff book [type] spawned with no fluff text.")
		return INITIALIZE_HINT_QDEL
	dat = {"
		<html>
			<head>
				[get_style_css()]
			</head>
			<body>
				[fluff_text]
			</body>
		</html>
	"}
