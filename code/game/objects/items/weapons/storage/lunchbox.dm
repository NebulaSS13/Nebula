/obj/item/lunchbox
	name = "rainbow lunchbox"
	desc = "A little lunchbox. This one is the colors of the rainbow!"
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_rainbow.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("lunched")
	material = /decl/material/solid/organic/plastic
	storage = /datum/storage/lunchbox
	var/tmp/filled = FALSE

/obj/item/lunchbox/WillContain()
	if(!filled)
		return
	//#TODO: Those procs and that code is so overcomplicated for some reasons.
	var/list/lunches = lunchables_lunches()
	var/list/snacks  = lunchables_snacks()
	var/list/drinks  = lunchables_drinks()
	return list(
		lunches[pick(lunches)],
		snacks[pick(snacks)],
		drinks[pick(drinks)],
	)

/obj/item/lunchbox/filled
	filled = TRUE

/obj/item/lunchbox/heart
	name = "heart lunchbox"
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_heart.dmi'
	desc = "A little lunchbox. This one has cute little hearts on it!"

/obj/item/lunchbox/heart/filled
	filled = TRUE

/obj/item/lunchbox/cat
	name = "cat lunchbox"
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_cat.dmi'
	desc = "A little lunchbox. This one has a cute little science cat from a popular show on it!"

/obj/item/lunchbox/cat/filled
	filled = TRUE

/obj/item/lunchbox/mars
	name = "\improper Mariner University lunchbox"
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_mars.dmi'
	desc = "A little lunchbox. This one is branded with the Mariner university logo!"

/obj/item/lunchbox/mars/filled
	filled = TRUE

/obj/item/lunchbox/cti
	name = "\improper CTI lunchbox"
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_cti.dmi'
	desc = "A little lunchbox. This one is branded with the CTI logo!"

/obj/item/lunchbox/cti/filled
	filled = TRUE

/obj/item/lunchbox/syndicate
	name = "black and red lunchbox"
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_evil.dmi'
	desc = "A little lunchbox. This one is a sleek black and red, made of a durable steel!"

/obj/item/lunchbox/syndicate/filled
	filled = TRUE
