var/global/list/survival_box_choices = list()

/decl/survival_box_option
	var/name = "survival kit"
	var/box_type = /obj/item/storage/box/survival

/decl/survival_box_option/Initialize()
	. = ..()
	global.survival_box_choices[name] = src

/decl/survival_box_option/lunchbox
	name = "lunchbox"
	box_type = /obj/item/storage/lunchbox/filled

/decl/survival_box_option/lunchbox/heart
	name = "heart lunchbox"
	box_type = /obj/item/storage/lunchbox/heart/filled

/decl/survival_box_option/lunchbox/cat
	name = "cat lunchbox"
	box_type = /obj/item/storage/lunchbox/cat/filled
