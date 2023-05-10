/datum/inventory_slot/id
	slot_name = "ID"
	slot_state = "id"
	ui_loc = ui_id
	slot_id = slot_wear_id_str
	requires_slot_flags = SLOT_ID

/datum/inventory_slot/id/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	user.update_inv_wear_id(redraw_mob)
