/datum/inventory_slot/back
	slot_name = "Back"
	slot_id = slot_back_str
	ui_loc = ui_back
	slot_state = "back"
	requires_organ_tag = BP_CHEST
	requires_slot_flags = SLOT_BACK
	mob_overlay_layer = HO_BACK_LAYER
	quick_equip_priority = 14
	fluid_height = (FLUID_SHALLOW + FLUID_OVER_MOB_HEAD) / 2 // halfway between waist and top of head, so roughly chest level
	additional_quick_equip_slots = list(slot_in_backpack_str)

/datum/inventory_slot/back/simple
	requires_organ_tag = null
	use_overlay_fallback_slot = FALSE

/datum/inventory_slot/back/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding)
		return "[pronouns.He] [pronouns.has] [_holding.get_examine_line()] on [pronouns.his] back."
