/*
 * Cracker Packet
 */
/obj/item/storage/box/fancy/crackers
	name = "bag of crackers"
	icon = 'icons/obj/food/containers/crackerbag.dmi'
	icon_state = ICON_STATE_WORLD
	storage_slots = 6
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = ITEM_SIZE_TINY * 6
	w_class = ITEM_SIZE_SMALL
	key_type = /obj/item/chems/food/cracker
	can_hold = list(/obj/item/chems/food/cracker)
	use_single_icon_overlay_state = "crackerbag"

/obj/item/storage/box/fancy/crackers/adjust_contents_overlay(var/overlay_index, var/image/overlay)
	overlay?.pixel_x = -(overlay_index)
	return overlay

/obj/item/storage/box/fancy/crackers/WillContain()
	return list(/obj/item/chems/food/cracker = 6)

/obj/item/storage/box/fancy/crackers/update_icon_state()
	icon_state = get_world_inventory_state()

/obj/item/storage/box/fancy/crackers/on_update_icon()
	. = ..()
	if(opened)
		add_overlay("[icon_state]_open")
	else
		add_overlay("[icon_state]_closed")
