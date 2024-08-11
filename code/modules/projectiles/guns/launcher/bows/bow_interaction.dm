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
	for(var/obj/item/stack/material/bow_ammo/ammo in user.get_inactive_held_items())
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
		else if(string)
			remove_string(user)
		else
			return ..()
		return TRUE
	return ..()

/obj/item/gun/launcher/bow/proc/remove_string(mob/user)
	if(!string)
		return
	string.dropInto(loc)
	if(user)
		show_string_remove_message(user)
		user.put_in_hands(string)
	string = null
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
	if(user.try_unequip(new_string, src))
		string = new_string
		if(user)
			show_string_message(user)
		update_icon()
		return TRUE
	return FALSE

/obj/item/gun/launcher/bow/attackby(obj/item/W, mob/user)
	if(can_load_arrow(W))
		if(_loaded)
			to_chat(user, SPAN_WARNING("\The [src] already has \the [_loaded] nocked."))
		else
			load_arrow(user, W)
		return TRUE
	if(istype(W, /obj/item/bowstring) && try_string(user, W))
		return TRUE
	return ..()
