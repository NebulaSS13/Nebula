/*
Add fingerprints to items when we put them in our hands.
This saves us from having to call add_fingerprint() any time something is put in a human's hands programmatically.
*/
/mob/living/carbon/human/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/I = H.get_active_hand()
		if(!I)
			to_chat(H, SPAN_NOTICE("You are not holding anything to equip."))
			return
		if(!H.equip_to_appropriate_slot(I))
			to_chat(H, SPAN_WARNING("You are unable to equip that."))

/mob/living/carbon/human/proc/equip_in_one_of_slots(obj/item/W, list/slots, del_on_fail = 1)
	for (var/slot in slots)
		if (equip_to_slot_if_possible(W, slots[slot], del_on_fail = 0))
			return slot
	if (del_on_fail)
		qdel(W)
	return null

/mob/living/carbon/human/get_equipped_items(var/include_carried = 0)
	. = ..()
	for(var/slot in global.equipped_slots)
		var/obj/item/thing = get_equipped_item(slot)
		if(istype(thing))
			LAZYADD(., thing)
	if(include_carried)
		for(var/slot in global.carried_slots)
			var/obj/item/thing = get_equipped_item(slot)
			if(istype(thing))
				LAZYADD(., thing)

//Same as get_covering_equipped_items, but using target zone instead of bodyparts flags
/mob/living/carbon/human/proc/get_covering_equipped_item_by_zone(var/zone)
	var/obj/item/organ/external/O = GET_EXTERNAL_ORGAN(src, zone)
	if(O)
		return get_covering_equipped_item(O.body_part)
