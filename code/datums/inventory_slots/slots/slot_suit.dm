/datum/inventory_slot/suit
	slot_name = "Suit"
	slot_state = "suit"
	ui_loc = ui_oclothing
	slot_id = slot_wear_suit_str
	can_be_hidden = TRUE
	drop_slots_on_unequip = list(slot_s_store_str)
	requires_organ_tag = BP_CHEST
	requires_slot_flags = SLOT_OVER_BODY
	mob_overlay_layer = HO_SUIT_LAYER

/datum/inventory_slot/suit/update_mob_equipment_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	if(prop)
		if(prop.flags_inv & HIDESHOES)
			user.update_equipment_overlay(slot_shoes_str, FALSE)
		if(prop.flags_inv & HIDEGLOVES)
			user.update_equipment_overlay(slot_gloves_str, FALSE)
		if(prop.flags_inv & HIDEJUMPSUIT)
			user.update_equipment_overlay(slot_w_uniform_str, FALSE)
	user.update_tail_showing(FALSE)
	..()
	// Adds a collar overlay above the helmet layer if the suit has one
	// Suit needs an identically named sprite in icons/mob/collar.dmi
	var/obj/item/clothing/suit/suit = _holding
	user.set_current_mob_overlay(HO_COLLAR_LAYER, (istype(suit) ? suit.get_collar() : null), redraw_mob)
