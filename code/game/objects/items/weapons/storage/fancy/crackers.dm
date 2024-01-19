/*
 * Cracker Packet
 */
/obj/item/storage/box/fancy/crackers
	name = "bag of crackers"
	icon = 'icons/obj/food.dmi'
	icon_state = "crackerbag"
	storage_slots = 6
	max_w_class = ITEM_SIZE_TINY
	w_class = ITEM_SIZE_SMALL
	key_type = /obj/item/chems/food/cracker
	can_hold = list(/obj/item/chems/food/cracker)

/obj/item/storage/box/fancy/crackers/WillContain()
	return list(/obj/item/chems/food/cracker = 6)

