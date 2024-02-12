/obj/item/storage/lunchbox
	max_storage_space = 8 //slightly smaller than a toolbox
	name = "rainbow lunchbox"
	icon = 'icons/obj/items/storage/lunchbox.dmi'
	icon_state = "lunchbox_rainbow"
	item_state = "toolbox_pink"
	desc = "A little lunchbox. This one is the colors of the rainbow!"
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
	icon_state = "lunchbox_lovelyhearts"
	item_state = "toolbox_pink"
	desc = "A little lunchbox. This one has cute little hearts on it!"

/obj/item/storage/lunchbox/heart/filled
	filled = TRUE

/obj/item/storage/lunchbox/cat
	name = "cat lunchbox"
	icon_state = "lunchbox_sciencecatshow"
	item_state = "toolbox_green"
	desc = "A little lunchbox. This one has a cute little science cat from a popular show on it!"

/obj/item/storage/lunchbox/cat/filled
	filled = TRUE

/obj/item/storage/lunchbox/mars
	name = "\improper Mariner University lunchbox"
	icon_state = "lunchbox_marsuniversity"
	item_state = "toolbox_red"
	desc = "A little lunchbox. This one is branded with the Mariner university logo!"

/obj/item/storage/lunchbox/mars/filled
	filled = TRUE

/obj/item/storage/lunchbox/cti
	name = "\improper CTI lunchbox"
	icon_state = "lunchbox_cti"
	item_state = "toolbox_blue"
	desc = "A little lunchbox. This one is branded with the CTI logo!"

/obj/item/storage/lunchbox/cti/filled
	filled = TRUE

/obj/item/storage/lunchbox/syndicate
	name = "black and red lunchbox"
	icon_state = "lunchbox_syndie"
	item_state = "toolbox_syndi"
	desc = "A little lunchbox. This one is a sleek black and red, made of a durable steel!"

/obj/item/storage/lunchbox/syndicate/filled
	filled = TRUE
