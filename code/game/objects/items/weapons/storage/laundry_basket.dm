// -----------------------------
//        Laundry Basket
// -----------------------------
// An item designed for hauling the belongings of a character.
// So this cannot be abused for other uses, we make it two-handed and inable to have its storage looked into.
/obj/item/storage/laundry_basket
	name = "laundry basket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "laundry-empty"
	item_state = "laundry"
	desc = "The peak of thousands of years of laundry evolution."

	w_class = ITEM_SIZE_GARGANTUAN
	max_w_class = ITEM_SIZE_HUGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE //20 for clothes + a bit of additional space for non-clothing items that were worn on body
	storage_slots = 14
	use_to_pickup = 1
	allow_quick_empty = 1
	allow_quick_gather = 1
	collection_mode = 1
	material = /decl/material/solid/plastic
	obj_flags = OBJ_FLAG_HOLLOW
	var/linked

/obj/item/storage/laundry_basket/attack_hand(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/external/temp = GET_EXTERNAL_ORGAN(H, H.get_active_held_item_slot())
	if(!temp)
		to_chat(user, SPAN_WARNING("You need two hands to pick this up!"))
		return TRUE
	if(!user.get_empty_hand_slot())
		to_chat(user, SPAN_WARNING("You need a hand to be empty."))
		return TRUE
	return ..()

/obj/item/storage/laundry_basket/attack_self(mob/user)
	var/turf/T = get_turf(user)
	to_chat(user, "<span class='notice'>You dump the [src]'s contents onto \the [T].</span>")
	return ..()

/obj/item/storage/laundry_basket/on_picked_up(mob/user)
	var/obj/item/storage/laundry_basket/offhand/O = new(user)
	O.SetName("[name] - second hand")
	O.desc = "Your second grip on the [name]."
	O.linked = src
	user.put_in_inactive_hand(O)
	linked = O
	return

/obj/item/storage/laundry_basket/on_update_icon()
	. = ..()
	if(contents.len)
		icon_state = "laundry-full"
	else
		icon_state = "laundry-empty"

/obj/item/storage/laundry_basket/handle_mouse_drop(var/atom/over, var/mob/user)
	if(over == user)
		return TRUE
	. = ..()

/obj/item/storage/laundry_basket/dropped(mob/user)
	qdel(linked)
	return ..()

/obj/item/storage/laundry_basket/show_to(mob/user)
	return

/obj/item/storage/laundry_basket/open(mob/user)


//Offhand
/obj/item/storage/laundry_basket/offhand
	icon = 'icons/mob/offhand.dmi'
	icon_state = "offhand"
	name = "second hand"
	use_to_pickup = 0

/obj/item/storage/laundry_basket/offhand/dropped(mob/user)
	..()
	user.drop_from_inventory(linked)
	return

