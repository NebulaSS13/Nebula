/obj/screen/inventory/hand
	icon_state = "hand_base"

/obj/screen/inventory/hand/rebuild_screen_overlays()

	..()

	// Validate our owner still exists.
	var/mob/owner = owner_ref?.resolve()
	if(!istype(owner) || QDELETED(owner) || !(src in owner.client?.screen))
		return

	var/overlay_color = owner?.client?.prefs.UI_style_highlight_color || COLOR_WHITE
	var/decl/ui_style/ui_style = get_owner_ui_style()
	if(owner.get_active_held_item_slot() == slot_id)
		if(ui_style?.use_overlay_color)
			add_overlay(overlay_image(icon, "hand_selected", overlay_color, RESET_COLOR))
		else
			add_overlay("hand_selected")

	var/datum/inventory_slot/gripper/inv_slot = owner.get_inventory_slot_datum(slot_id)
	if(istype(inv_slot))
		if(ui_style?.use_overlay_color)
			add_overlay(overlay_image(icon, "hand_[inv_slot.hand_overlay || slot_id]", overlay_color, RESET_COLOR))
		else
			add_overlay("hand_[inv_slot.hand_overlay || slot_id]", TRUE)
		if(inv_slot.ui_label)
			if(ui_style?.use_overlay_color)
				add_overlay(overlay_image(icon, "hand_[inv_slot.ui_label]", overlay_color, RESET_COLOR))
			else
				add_overlay("hand_[inv_slot.ui_label]", TRUE)
