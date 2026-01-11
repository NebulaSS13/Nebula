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
		self_action_message("don't", "have anything in $USER_THEIR$ hands to give to \the [target].", ACTION_DANGER_OTHERS)
		return
	if(istype(I, /obj/item/grab))
		self_action_message("can't", "give someone a grab.", ACTION_DANGER_OTHERS)
		return
	targeted_visible_action_message(target, "hold", "out \the [I] to $TARGET$", self_postfix = "and wait$USER_S$ for $TARGET_THEM$ to accept it.", other_postfix = ".")
	var/decl/pronouns/target_self_pronouns = target.get_self_pronouns()
	if(alert(target,"[src] wants to give [target_self_pronouns.him] \a [I]. Will [target_self_pronouns.he] accept it?",,"Yes","No") == "No")
		target.targeted_visible_action_message(target, "try", "to hand \the [I] to $TARGET$, but $TARGET_THEY$ refuse$TARGET_S$ it.")
		return
	if(!I)
		return
	if(!Adjacent(target))
		src.self_action_message("need", "to stay in reaching distance while giving an object.", ACTION_DANGER_OTHERS)
		to_chat(target, SPAN_WARNING("\The [src] is too far away."))
		return
	if(I.loc != src || !(I in get_held_items()))
		src.self_action_message("need", "to keep the item in $USER_THEIR$ hands.", ACTION_DANGER_OTHERS)
		to_chat(target, SPAN_WARNING("\The [src] seems to have given up on passing \the [I] to [target_self_pronouns.him]."))
		return
	if(!target.get_empty_hand_slot())
		to_chat(target, SPAN_WARNING("[target_self_pronouns.His] hands are full."))
		to_chat(src, SPAN_WARNING("\The [target]'s hands are full."))
		return
	if(try_unequip(I))
		target.put_in_hands(I) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
		target.visible_action_message("hand", "\the [I] to \the [target].")
