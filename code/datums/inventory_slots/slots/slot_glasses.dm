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
	mob_overlay_layer = HO_GLASSES_LAYER
	alt_mob_overlay_layer = HO_GOGGLES_LAYER
	quick_equip_priority = 5

/datum/inventory_slot/glasses/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding && !(hideflags & HIDEEYES))
		if(user == owner)
			return "You have [_holding.get_examine_line()] covering your eyes."
		return "[pronouns.He] [pronouns.has] [_holding.get_examine_line()] covering [pronouns.his] eyes."
