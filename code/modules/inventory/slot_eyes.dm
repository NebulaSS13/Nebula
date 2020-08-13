/datum/inventory_slot/eyes
	ui_loc = ui_glasses
	ui_label = "glasses"
	overlay_slot = BP_EYES
	slot_flags = SLOT_EYES

/datum/inventory_slot/eyes/handle_icon_updates(var/mob/living/owner, var/obj/item/thing, var/redraw_mob)
	var/mob/living/carbon/human/H = ..()
	if(H)
		H.update_inv_glasses(redraw_mob)
	return H
