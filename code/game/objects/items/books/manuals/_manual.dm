/obj/item/book/manual
	unique = TRUE // Unable to be copied, unable to be modified
	abstract_type = /obj/item/book/manual
	var/guide_decl

/obj/item/book/manual/proc/get_style_css()
	return {"<style>
		h1 {font-size: 18px; margin: 15px 0px 5px;}
		h2 {font-size: 15px; margin: 15px 0px 5px;}
		h3 {font-size: 13px; margin: 15px 0px 5px;}
		li {margin: 2px 0px 2px 15px;}
		ul {margin: 5px; padding: 0px;}
		ol {margin: 5px; padding: 0px 15px;}
		body {font-size: 13px; font-family: Verdana;}
	</style>"}

/obj/item/book/manual/Initialize()
	. = ..()
	var/guide_text = guide_decl && SScodex.get_guide(guide_decl)
	if(!guide_text)
		log_debug("Manual [type] spawned with invalid guide decl type ([guide_decl || null]).")
		return INITIALIZE_HINT_QDEL
	dat = {"<html>
		<head>
			[get_style_css()]
		</head>
		<body>
			[guide_text]
		</body>
	</html>"}
