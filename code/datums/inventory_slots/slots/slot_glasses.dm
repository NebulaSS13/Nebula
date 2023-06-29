/datum/inventory_slot/glasses
	slot_name = "Glasses"
	slot_state = "glasses"
	ui_loc = ui_glasses
	slot_id = slot_glasses_str
	covering_slots = slot_head_str
	covering_flags = SLOT_EYES
	can_be_hidden = TRUE
	requires_organ_tag = BP_HEAD
	requires_slot_flags = SLOT_EYES

/datum/inventory_slot/glasses/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	user.update_inv_glasses(redraw_mob)

/datum/inventory_slot/glasses/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding && !(hideflags & HIDEEYES))
		if(user == owner)
			return "You have [_holding.get_examine_line()] covering your eyes."
		return "[pronouns.He] [pronouns.has] [_holding.get_examine_line()] covering [pronouns.his] eyes."
