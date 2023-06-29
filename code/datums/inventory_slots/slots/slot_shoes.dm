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

/datum/inventory_slot/shoes/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	user.update_inv_shoes(redraw_mob)

/datum/inventory_slot/shoes/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding && !(hideflags & HIDESHOES))
		if(user == owner)
			return "You are wearing [_holding.get_examine_line()] on your feet."
		return "[pronouns.He] [pronouns.is] wearing [_holding.get_examine_line()] on [pronouns.his] feet."
	for(var/bp in list(BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(owner, bp)
		if(E && E.coating)
			if(user == owner)
				return "There's <font color='[E.coating.get_color()]'>something on your feet</font>!"
			return "There's <font color='[E.coating.get_color()]'>something on [pronouns.his] feet</font>!"
