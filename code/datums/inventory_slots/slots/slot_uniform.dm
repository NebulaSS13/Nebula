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

/datum/inventory_slot/uniform/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	if(prop.flags_inv & HIDESHOES)
		user.update_inv_shoes(0)
	user.update_inv_w_uniform(redraw_mob)

/datum/inventory_slot/uniform/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding && !(hideflags & HIDEJUMPSUIT))
		return ..()
