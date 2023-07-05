/datum/inventory_slot

	var/slot_name = "Unknown"
	var/slot_id
	var/slot_state
	var/slot_dir

	var/ui_loc
	var/ui_label
	var/overlay_slot

	var/obj/item/_holding
	var/list/drop_slots_on_unequip
	var/covering_flags = 0
	var/covering_slots
	var/can_be_hidden = FALSE
	var/skip_on_inventory_display = FALSE
	var/skip_on_strip_display = FALSE
	var/requires_slot_flags
	var/requires_organ_tag

/datum/inventory_slot/Destroy(force)
	_holding = null
	return ..()

/datum/inventory_slot/proc/equipped(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE, var/delete_old_item = TRUE)

	// Clear up any preexisting item.
	var/atom/movable/held = get_equipped_item()
	if(held)
		user.drop_from_inventory(held)
		if(delete_old_item && !QDELETED(held))
			qdel(held)

	// Set slot vars.
	set_slot(prop)
	prop.forceMove(user)
	prop.hud_layerise()
	prop.equipped(user, slot_id)

	// Redraw overlays if needed.
	update_overlay(user, prop, redraw_mob)
	return TRUE

/datum/inventory_slot/proc/unequipped(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	clear_slot()
	for(var/slot in drop_slots_on_unequip)
		var/obj/item/thing = user.get_equipped_item(slot)
		if(thing)
			user.drop_from_inventory(thing)
	update_overlay(user, prop, redraw_mob)
	return TRUE

/datum/inventory_slot/proc/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	return

/datum/inventory_slot/proc/set_slot(var/obj/item/prop)
	_holding = prop
	if(_holding)
		_holding.screen_loc = ui_loc

/datum/inventory_slot/proc/clear_slot()
	if(_holding)
		_holding.screen_loc = null
	_holding = null

/datum/inventory_slot/proc/is_accessible(var/mob/user, var/obj/item/prop, var/disable_warning)
	if(!covering_flags)
		return TRUE
	var/list/covering_items = get_covering_items(user)
	if(!length(covering_items))
		return TRUE
	var/coverage_flags = (prop.body_parts_covered|covering_flags)
	for(var/obj/item/covering in covering_items)
		if(covering.body_parts_covered & coverage_flags)
			if(!disable_warning)
				to_chat(user, SPAN_WARNING("\The [covering] is in the way."))
			return FALSE
	return TRUE

/datum/inventory_slot/proc/get_covering_items(var/mob/user)
	if(!covering_slots)
		return null
	if(islist(covering_slots))
		for(var/covering_slot in covering_slots)
			var/thing = user.get_equipped_item(covering_slot)
			if(thing)
				LAZYADD(., thing)
	else
		var/thing = user.get_equipped_item(covering_slots)
		if(thing)
			LAZYADD(., thing)

/datum/inventory_slot/proc/get_covering_flags(var/mob/user)
	return covering_flags

/datum/inventory_slot/proc/get_equipped_item()
	return _holding

/datum/inventory_slot/proc/get_equipped_name()
	return _holding?.name

/datum/inventory_slot/proc/hide_slot()
	if(_holding)
		_holding.screen_loc = null

/datum/inventory_slot/proc/show_slot()
	if(_holding)
		_holding.screen_loc = ui_loc

/datum/inventory_slot/proc/check_has_required_organ(var/mob/user)
	if(!requires_organ_tag)
		return TRUE
	if(islist(requires_organ_tag))
		for(var/bp in requires_organ_tag)
			if(user.get_organ(bp))
				return TRUE
	return user.get_organ(requires_organ_tag)

/datum/inventory_slot/proc/equivalent_to(var/datum/inventory_slot/other_slot)
	if(!istype(other_slot) || QDELETED(other_slot) || QDELETED(src))
		return FALSE
	if(other_slot.type != type)
		return FALSE
	if(other_slot.slot_id != slot_id)
		return FALSE
	if(other_slot.slot_name != slot_name)
		return FALSE
	if(other_slot.slot_state != slot_state)
		return FALSE
	if(other_slot.ui_loc != ui_loc)
		return FALSE
	return TRUE

/datum/inventory_slot/proc/can_equip_to_slot(var/mob/user, var/obj/item/prop, var/disable_warning, var/ignore_equipped)
	return ((!_holding || (ignore_equipped && _holding == prop)) && prop && slot_id && prop_can_fit_in_slot(prop))

/datum/inventory_slot/proc/prop_can_fit_in_slot(var/obj/item/prop)
	return (isnull(requires_slot_flags) || (requires_slot_flags & prop.slot_flags))

/datum/inventory_slot/proc/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding)
		if(user == owner)
			return "You are wearing [_holding.get_examine_line()]."
		return "[pronouns.He] [pronouns.is] wearing [_holding.get_examine_line()]."
