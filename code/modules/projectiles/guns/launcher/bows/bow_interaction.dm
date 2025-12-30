/obj/item/gun/launcher/bow/attack_self(mob/user)

	if(tension)
		relax_tension(user)
		return TRUE

	if(!get_loaded_arrow(user) && !autofire_enabled && user.skill_check(SKILL_WEAPONS, SKILL_ADEPT) && load_available_ammo(user))
		return TRUE

	if(!autofire_enabled && get_loaded_arrow(user))
		start_drawing(user)
		return TRUE

	return ..()

/obj/item/gun/launcher/bow/proc/load_available_ammo(mob/living/user)

	var/list/possible_arrows = list()
	possible_arrows += user.get_inactive_held_items()
	for(var/accessory_slot in list(slot_back_str, slot_w_uniform_str, slot_wear_suit_str, slot_back_str))
		var/obj/item/gear = user.get_equipped_item(accessory_slot)
		if(!istype(gear))
			continue
		if(gear.storage)
			possible_arrows |= gear.get_stored_inventory()
		if(istype(gear, /obj/item/clothing))
			var/obj/item/clothing/clothes = gear
			for(var/obj/item/clothing/accessory in clothes.accessories)
				if(accessory.storage)
					possible_arrows |= accessory.get_stored_inventory()

	for(var/obj/item/ammo in possible_arrows)
		if(!can_load_arrow(ammo))
			continue
		attackby(ammo, user)
		if(get_loaded_arrow(user))
			if(!autofire_enabled)
				start_drawing(user)
			return TRUE

	return FALSE

/obj/item/gun/launcher/bow/attack_hand(mob/user)
	if(user.is_holding_offhand(src))
		if(tension)
			relax_tension(user)
		if(_loaded)
			remove_arrow(user)
		else if(istype(string))
			remove_string(user)
		else
			return ..()
		return TRUE
	return ..()

/obj/item/gun/launcher/bow/proc/remove_string(mob/user)
	if(!istype(string))
		return
	string.dropInto(loc)
	if(user)
		show_string_remove_message(user)
		user.put_in_hands(string)
	set_string(null)
	update_icon()

/obj/item/gun/launcher/bow/proc/remove_arrow(mob/user)
	if(user)
		show_unload_message(user)

	if(_loaded)

		if(istype(_loaded, /obj/item/stack/material/bow_ammo))
			var/obj/item/stack/material/bow_ammo/arrow = _loaded
			arrow.removed_from_bow(user)

		if(!QDELETED(_loaded))
			_loaded.dropInto(loc)
			if(user)
				user.put_in_hands(_loaded)
		_loaded = null

	update_icon()

/obj/item/gun/launcher/bow/proc/relax_tension(mob/user)
	tension = 0
	update_icon()
	if(autofire_enabled)
		clear_autofire()
	else if(user)
		show_string_relax_message(user)

/obj/item/gun/launcher/bow/proc/try_string(mob/user, obj/item/bowstring/new_string)
	if(string)
		to_chat(user, SPAN_WARNING("\The [src] is already strung."))
		return TRUE
	// check to make sure it fits
	var/datum/storage/loc_storage = loc.storage
	if(loc_storage)
		if(strung_w_class > loc_storage.max_w_class)
			to_chat(user, SPAN_WARNING("\The [src] can't fit in \the [loc] when strung, take it out first!"))
			return TRUE
		if((loc_storage.storage_space_used() - w_class + strung_w_class) > loc_storage.max_storage_space)
			to_chat(user, SPAN_WARNING("\The [loc] is too full to fit \the [src] when strung, make some room!"))
			return TRUE
	if(user.try_unequip(new_string, src))
		set_string(new_string)
		if(user)
			show_string_message(user)
		update_icon()
		return TRUE
	return FALSE

/obj/item/gun/launcher/bow/attackby(obj/item/used_item, mob/user)
	if(can_load_arrow(used_item))
		if(_loaded)
			to_chat(user, SPAN_WARNING("\The [src] already has \the [_loaded] ready."))
		else
			load_arrow(user, used_item)
		return TRUE
	if(istype(used_item, /obj/item/bowstring) && try_string(user, used_item))
		return TRUE
	return ..()
