/datum/inventory_slot/shoes
	slot_name = "Shoes"
	slot_state = "shoes"
	ui_loc = ui_shoes
	slot_id = slot_shoes_str
	can_be_hidden = TRUE
	requires_organ_tag = list(
		BP_L_FOOT,
		BP_R_FOOT
	)
	requires_slot_flags = SLOT_FEET
	quick_equip_priority = 3

/datum/inventory_slot/shoes/update_mob_equipment_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	var/obj/item/suit =    user.get_equipped_item(slot_wear_suit_str)
	var/obj/item/uniform = user.get_equipped_item(slot_w_uniform_str)
	if(_holding && !((suit && suit.flags_inv & HIDESHOES) || (uniform && uniform.flags_inv & HIDESHOES)))
		user.set_current_mob_overlay(HO_SHOES_LAYER, _holding.get_mob_overlay(user, slot_shoes_str, use_fallback_if_icon_missing = use_overlay_fallback_slot), redraw_mob)
		return
	var/mob_blood_overlay = user.get_bodytype()?.get_blood_overlays(user)
	if(mob_blood_overlay)
		var/blood_color
		for(var/foot_tag in list(BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/stomper = GET_EXTERNAL_ORGAN(user, foot_tag)
			if(stomper && stomper.coating?.total_volume)
				blood_color = stomper.coating.get_color()
				break
		if(blood_color)
			var/image/bloodsies = overlay_image(mob_blood_overlay, "shoeblood", blood_color, RESET_COLOR)
			user.set_current_mob_overlay(HO_SHOES_LAYER, bloodsies, redraw_mob)
			return
	user.set_current_mob_overlay(HO_SHOES_LAYER, null, redraw_mob)

/datum/inventory_slot/shoes/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding && !(hideflags & HIDESHOES))
		if(user == owner)
			return "You are wearing [_holding.get_examine_line()] on your feet."
		return "[pronouns.He] [pronouns.is] wearing [_holding.get_examine_line()] on [pronouns.his] feet."
	for(var/bp in list(BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(owner, bp)
		if(E && E.coating?.total_volume)
			if(user == owner)
				return "There's <font color='[E.coating.get_color()]'>something on your feet</font>!"
			return "There's <font color='[E.coating.get_color()]'>something on [pronouns.his] feet</font>!"
