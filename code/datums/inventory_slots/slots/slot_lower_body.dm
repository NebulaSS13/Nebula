/datum/inventory_slot/lower_body
	slot_name = "Lower Body"
	slot_state = "center"
	ui_loc = ui_lclothing
	slot_id = slot_lower_body_str
	can_be_hidden = TRUE
	covering_slots = slot_wear_suit_str
	drop_slots_on_unequip = list(
		slot_belt_str
	)
	requires_organ_tag = BP_GROIN
	requires_slot_flags = SLOT_LOWER_BODY
	quick_equip_priority = 11
	mob_overlay_layer = HO_LOWER_BODY_LAYER
	alt_mob_overlay_layer = HO_UPPER_BODY_LAYER

/datum/inventory_slot/lower_body/use_alt_layer(mob/user)
	var/obj/item/clothing/shirt = user.get_equipped_item(slot_lower_body_str)
	var/obj/item/clothing/pants = _holding
	return ((istype(pants) && pants.use_alt_layer) || (istype(shirt) && shirt.use_alt_layer))

/datum/inventory_slot/lower_body/update_mob_equipment_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	if(prop?.flags_inv & HIDESHOES)
		user.update_equipment_overlay(slot_shoes_str, FALSE)
	var/use_layer = use_alt_layer(user) ? alt_mob_overlay_layer : mob_overlay_layer
	var/obj/item/suit = user.get_equipped_item(slot_wear_suit_str)
	if(_holding && (!suit || !(suit.flags_inv & HIDEJUMPSUIT)))
		user.set_current_mob_overlay(use_layer, _holding.get_mob_overlay(user, slot_lower_body_str), redraw_mob)
	else
		user.set_current_mob_overlay(use_layer, null, redraw_mob)

/datum/inventory_slot/lower_body/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding && !(hideflags & HIDEJUMPSUIT))
		return ..()