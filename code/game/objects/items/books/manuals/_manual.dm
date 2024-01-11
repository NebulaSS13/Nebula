/obj/item/book/manual
	unique = TRUE // Unable to be copied, unable to be modified
	abstract_type = /obj/item/book/manual
	var/guide_decl

/obj/item/book/manual/Initialize()
	. = ..()
	var/guide_text = guide_decl && SScodex.get_manual_text(guide_decl)
	if(!guide_text)
		log_debug("Manual [type] spawned with invalid guide decl type ([guide_decl || null]).")
		return INITIALIZE_HINT_QDEL
	dat = {"
		<html>
			<head>
				[get_style_css()]
			</head>
			<body>
				[guide_text]
			</body>
		</html>
	"}
