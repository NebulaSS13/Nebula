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
	color_selectable = TRUE

/obj/machinery/fabricator/book/make_order(datum/fabricator_recipe/recipe, multiplier)
	var/datum/fabricator_build_order/order = ..()
	LAZYSET(order.data, "selected_color", selected_color)
	return order

/obj/machinery/fabricator/book/do_build(datum/fabricator_build_order/order)
	. = order.target_recipe.build(get_turf(src), order)

/datum/fabricator_recipe/book/skill/build(var/turf/location, var/datum/fabricator_build_order/order)
	. = list()
	for(var/i = 1, i <= order.multiplier, i++)
		var/obj/item/book/skill/custom/new_item = new path(location)
		if(colorable)
			new_item.set_color(order.get_data("selected_color", COLOR_WHITE))
		. += new_item

/obj/machinery/fabricator/book/get_color_list()
	return null // uses hex color selector instead of a list

//book recipes
/datum/fabricator_recipe/book
	name = "book, plain cover"
	path = /obj/item/book
	category = "Books"
	fabricator_types = list(FABRICATOR_CLASS_BOOKS)
	var/colorable = FALSE

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

//skill book recipes
/datum/fabricator_recipe/book/skill
	name = "textbook, plain (colorable)"
	category = "Textbooks"
	path = /obj/item/book/skill/custom
	colorable = TRUE

/datum/fabricator_recipe/book/skill/circle
	name = "textbook, circle pattern (colorable)"
	path = /obj/item/book/skill/custom/circle

/datum/fabricator_recipe/book/skill/star
	name = "textbook, star pattern (colorable)"
	path = /obj/item/book/skill/custom/star

/datum/fabricator_recipe/book/skill/hourglass
	name = "textbook, hourglass pattern (colorable)"
	path = /obj/item/book/skill/custom/hourglass

/datum/fabricator_recipe/book/skill/cracked
	name = "textbook, cracked (colorable)"
	path = /obj/item/book/skill/custom/cracked

/datum/fabricator_recipe/book/skill/wrench
	name = "textbook, wrench pattern (colorable)"
	path = /obj/item/book/skill/custom/wrench

/datum/fabricator_recipe/book/skill/gun
	name = "textbook, handgun pattern (colorable)"
	path = /obj/item/book/skill/custom/gun

/datum/fabricator_recipe/book/skill/glass
	name = "textbook, cocktail glass pattern (colorable)"
	path = /obj/item/book/skill/custom/glass

/datum/fabricator_recipe/book/skill/cross
	name = "textbook, cross pattern (colorable)"
	path = /obj/item/book/skill/custom/cross

/datum/fabricator_recipe/book/skill/text
	name = "textbook, text pattern (colorable)"
	path = /obj/item/book/skill/custom/text

/datum/fabricator_recipe/book/skill/download
	name = "textbook, download pattern (colorable)"
	path = /obj/item/book/skill/custom/download

/datum/fabricator_recipe/book/skill/uparrow
	name = "textbook, up-arrow pattern (colorable)"
	path = /obj/item/book/skill/custom/uparrow

/datum/fabricator_recipe/book/skill/percent
	name = "textbook, percent pattern (colorable)"
	path = /obj/item/book/skill/custom/percent

/datum/fabricator_recipe/book/skill/flask
	name = "textbook, flask pattern (colorable)"
	path = /obj/item/book/skill/custom/flask

/datum/fabricator_recipe/book/skill/detective
	name = "textbook, magnifying glass pattern (colorable)"
	path = /obj/item/book/skill/custom/detective

/datum/fabricator_recipe/book/skill/device
	name = "textbook, device pattern (colorable)"
	path = /obj/item/book/skill/custom/device

/datum/fabricator_recipe/book/skill/smile
	name = "textbook, smiley face pattern (colorable)"
	path = /obj/item/book/skill/custom/smile

/datum/fabricator_recipe/book/skill/exclamation
	name = "textbook, exclamation mark pattern (colorable)"
	path = /obj/item/book/skill/custom/exclamation

/datum/fabricator_recipe/book/skill/question
	name = "textbook, question mark pattern (colorable)"
	path = /obj/item/book/skill/custom/question