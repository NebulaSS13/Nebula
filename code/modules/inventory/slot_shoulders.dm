/datum/inventory_slot/shoulders
	ui_loc = ui_back
	ui_label = "back"
	overlay_slot = BP_SHOULDERS
	slot_flags = SLOT_BACK
	toggleable = FALSE

/datum/inventory_slot/shoulders/handle_icon_updates(var/mob/living/owner, var/obj/item/thing, var/redraw_mob)
	var/mob/living/carbon/human/H = ..()
	if(H)
		H.update_inv_back(redraw_mob)
	return H
