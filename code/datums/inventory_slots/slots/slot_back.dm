/datum/inventory_slot/back
	slot_name = "Back"
	slot_id = slot_back_str
	ui_loc = ui_back
	slot_state = "back"
	requires_organ_tag = BP_CHEST
	requires_slot_flags = SLOT_BACK
	quick_equip_priority = 13

/datum/inventory_slot/back/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	user.update_inv_back(redraw_mob)

/datum/inventory_slot/back/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding)
		return "[pronouns.He] [pronouns.has] [_holding.get_examine_line()] on [pronouns.his] back."
