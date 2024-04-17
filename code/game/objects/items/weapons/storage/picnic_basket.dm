// A picnic basket. Sprites by Pawn.
/obj/item/picnic_basket
	name = "picnic basket"
	desc = "A picnic basket. Can be filled with small stuff for your small trip."
	icon = 'icons/obj/items/storage/picnic_basket.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	storage = /datum/storage/picnic_basket
	attack_verb = list("picnics")
	material = /decl/material/solid/organic/plastic
	var/tmp/filled = FALSE

/obj/item/picnic_basket/WillContain()
	if(!filled)
		return
	var/list/lunches = lunchables_lunches()
	var/list/snacks  = lunchables_snacks()
	var/list/drinks  = lunchables_drinks()
	return list(
		lunches[pick(lunches)],
		snacks[pick(snacks)],
		drinks[pick(drinks)],
	)

/obj/item/picnic_basket/filled
	filled = TRUE
