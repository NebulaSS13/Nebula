// A picnic basket. Sprites by Pawn.
/obj/item/storage/picnic_basket
	name = "picnic basket"
	desc = "A picnic basket. Can be filled with small stuff for your small trip."
	icon = 'icons/obj/items/storage/picnic_basket.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BOX_STORAGE
	attack_verb = list("picnics")
	material = /decl/material/solid/plastic
	var/filled = FALSE

/obj/item/storage/picnic_basket/Initialize()
	. = ..()
	if(filled)
		var/list/lunches = lunchables_lunches()
		var/lunch = lunches[pick(lunches)]
		new lunch(src)

		var/list/snacks = lunchables_snacks()
		var/snack = snacks[pick(snacks)]
		new snack(src)

		var/list/drinks = lunchables_drinks()
		var/drink = drinks[pick(drinks)]
		new drink(src)

/obj/item/storage/picnic_basket/filled
	filled = TRUE
