/obj/item/storage/lunchbox
	max_storage_space = 8 //slightly smaller than a toolbox
	name = "rainbow lunchbox"
	desc = "A little lunchbox. This one is the colors of the rainbow!"
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_rainbow.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_SMALL
	attack_verb = list("lunched")
	material = /decl/material/solid/organic/plastic
	var/tmp/filled = FALSE

/obj/item/storage/lunchbox/WillContain()
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

/obj/item/storage/lunchbox/filled
	filled = TRUE

/obj/item/storage/lunchbox/heart
	name = "heart lunchbox"
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_heart.dmi'
	desc = "A little lunchbox. This one has cute little hearts on it!"

/obj/item/storage/lunchbox/heart/filled
	filled = TRUE

/obj/item/storage/lunchbox/cat
	name = "cat lunchbox"
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_cat.dmi'
	desc = "A little lunchbox. This one has a cute little science cat from a popular show on it!"

/obj/item/storage/lunchbox/cat/filled
	filled = TRUE

/obj/item/storage/lunchbox/mars
	name = "\improper Mariner University lunchbox"
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_mars.dmi'
	desc = "A little lunchbox. This one is branded with the Mariner university logo!"

/obj/item/storage/lunchbox/mars/filled
	filled = TRUE

/obj/item/storage/lunchbox/cti
	name = "\improper CTI lunchbox"
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_cti.dmi'
	desc = "A little lunchbox. This one is branded with the CTI logo!"

/obj/item/storage/lunchbox/cti/filled
	filled = TRUE

/obj/item/storage/lunchbox/syndicate
	name = "black and red lunchbox"
	icon = 'icons/obj/items/storage/lunchboxes/lunchbox_evil.dmi'
	desc = "A little lunchbox. This one is a sleek black and red, made of a durable steel!"

/obj/item/storage/lunchbox/syndicate/filled
	filled = TRUE
