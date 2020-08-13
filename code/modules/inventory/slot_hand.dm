// Most of the values for hand slots are provided by the organ directly
// rather than inherited, since hand slots are highly variable.
/datum/inventory_slot/hand/handle_icon_updates(var/mob/living/owner, var/obj/item/thing, var/redraw_mob)
	var/mob/living/carbon/human/H = ..()
	if(H)
		H.update_inv_hands(redraw_mob)
	return H
