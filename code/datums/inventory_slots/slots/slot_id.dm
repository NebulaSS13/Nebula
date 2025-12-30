/datum/inventory_slot/id
	slot_name = "ID"
	slot_state = "id"
	ui_loc = ui_id
	slot_id = slot_wear_id_str
	requires_slot_flags = SLOT_ID
	mob_overlay_layer = HO_ID_LAYER
	quick_equip_priority = 13
	fluid_height = (FLUID_SHALLOW + FLUID_OVER_MOB_HEAD) / 2 // halfway between waist and top of head, so roughly chest level

/datum/inventory_slot/id/update_mob_equipment_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	var/obj/item/clothing/clothes = user.get_equipped_item(slot_w_uniform_str)
	if(istype(clothes) && clothes.should_show_id())
		user.set_current_mob_overlay(HO_ID_LAYER, null, redraw_mob)
	else
		..()
	BITSET(user.hud_updateflag, ID_HUD)
	BITSET(user.hud_updateflag, WANTED_HUD)

/datum/inventory_slot/id/can_equip_to_slot(var/mob/user, var/obj/item/prop, var/disable_warning, var/ignore_equipped)
	. = ..()
	if(.)
		// If they have a uniform slot, they need a uniform to wear an ID card.
		var/datum/inventory_slot/check_slot = user.get_inventory_slot_datum(slot_w_uniform_str)
		if(check_slot && !check_slot.get_equipped_item())
			if(!disable_warning)
				to_chat(user, SPAN_WARNING("You need to be wearing something on your body before you can wear \the [prop]."))
			return FALSE
