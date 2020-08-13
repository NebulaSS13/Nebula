/datum/inventory_slot/groin
	ui_loc = ui_belt
	ui_label = "belt"
	overlay_slot = BP_GROIN
	toggleable = FALSE
	slot_flags = SLOT_LOWER_BODY

/datum/inventory_slot/groin/handle_icon_updates(var/mob/living/owner, var/obj/item/thing, var/redraw_mob)
	var/mob/living/carbon/human/H = ..()
	if(H)
		H.update_inv_belt(redraw_mob)
	return H
