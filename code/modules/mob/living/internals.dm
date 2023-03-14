/mob/living/proc/get_breath_from_internal(var/volume_needed=STD_BREATH_VOLUME) //hopefully this will allow overrides to specify a different default volume without breaking any cases where volume is passed in.
	var/obj/item/tank/internal = get_internals()
	if(!internal)
		return
	if (!contents.Find(internal))
		set_internals(null)
	var/obj/item/mask = get_equipped_item(slot_wear_mask_str)
	if (!mask || !(mask.item_flags & ITEM_FLAG_AIRTIGHT))
		set_internals(null)
	internal = get_internals()
	return internal?.remove_air_volume(volume_needed)

/mob/living/proc/set_internals(obj/item/tank/source, source_string)
	var/old_internal = get_internals()
	if(!old_internal && source)
		if(!source_string)
			source_string = source.name
		to_chat(src, SPAN_NOTICE("You are now running on internals from \the [source_string]."))
		playsound(src, 'sound/effects/internals.ogg', 50, 0)
	if(old_internal && !source)
		to_chat(src, SPAN_NOTICE("You are no longer running on internals."))
	internal = source
	if(internals_ui)
		internals_ui.icon_state = "internal[!!internal]"

/mob/living/proc/get_internals()
	return internal

/mob/living/hud_reset(full_reset = FALSE)
	. = ..()
	if(!.)
		return
	if(internals_ui && get_internals())
		internals_ui.icon_state = "internal1"
	for(var/obj/item/gear in get_equipped_items(TRUE))
		client.screen |= gear
	if(hud_used)
		hud_used.hidden_inventory_update()
		hud_used.persistant_inventory_update()
		update_action_buttons()
	if(internals_ui && internal)
		internals_ui.icon_state = "internal1"
	queue_hand_rebuild()

// Set internals on or off. Implemented properly on /carbon
/mob/living/proc/toggle_internals(var/mob/living/user)
	var/atom/movable/internal = get_internals()
	if(internal)
		visible_message(SPAN_NOTICE("\The [user] disables \the [src]'s internals!"))
		internal.add_fingerprint(user)
		set_internals(null)
		return

	// Check for airtight mask/helmet.
	var/found_mask = FALSE
	for(var/slot in global.airtight_slots)
		var/obj/item/gear = get_equipped_item(slot)
		if(gear && (gear.item_flags & ITEM_FLAG_AIRTIGHT))
			found_mask = TRUE
			break

	if(!found_mask)
		to_chat(user, SPAN_WARNING("\The [src] does not have a suitable mask or helmet."))
		return

	// Find an internal source.
	var/list/possible_sources = get_possible_internals_sources()
	for(var/slot in possible_sources)
		var/list/source_info = possible_sources[slot]
		if(length(source_info) < 2)
			continue
		var/obj/item/tank/tank = source_info[1]
		if(istype(tank))
			set_internals(tank)
			visible_message(SPAN_NOTICE("\The [src] is now running on internals!"))
			internal.add_fingerprint(user)
			return

	to_chat(user, SPAN_WARNING("You could not find a suitable tank!"))

/mob/living/proc/breathing_hole_covered()
	var/obj/item/mask = get_equipped_item(slot_wear_mask_str)
	. = (mask?.item_flags & ITEM_FLAG_AIRTIGHT)

/mob/living/proc/get_possible_internals_sources()
	. = get_equipped_internals_sources()
	for(var/slot in held_item_slots)
		var/obj/item/tank/checking = get_equipped_item(slot)
		if(istype(checking))
			.[parse_zone(slot)] = list(checking, "in")

/mob/living/proc/get_equipped_internals_sources()
	. = list("back" = list(get_equipped_item(slot_back_str), "on"))

/mob/living/proc/set_internals_to_best_available_tank(var/breathes_gas = /decl/material/gas/oxygen, var/list/poison_gas = list(/decl/material/gas/chlorine))

	if(!ispath(breathes_gas))
		return

	var/list/possible_sources = get_possible_internals_sources()
	var/selected_slot
	var/selected_from
	var/obj/item/tank/selected_obj
	var/decl/material/breathing_gas = GET_DECL(breathes_gas)
	for(var/slot_name in possible_sources)
		var/list/checking_data = possible_sources[slot_name]
		if(length(checking_data) < 2)
			continue
		var/obj/item/tank/checking = checking_data[1]
		if(!istype(checking) || !checking.air_contents?.gas)
			continue

		var/valid_tank = (checking.manipulated_by && checking.manipulated_by != real_name && findtext(checking.desc, breathing_gas.name))
		if(!valid_tank)
			if(!checking.air_contents.gas[breathes_gas])
				continue
			var/is_poison = FALSE
			for(var/poison in poison_gas)
				if(checking.air_contents.gas[poison])
					is_poison = TRUE
					break
			if(!is_poison)
				valid_tank = TRUE

		if(valid_tank && (!selected_obj || selected_obj.air_contents.gas[breathes_gas] <  checking.air_contents.gas[breathes_gas]))
			selected_obj =  checking
			selected_slot = slot_name
			selected_from = checking_data[2]

	if(selected_obj)
		if(selected_slot && selected_from)
			set_internals(selected_obj, "\the [selected_obj] [selected_from] your [selected_slot]")
		else
			set_internals(selected_obj, "\the [selected_obj]")

/mob/living/proc/ui_toggle_internals()

	if(incapacitated())
		return

	if(get_internals())
		set_internals(null)
		return

	if(!breathing_hole_covered())
		to_chat(src, SPAN_WARNING("You are not wearing a suitable mask or helmet."))
		return

	set_internals_to_best_available_tank()

	if(!get_internals())
		to_chat(src, SPAN_WARNING("You don't have a tank that is usable as internals."))
