/datum/inventory_slot/neck
	ui_loc = ui_id
	ui_label = "id"
	overlay_slot = BP_NECK
	toggleable = FALSE
	slot_flags = SLOT_ID

/datum/inventory_slot/neck/handle_icon_updates(var/mob/living/owner, var/obj/item/thing, var/redraw_mob)
	var/mob/living/carbon/human/H = ..()
	if(H)
		H.update_inv_wear_id(redraw_mob)
	return H
