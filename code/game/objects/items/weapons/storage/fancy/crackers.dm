/*
 * Cracker Packet
 */
/obj/item/storage/box/fancy/crackers
	name = "bag of crackers"
	icon = 'icons/obj/food/containers/crackerbag.dmi'
	icon_state = ICON_STATE_WORLD
	storage_slots = 6
	max_w_class = ITEM_SIZE_TINY
	w_class = ITEM_SIZE_SMALL
	key_type = /obj/item/chems/food/cracker
	can_hold = list(/obj/item/chems/food/cracker)

/obj/item/storage/box/fancy/crackers/WillContain()
	return list(/obj/item/chems/food/cracker = 6)

/obj/item/storage/box/fancy/crackers/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	var/i = 0
	for(var/obj/item/cracker in contents)
		var/cracker_state = "[cracker.icon_state]_crackerbag"
		if(!check_state_in_icon(cracker_state, cracker.icon))
			continue
		var/image/I = image(cracker.icon, cracker_state)
		I.pixel_x = i * -1
		if(cracker.color)
			I.color = cracker.color
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)
		i++
	if(opened)
		add_overlay("[icon_state]_open")
	else
		add_overlay("[icon_state]_closed")
