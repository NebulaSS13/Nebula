/datum/inventory_slot/ear
	ui_label = "ears"
	slot_flags = SLOT_EARS

/datum/inventory_slot/ear/handle_icon_updates(mob/living/owner, obj/item/thing, redraw_mob)
	var/mob/living/carbon/human/H = ..()
	if(H)
		H.update_inv_ears(redraw_mob)
	return H
