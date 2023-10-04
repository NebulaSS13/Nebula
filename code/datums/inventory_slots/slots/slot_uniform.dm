/datum/inventory_slot/uniform
	slot_name = "Uniform"
	slot_state = "center"
	ui_loc = ui_iclothing
	slot_id = slot_w_uniform_str
	can_be_hidden = TRUE
	covering_slots = slot_wear_suit_str
	drop_slots_on_unequip = list(
		slot_r_store_str,
		slot_l_store_str,
		slot_wear_id_str,
		slot_belt_str
	)
	requires_organ_tag = BP_CHEST
	requires_slot_flags = SLOT_UPPER_BODY
	quick_equip_priority = 11

/datum/inventory_slot/uniform/update_mob_equipment_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	if(prop?.flags_inv & HIDESHOES)
		user.update_equipment_overlay(slot_shoes_str, FALSE)
	var/obj/item/suit = user.get_equipped_item(slot_wear_suit_str)
	if(_holding && (!suit || !(suit.flags_inv & HIDEJUMPSUIT)))
		user.set_current_mob_overlay(HO_UNIFORM_LAYER, _holding.get_mob_overlay(user, slot_w_uniform_str), redraw_mob)
	else
		user.set_current_mob_overlay(HO_UNIFORM_LAYER, null, redraw_mob)

/datum/inventory_slot/uniform/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding && !(hideflags & HIDEJUMPSUIT))
		return ..()
