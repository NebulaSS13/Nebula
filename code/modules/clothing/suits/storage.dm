/obj/item/clothing/suit/storage
	var/obj/item/storage/internal/pockets/pockets
	var/slots = 2

/obj/item/clothing/suit/storage/Initialize()
	. = ..()
	pockets = new/obj/item/storage/internal/pockets(src, slots, ITEM_SIZE_SMALL) //fit only pocket sized items

/obj/item/clothing/suit/storage/Destroy()
	QDEL_NULL(pockets)
	. = ..()

/obj/item/clothing/suit/storage/attack_hand(mob/user)
	if(pockets.handle_attack_hand(user))
		return ..(user)
	return TRUE

/obj/item/clothing/suit/storage/handle_mouse_drop(atom/over, mob/user)
	. = pockets?.handle_storage_internal_mouse_drop(user, over) && ..()

/obj/item/clothing/suit/storage/attackby(obj/item/W, mob/user)
	..()
	if(!(W in accessories))		//Make sure that an accessory wasn't successfully attached to suit.
		pockets.attackby(W, user)

/obj/item/clothing/suit/storage/emp_act(severity)
	pockets.emp_act(severity)
	..()
