/obj/random/single/textbook
	name = "random textbook"
	icon = 'icons/obj/items/books/book.dmi'
	icon_state = ICON_STATE_WORLD
	spawn_object = /obj/item/book/skill //Further randomization of which book is handled inside the book initialization
	spawn_nothing_percentage = 0

/obj/random/crayon
	name = "random crayon"
	desc = "This is a random crayon."
	icon = 'icons/obj/items/crayons.dmi'
	icon_state = "crayonred"

/obj/random/crayon/spawn_choices()
	return subtypesof(/obj/item/pen/crayon)

/obj/random/clipboard
	name = "random clipboard"
	desc = "This is a random material clipboard."
	icon = 'icons/obj/items/clipboard.dmi'
	icon_state = "clipboard"

/obj/random/clipboard/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clipboard           = 300,
		/obj/item/clipboard/steel     = 200,
		/obj/item/clipboard/aluminium = 200,
		/obj/item/clipboard/plastic   = 200,
		/obj/item/clipboard/glass     = 100,
		/obj/item/clipboard/ebony     =  10
	)
	return spawnable_choices

/obj/random/documents // top secret documents, mostly overriden by maps
	name = "random secret documents"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"

/obj/random/documents/spawn_choices()
	var/static/list/spawnable_choices = list(/obj/item/documents)
	return spawnable_choices
