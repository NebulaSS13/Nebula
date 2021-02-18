/obj/item/clothing/suit/storage
	action_button_name = "Open Storage"
	var/obj/item/storage/internal/pockets/pockets
	var/slots = 2

/obj/item/clothing/suit/storage/Initialize()
	. = ..()
	pockets = new/obj/item/storage/internal/pockets(src, slots, ITEM_SIZE_SMALL) //fit only pocket sized items

/obj/item/clothing/suit/storage/Destroy()
	QDEL_NULL(pockets)
	. = ..()

/obj/item/clothing/suit/storage/attack_hand(mob/user)
	if (pockets.handle_attack_hand(user))
		..(user)

/obj/item/clothing/suit/storage/handle_mouse_drop(atom/over, mob/user)
	. = pockets?.handle_storage_internal_mouse_drop(user, over) && ..()

/obj/item/clothing/suit/storage/attackby(obj/item/W, mob/user)
	..()
	if(!(W in accessories))		//Make sure that an accessory wasn't successfully attached to suit.
		pockets.attackby(W, user)

/obj/item/clothing/suit/storage/emp_act(severity)
	pockets.emp_act(severity)
	..()

//Jackets with buttons, used for labcoats, IA jackets, First Responder jackets, and brown jackets.
/obj/item/clothing/suit/storage/toggle
	var/open = 0

/obj/item/clothing/suit/storage/toggle/verb/toggle()
	set name = "Toggle Coat Buttons"
	set category = "Object"
	set src in usr
	if(!CanPhysicallyInteract(usr))
		return 0
	open = !open
	if(!open)
		to_chat(usr, "You [open ? "un" : ""]button up the coat.")
	update_clothing_icon()	//so our overlays update

/obj/item/clothing/suit/storage/toggle/on_update_icon()
	. = ..()
	if(open && check_state_in_icon("[get_world_inventory_state()]_open", icon))
		icon_state = "[get_world_inventory_state()]_open"
	else
		icon_state = get_world_inventory_state()

/obj/item/clothing/suit/storage/toggle/experimental_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(open && check_state_in_icon("[ret.icon_state]_open", icon))
		ret.icon_state = "[ret.icon_state]_open"
	return ret