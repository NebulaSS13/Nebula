/mob/proc/handle_strip(var/slot_to_strip_text,var/mob/living/user,var/obj/item/clothing/holder)
	if(!slot_to_strip_text || !istype(user))
		return

	if(user.incapacitated()  || !user.Adjacent(src))
		show_browser(user, null, "window=mob[src.name]")
		return TRUE

	// Are we placing or stripping?
	var/stripping = FALSE
	var/obj/item/held = user.get_active_held_item()
	if(!istype(held) || is_robot_module(held))
		stripping = TRUE

	switch(slot_to_strip_text)
		// Handle things that are part of this interface but not removing/replacing a given item.
		if("pockets")
			if(stripping)
				visible_message("<span class='danger'>\The [user] is trying to empty [src]'s pockets!</span>")
				if(do_after(user, HUMAN_STRIP_DELAY, src, progress = 0))
					empty_pockets(user)
			else
				//should it be possible to discreetly slip something into someone's pockets?
				visible_message("<span class='danger'>\The [user] is trying to stuff \a [held] into [src]'s pocket!</span>")
				if(do_after(user, HUMAN_STRIP_DELAY, src, progress = 0))
					place_in_pockets(held, user)
			return
		if("sensors")
			visible_message("<span class='danger'>\The [user] is trying to set \the [src]'s sensors!</span>")
			if(do_after(user, HUMAN_STRIP_DELAY, src, progress = 0))
				toggle_sensors(user)
			return
		if ("lock_sensors")
			var/obj/item/clothing/sensor/vitals/sensor = get_vitals_sensor()
			if (!istype(sensor))
				return
			visible_message(SPAN_DANGER("\The [user] is trying to [sensor.get_sensors_locked() ? "un" : ""]lock \the [src]'s sensors!"))
			if (do_after(user, HUMAN_STRIP_DELAY, src, progress = 0))
				if(QDELETED(sensor) || sensor != get_vitals_sensor())
					to_chat(user, SPAN_WARNING("\The [src] is not wearing \the [sensor] anymore."))
					return
				var/obj/item/multitool/user_multitool = user.get_multitool()
				if (!istype(user_multitool))
					to_chat(user, SPAN_WARNING("You need a multitool to lock \the [src]'s sensors."))
					return
				sensor.toggle_sensors_locked()
				visible_message(SPAN_NOTICE("\The [user] [sensor.get_sensors_locked() ? "" : "un"]locks \the [src]'s vitals sensor controls."), range = 2)
			return
		if("internals")
			visible_message("<span class='danger'>\The [usr] is trying to set \the [src]'s internals!</span>")
			if(do_after(user, HUMAN_STRIP_DELAY, src, progress = 0))
				toggle_internals(user)
			return

		if("accessory")
			if(!istype(holder) || !LAZYLEN(holder.accessories))
				return

			var/obj/item/clothing/accessory
			if(LAZYLEN(holder.accessories) > 1)
				accessory = show_radial_menu(user, user, make_item_radial_menu_choices(holder.accessories), radius = 42, tooltips = TRUE)
			else
				accessory = holder.accessories[1]

			if(!istype(accessory))
				return

			visible_message("<span class='danger'>\The [user] is trying to remove \the [src]'s [accessory.name]!</span>")

			if(!do_after(user, HUMAN_STRIP_DELAY, src, check_holding = FALSE, progress = FALSE))
				return

			if(!accessory || holder.loc != src || !(accessory in holder.accessories))
				return

			admin_attack_log(user, src, "Stripped \an [accessory] from \the [holder].", "Was stripped of \an [accessory] from \the [holder].", "stripped \an [accessory] from \the [holder] of")
			holder.remove_accessory(user, accessory)
			return
		else
			var/obj/item/located_item = locate(slot_to_strip_text) in src
			if(isunderwear(located_item))
				var/obj/item/underwear/UW = located_item
				if(UW.DelayedRemoveUnderwear(user, src))
					user.put_in_active_hand(UW)
				return

	var/obj/item/target_slot = get_equipped_item(slot_to_strip_text)
	if(stripping)
		if(!istype(target_slot))  // They aren't holding anything valid and there's nothing to remove, why are we even here?
			return
		if(!target_slot.mob_can_unequip(src, slot_to_strip_text, disable_warning=1))
			to_chat(user, SPAN_WARNING("You cannot remove \the [src]'s [target_slot.name]."))
			return

		visible_message("<span class='danger'>\The [user] is trying to remove \the [src]'s [target_slot.name]!</span>")
	else
		visible_message("<span class='danger'>\The [user] is trying to put \a [held] on \the [src]!</span>")

	if(!do_mob(user, src, HUMAN_STRIP_DELAY, check_holding = FALSE))
		return

	if(stripping)
		if(try_unequip(target_slot))
			admin_attack_log(user, src, "Stripped \a [target_slot]", "Was stripped of \a [target_slot].", "stripped \a [target_slot] from")
			user.put_in_active_hand(target_slot)
		else
			admin_attack_log(user, src, "Attempted to strip \a [target_slot]", "Target of a failed strip of \a [target_slot].", "attempted to strip \a [target_slot] from")
	else if(user.try_unequip(held))
		var/obj/item/clothing/C = get_equipped_item(slot_to_strip_text)
		if(istype(C) && C.can_attach_accessory(held, user))
			C.attach_accessory(user, held)
		else if(!equip_to_slot_if_possible(held, slot_to_strip_text, del_on_fail=0, disable_warning=1, redraw_mob=1))
			user.put_in_active_hand(held)

// Empty out everything in the target's pockets.
/mob/proc/empty_pockets(var/mob/living/user)
	for(var/slot in global.pocket_slots)
		var/obj/item/pocket = get_equipped_item(slot)
		if(pocket)
			try_unequip(pocket)
			. = TRUE
	if(.)
		visible_message(SPAN_DANGER("\The [user] empties \the [src]'s pockets!"))
	else
		to_chat(user, SPAN_WARNING("\The [src] has nothing in their pockets."))

/mob/proc/place_in_pockets(obj/item/I, var/mob/living/user)
	if(!user.try_unequip(I))
		return
	for(var/slot in global.pocket_slots)
		if(!get_equipped_item(slot) && equip_to_slot_if_possible(I, slot, del_on_fail=0, disable_warning=1, redraw_mob=1))
			return
	to_chat(user, SPAN_WARNING("You are unable to place [I] in [src]'s pockets."))
	user.put_in_active_hand(I)

// Modify the current target sensor level.
/mob/proc/toggle_sensors(var/mob/living/user)
	var/obj/item/clothing/sensor/vitals/sensor = get_vitals_sensor()
	if(!istype(sensor))
		to_chat(user, SPAN_WARNING("\The [src] is not wearing a vitals sensor."))
	if (sensor.get_sensors_locked())
		to_chat(user, SPAN_WARNING("\The [src]'s suit sensor controls are locked."))
		return
	admin_attack_log(user, src, "Toggled their suit sensors.", "Toggled their suit sensors.", "toggled the suit sensors of")
	sensor.user_set_sensors(user)

/mob/proc/get_vitals_sensor()
	for(var/check_slot in global.vitals_sensor_equip_slots)
		var/obj/item/clothing/equipped = get_equipped_item(check_slot)
		if(istype(equipped))
			return (locate(/obj/item/clothing/sensor/vitals) in equipped.accessories)
