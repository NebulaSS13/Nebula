/datum/inventory_slot
	var/slot_id
	var/ui_loc
	var/ui_label
	var/overlay_slot
	var/screen_element_type
	var/slot_flags
	var/toggleable = TRUE
	var/obj/item/holding

/datum/inventory_slot/New(var/new_slot, var/new_ui_loc, var/new_overlay_slot, var/new_label, var/can_toggle)
	..()
	if(!isnull(new_slot))   slot_id = new_slot
	if(!isnull(new_ui_loc)) ui_loc = new_ui_loc
	if(!isnull(new_label))  ui_label = new_label
	if(!isnull(can_toggle)) toggleable = !!can_toggle
	if(!isnull(new_overlay_slot))
		overlay_slot = new_overlay_slot
	else if(isnull(overlay_slot))
		overlay_slot = new_slot

/datum/inventory_slot/proc/handle_icon_updates(var/mob/living/owner, var/obj/item/thing, var/redraw_mob)
	if(ishuman(owner))
		return owner

/datum/inventory_slot/proc/can_equip(var/mob/living/owner, var/obj/item/equipping)
	if(slot_id == BP_GROIN && !(equipping.item_flags & ITEM_FLAG_IS_BELT) && !owner.get_equipped_item(BP_CHEST) && (BP_CHEST in owner.inventory_slots))
		to_chat(owner, SPAN_WARNING("You need to wear a uniform before you can attach \the [equipping.name]."))
		return FALSE
	return TRUE
