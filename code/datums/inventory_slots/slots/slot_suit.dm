/datum/inventory_slot/suit
	slot_name = "Suit"
	slot_state = "suit"
	ui_loc = ui_oclothing
	slot_id = slot_wear_suit_str
	can_be_hidden = TRUE
	drop_slots_on_unequip = list(slot_s_store_str)
	requires_organ_tag = BP_CHEST
	requires_slot_flags = SLOT_OVER_BODY

/datum/inventory_slot/suit/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	if(prop.flags_inv & HIDESHOES)
		user.update_inv_shoes(0)
	if(prop.flags_inv & HIDEGLOVES)
		user.update_inv_gloves(0)
	if(prop.flags_inv & HIDEJUMPSUIT)
		user.update_inv_w_uniform(0)
	user.update_inv_wear_suit(redraw_mob)
