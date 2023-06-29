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

/datum/inventory_slot/gloves/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	user.update_inv_gloves(redraw_mob)

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
