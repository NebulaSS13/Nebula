/datum/inventory_slot/gloves
	slot_name = "Gloves"
	slot_state = "gloves"
	ui_loc = ui_gloves
	slot_id = slot_gloves_str
	covering_slots = slot_wear_suit_str
	can_be_hidden = TRUE
	requires_organ_tag = list(
		BP_L_HAND,
		BP_R_HAND
	)
	covering_flags = SLOT_HANDS
	requires_slot_flags = SLOT_HANDS
	quick_equip_priority = 8

/datum/inventory_slot/gloves/update_mob_equipment_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	var/obj/item/suit = user.get_equipped_item(slot_wear_suit_str)
	if(_holding && !(suit && suit.flags_inv & HIDEGLOVES))
		user.set_current_mob_overlay(HO_GLOVES_LAYER, _holding.get_mob_overlay(user, slot_gloves_str, use_fallback_if_icon_missing = use_overlay_fallback_slot), redraw_mob)
		return
	var/mob_blood_overlay = user.get_bodytype()?.get_blood_overlays(user)
	if(mob_blood_overlay)
		var/blood_color
		for(var/obj/item/organ/external/grabber in user.get_hands_organs())
			if(grabber.coating)
				blood_color = grabber.coating.get_color()
				break
		if(blood_color)
			user.set_current_mob_overlay(HO_GLOVES_LAYER, overlay_image(mob_blood_overlay, "bloodyhands", blood_color, RESET_COLOR), redraw_mob)
			return
	user.set_current_mob_overlay(HO_GLOVES_LAYER, null, redraw_mob)

/datum/inventory_slot/gloves/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding && !(hideflags & HIDEGLOVES))
		if(user == owner)
			return "You have [_holding.get_examine_line()] on your hands."
		return "[pronouns.He] [pronouns.has] [_holding.get_examine_line()] on [pronouns.his] hands."
	for(var/obj/item/organ/external/E in owner.get_hands_organs())
		if(E.coating)
			if(user == owner)
				return "There's <font color='[E.coating.get_color()]'>something on your hands</font>!"
			return "There's <font color='[E.coating.get_color()]'>something on [pronouns.his] hands</font>!"
