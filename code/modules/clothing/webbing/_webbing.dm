/obj/item/clothing/webbing
	name = "webbing"
	desc = "Sturdy mess of synthcotton belts and buckles, ready to share your burden."
	icon = 'icons/clothing/accessories/storage/webbing.dmi'
	slot_flags = SLOT_TIE
	accessory_slot = ACCESSORY_SLOT_UTILITY
	w_class = ITEM_SIZE_NORMAL
	accessory_high_visibility = 1
	var/slots = 3
	var/max_w_class = ITEM_SIZE_SMALL //pocket sized
	var/obj/item/storage/internal/pockets/hold

/obj/item/clothing/webbing/get_initial_accessory_hide_on_states()
	var/static/list/initial_accessory_hide_on_states = list(
		/decl/clothing_state_modifier/rolled_down
	)
	return initial_accessory_hide_on_states

/obj/item/clothing/webbing/Initialize()
	. = ..()
	create_storage()

/obj/item/clothing/webbing/Destroy()
	QDEL_NULL(hold)
	return ..()

/obj/item/clothing/webbing/proc/create_storage()
	hold = new/obj/item/storage/internal/pockets(src, slots, max_w_class)

/obj/item/clothing/webbing/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE) || !hold)
		return ..()
	if(istype(loc, /obj/item/clothing))
		hold.open(user)
		return TRUE
	if(hold.handle_attack_hand(user))	//otherwise interact as a regular storage item
		return ..(user)
	return TRUE

/obj/item/clothing/webbing/handle_mouse_drop(atom/over, mob/user, params)
	if(istype(over, /obj/screen/inventory))
		return ..()
	if(!istype(loc, /obj/item/clothing) && hold?.handle_storage_internal_mouse_drop(user, over))
		return ..()
	return TRUE

/obj/item/clothing/webbing/attackby(obj/item/W, mob/user)
	if(hold)
		return hold.attackby(W, user)

/obj/item/clothing/webbing/emp_act(severity)
	if(hold)
		hold.emp_act(severity)
		..()

/obj/item/clothing/webbing/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You empty [src].</span>")
	var/turf/T = get_turf(src)
	hold.hide_from(usr)
	for(var/obj/item/I in hold)
		hold.remove_from_storage(I, T, 1)
	hold.finish_bulk_removal()
	src.add_fingerprint(user)

/obj/item/clothing/webbing/webbing_large
	name = "large webbing"
	desc = "A large collection of synthcotton pockets and pouches."
	icon = 'icons/clothing/accessories/storage/webbing_large.dmi'
	slots = 4
