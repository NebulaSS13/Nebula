/obj/item/basket
	name_prefix         = "woven"
	name                = "handbasket"
	desc                = "A simple woven basket. Very rustic."
	icon                = 'icons/obj/items/storage/baskets/basket_round.dmi'
	icon_state          = ICON_STATE_WORLD
	w_class             = ITEM_SIZE_HUGE
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	storage             = /datum/storage/basket
	material            = /decl/material/solid/organic/plantmatter/grass/dry

/obj/item/basket/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(storage?.opened)
		icon_state = "[icon_state]-open"

/obj/item/basket/large
	name_prefix         = "large woven"
	name                = "basket"
	slot_flags          = SLOT_BACK
	icon                = 'icons/obj/items/storage/baskets/basket_large.dmi'
	w_class             = ITEM_SIZE_GARGANTUAN
	storage             = /datum/storage/basket/large
	slowdown_general    = 1 // Large and unwieldy
