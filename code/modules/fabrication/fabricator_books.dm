/obj/machinery/fabricator/book
	name = "autobinder"
	desc = "A fabricator that produces blank books from plastic and wood."
	icon = 'icons/obj/machines/fabricators/book.dmi'
	icon_state = "binder"
	base_icon_state = "binder"
	idle_power_usage = 5
	active_power_usage = 1000
	base_type = /obj/machinery/fabricator/book
	fabricator_class = FABRICATOR_CLASS_BOOKS
	base_storage_capacity = list(
		/material/wood =      20000,
		/material/plastic =   20000
	)

/datum/fabricator_recipe/book
	name = "book, plain cover"
	path = /obj/item/book
	category = "Books"
	fabricator_types = list(FABRICATOR_CLASS_BOOKS)

/datum/fabricator_recipe/book/black
	name = "book, black cover"
	path = /obj/item/book/printable_black

/datum/fabricator_recipe/book/red
	name = "book, red cover"
	path = /obj/item/book/printable_red

/datum/fabricator_recipe/book/yellow
	name = "book, yellow cover"
	path = /obj/item/book/printable_yellow

/datum/fabricator_recipe/book/blue
	name = "book, blue cover"
	path = /obj/item/book/printable_blue

/datum/fabricator_recipe/book/green
	name = "book, green cover"
	path = /obj/item/book/printable_green

/datum/fabricator_recipe/book/purple
	name = "book, purple cover"
	path = /obj/item/book/printable_purple

/datum/fabricator_recipe/book/cyan
	name = "book, cyan cover"
	path = /obj/item/book/printable_light_blue

/datum/fabricator_recipe/book/magazine
	name = "magazine"
	path = /obj/item/book/printable_magazine
