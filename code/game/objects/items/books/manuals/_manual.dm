/obj/item/book/manual
	unique = TRUE // Unable to be copied, unable to be modified
	abstract_type = /obj/item/book/manual
	var/guide_decl
	var/tmp/has_initialized = FALSE

/obj/item/book/manual/Initialize()
	. = ..()
	// try to initialize the text! if it's prior to sscodex init it'll initialize on being read
	// if the guide is invalid the manual will need to be deleted
	if(initialize_data(in_init = TRUE) == INITIALIZE_HINT_QDEL)
		return INITIALIZE_HINT_QDEL

/obj/item/book/manual/try_to_read()
	initialize_data()
	. = ..()

/obj/item/book/manual/show_text_to()
	initialize_data()
	. = ..()

/obj/item/book/manual/clear_text()
	if((. = ..()))
		has_initialized = TRUE // prevent data from being added later if it hasn't already been

/obj/item/book/manual/proc/initialize_data(in_init = FALSE)
	if(has_initialized || !SScodex.initialized)
		return
	// Has yet to initialize.
	var/guide_text = guide_decl && SScodex.get_manual_text(guide_decl)
	if(!guide_text)
		log_debug("Manual [type] spawned with invalid guide decl type ([guide_decl || null]).")
		if(in_init)
			return INITIALIZE_HINT_QDEL
		qdel(src)
		return
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
	has_initialized = TRUE
