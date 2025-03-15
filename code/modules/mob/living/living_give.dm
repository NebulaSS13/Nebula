/mob/living/verb/give(var/mob/living/target in view(1)-usr)
	set category = "IC"
	set name = "Give"
	do_give(target)

/mob/living/proc/do_give(var/mob/living/target)
	set waitfor = FALSE
	if(src.incapacitated())
		return
	if(!istype(target) || target.incapacitated() || target.client == null)
		return
	var/obj/item/I = get_active_held_item()
	if(!I)
		var/list/inactive_hands = get_inactive_held_items()
		if(length(inactive_hands))
			I = inactive_hands[1]
	if(!I)
		to_chat(src, SPAN_WARNING("You don't have anything in your hands to give to \the [target]."))
		return
	if(istype(I, /obj/item/grab))
		to_chat(usr, SPAN_WARNING("You can't give someone a grab."))
		return
	usr.visible_message(SPAN_NOTICE("\The [usr] holds out \the [I] to \the [target]."), SPAN_NOTICE("You hold out \the [I] to \the [target], waiting for them to accept it."))
	if(alert(target,"[src] wants to give you \a [I]. Will you accept it?",,"Yes","No") == "No")
		target.visible_message(SPAN_NOTICE("\The [src] tried to hand \the [I] to \the [target], \
		but \the [target] didn't want it."))
		return
	if(!I)
		return
	if(!Adjacent(target))
		to_chat(src, SPAN_WARNING("You need to stay in reaching distance while giving an object"))
		to_chat(target, SPAN_WARNING("\The [src] moved too far away."))
		return
	if(I.loc != src || !(I in get_held_items()))
		to_chat(src, SPAN_WARNING("You need to keep the item in your hands."))
		to_chat(target, SPAN_WARNING("\The [src] seems to have given up on passing \the [I] to you."))
		return
	if(!target.get_empty_hand_slot())
		to_chat(target, SPAN_WARNING("Your hands are full."))
		to_chat(src, SPAN_WARNING("Their hands are full."))
		return
	if(try_unequip(I))
		target.put_in_hands(I) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
		target.visible_message(SPAN_NOTICE("\The [src] handed \the [I] to \the [target]."))
