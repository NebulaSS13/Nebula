// TODO: look at all uses of this and refresh_visible_overlays(), probably should be using update_icon().
/mob/proc/try_refresh_visible_overlays()
	SHOULD_CALL_PARENT(TRUE)
	if(HasMovementHandler(/datum/movement_handler/mob/transformation) || QDELETED(src))
		return FALSE
	refresh_visible_overlays()
	apply_visible_overlays()
	return TRUE

/mob/proc/refresh_visible_overlays()
	SHOULD_CALL_PARENT(TRUE)
	for(var/slot in get_inventory_slots())
		update_equipment_overlay(slot, FALSE)
	return TRUE

/mob/proc/apply_visible_overlays()
	cut_overlays()
	for(var/overlay in get_all_current_mob_overlays())
		add_overlay(overlay)
	underlays = get_all_current_mob_underlays()

/mob/proc/update_equipment_overlay(var/slot, var/redraw_mob = TRUE)
	var/datum/inventory_slot/inv_slot = slot && get_inventory_slot_datum(slot)
	if(inv_slot)
		inv_slot.update_mob_equipment_overlay(src, null, redraw_mob)

/mob/proc/update_inhand_overlays(var/redraw_mob = TRUE)
	var/list/hand_overlays = null
	for(var/hand_slot in get_held_item_slots())
		var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(hand_slot)
		var/obj/item/held = inv_slot?.get_equipped_item()
		var/image/standing = held?.get_mob_overlay(src, inv_slot.overlay_slot, hand_slot, inv_slot.use_overlay_fallback_slot)
		if(standing)
			standing.appearance_flags |= (RESET_ALPHA|RESET_COLOR)
			LAZYADD(hand_overlays, standing)
	set_current_mob_overlay(HO_INHAND_LAYER, hand_overlays, redraw_mob)

/mob/proc/get_current_mob_overlay(var/overlay_layer)
	return

/mob/proc/get_all_current_mob_overlays()
	return

/mob/proc/set_current_mob_overlay(var/overlay_layer, var/image/overlay, var/redraw_mob = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(redraw_mob)
		cut_overlays()
		apply_visible_overlays()

/mob/proc/get_current_mob_underlay(var/underlay_layer)
	return

/mob/proc/get_all_current_mob_underlays()
	return

/mob/proc/set_current_mob_underlay(var/underlay_layer, var/image/underlay, var/redraw_mob = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(redraw_mob)
		queue_icon_update()

/mob/proc/update_genetic_conditions()
	return

/mob/proc/update_hair(var/update_icons=1)
	return