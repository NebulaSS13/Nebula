/obj/item/clothing
	name = "clothing"
	siemens_coefficient = 0.9
	origin_tech = @'{"materials":1,"engineering":1}'
	material = /decl/material/solid/organic/cloth
	paint_verb = "dyed"

	var/wizard_garb = 0
	var/flash_protection = FLASH_PROTECTION_NONE	  // Sets the item's level of flash protection.
	var/tint = TINT_NONE							  // Sets the item's level of visual impairment tint.

	var/bodytype_equip_flags    // Bitfields; if null, checking is skipped. Determine if a given mob can equip this item or not.

	var/list/accessories = list()
	var/list/valid_accessory_slots
	var/list/restricted_accessory_slots
	var/list/starting_accessories
	var/blood_overlay_type = "uniformblood"
	var/visible_name = "Unknown"
	var/ironed_state = WRINKLES_DEFAULT
	var/move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints // if this item covers the feet, the footprints it should leave
	var/volume_multiplier = 1
	var/markings_icon	// simple colored overlay that would be applied to the icon
	var/markings_color	// for things like colored parts of labcoats or shoes

/obj/item/clothing/Initialize()
	. = ..()
	if(markings_icon && markings_color)
		update_icon()

/obj/item/clothing/can_contaminate()
	return TRUE

// Sort of a placeholder for proper tailoring.
#define RAG_COUNT(X) CEILING((LAZYACCESS(X.matter, /decl/material/solid/organic/cloth) * 0.65) / SHEET_MATERIAL_AMOUNT)

/obj/item/clothing/attackby(obj/item/I, mob/user)
	var/rags = RAG_COUNT(src)
	if(rags && (I.edge || I.sharp) && user.a_intent == I_HURT)
		if(length(accessories))
			to_chat(user, SPAN_WARNING("You should remove the accessories attached to \the [src] first."))
			return TRUE
		if(!isturf(loc) && !(src in user.get_held_items()))
			var/it = gender == PLURAL ? "them" : "it"
			to_chat(user, SPAN_WARNING("You must either be holding \the [src], or [it] must be on the ground, before you can shred [it]."))
			return TRUE
		playsound(loc, 'sound/weapons/cablecuff.ogg', 30, 1)
		user.visible_message(SPAN_DANGER("\The [user] begins ripping apart \the [src] with \the [I]."))
		if(do_after(user, 5 SECONDS, src))
			user.visible_message(SPAN_DANGER("\The [user] tears \the [src] into rags with \the [I]."))
			for(var/i = 1 to rags)
				new /obj/item/chems/glass/rag(get_turf(src))
			if(loc == user)
				user.drop_from_inventory(src)
			LAZYREMOVE(matter, /decl/material/solid/organic/cloth)
			physically_destroyed()
		return TRUE
	. = ..()
// End placeholder.

// Updates the vision of the mob wearing the clothing item, if any
/obj/item/clothing/proc/update_wearer_vision()
	if(isliving(src.loc))
		var/mob/living/L = src.loc
		L.handle_vision()

// Checked when equipped, returns true when the wearing mob's vision should be updated
/obj/item/clothing/proc/needs_vision_update()
	return flash_protection || tint

/obj/item/clothing/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_offset = FALSE)

	if(overlay)

		var/decl/bodytype/root_bodytype = user_mob?.get_bodytype()
		if(istype(root_bodytype) && root_bodytype?.onmob_state_modifiers)
			var/state_modifier = root_bodytype.onmob_state_modifiers[slot]
			if(state_modifier && check_state_in_icon("[overlay.icon_state]-[state_modifier]", overlay.icon))
				overlay.icon_state = "[overlay.icon_state]-[root_bodytype.onmob_state_modifiers[slot]]"

		if(markings_icon && markings_color && check_state_in_icon("[overlay.icon_state][markings_icon]", overlay.icon))
			overlay.overlays += mutable_appearance(overlay.icon, "[overlay.icon_state][markings_icon]", markings_color)

		if(length(accessories))
			for(var/obj/item/clothing/accessory/A in accessories)
				if(A.should_overlay())
					overlay.overlays += A.get_mob_overlay(user_mob, slot, skip_offset = TRUE)

		if(!(slot in user_mob?.get_held_item_slots()))
			if(blood_DNA)
				var/mob_blood_overlay = user_mob.get_bodytype()?.get_blood_overlays(user_mob)
				if(mob_blood_overlay)
					var/image/bloodsies = overlay_image(mob_blood_overlay, blood_overlay_type, blood_color, RESET_COLOR)
					bloodsies.appearance_flags |= NO_CLIENT_COLOR
					overlay.overlays += bloodsies
			if(markings_icon && markings_color)
				overlay.overlays += mutable_appearance(overlay.icon, markings_icon, markings_color)

	. = ..()

/obj/item/clothing/on_update_icon()
	. = ..()
	var/base_state = get_world_inventory_state()
	if(markings_icon && markings_color)
		add_overlay(mutable_appearance(icon, "[base_state][markings_icon]", markings_color))
	var/list/new_overlays
	for(var/obj/item/clothing/accessory/accessory in accessories)
		var/image/I = accessory.get_attached_inventory_overlay(base_state)
		if(I)
			LAZYADD(new_overlays, I)
	if(LAZYLEN(new_overlays))
		add_overlay(new_overlays)

// Used by washing machines to temporarily make clothes smell
/obj/item/clothing/proc/change_smell(decl/material/odorant, time = 10 MINUTES)
	if(!odorant || !odorant.scent)
		remove_extension(src, /datum/extension/scent)
		return

	set_extension(src, /datum/extension/scent/custom, odorant.scent, odorant.scent_intensity, odorant.scent_descriptor, odorant.scent_range)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/clothing, change_smell)), time, TIMER_UNIQUE | TIMER_OVERRIDE)

/obj/item/clothing/proc/get_fibers()
	. = "material from \a [name]"
	var/list/acc = list()
	for(var/obj/item/clothing/accessory/A in accessories)
		if(prob(40) && A.get_fibers())
			acc += A.get_fibers()
	if(acc.len)
		. += " with traces of [english_list(acc)]"

/obj/item/clothing/proc/leave_evidence(mob/source)
	add_fingerprint(source)
	if(prob(10))
		ironed_state = WRINKLES_WRINKLY

/obj/item/clothing/Initialize()
	. = ..()
	if(starting_accessories)
		for(var/T in starting_accessories)
			var/obj/item/clothing/accessory/tie = new T(src)
			src.attach_accessory(null, tie)
	if(markings_color && markings_icon)
		update_icon()

/obj/item/clothing/mob_can_equip(mob/user, slot, disable_warning = FALSE, force = FALSE, ignore_equipped = FALSE)
	. = ..()
	if(!. || slot == slot_s_store_str || (slot in global.pocket_slots))
		return
	var/decl/bodytype/root_bodytype = user?.get_bodytype()
	if(!root_bodytype || isnull(bodytype_equip_flags) || (slot in user.get_held_item_slots()))
		return
	if(bodytype_equip_flags & BODY_FLAG_EXCLUDE)
		. = !(bodytype_equip_flags & root_bodytype.bodytype_flag)
	else
		. = (bodytype_equip_flags & root_bodytype.bodytype_flag)
	if(!. && !disable_warning)
		to_chat(user, SPAN_WARNING("\The [src] [gender == PLURAL ? "do" : "does"] not fit you."))

/obj/item/clothing/equipped(var/mob/user)
	if(needs_vision_update())
		update_wearer_vision()
	return ..()

/obj/item/clothing/proc/refit_for_bodytype(var/target_bodytype)

	bodytype_equip_flags = 0
	decls_repository.get_decls_of_subtype(/decl/bodytype) // Make sure they're prefetched so the below list is populated
	for(var/decl/bodytype/bod in global.bodytypes_by_category[target_bodytype])
		bodytype_equip_flags |= bod.bodytype_flag

	var/last_icon = icon
	var/species_icon = LAZYACCESS(sprite_sheets, target_bodytype)
	if(species_icon && (check_state_in_icon(ICON_STATE_INV, species_icon) || check_state_in_icon(ICON_STATE_WORLD, species_icon)))
		icon = species_icon

	if(last_icon != icon)
		reconsider_single_icon()
		update_clothing_icon()

/obj/item/clothing/get_examine_line()
	. = ..()
	var/list/ties = list()
	for(var/obj/item/clothing/accessory/accessory in accessories)
		if(accessory.high_visibility)
			ties += "\a [accessory.get_examine_line()]"
	if(ties.len)
		.+= " with [english_list(ties)] attached"
	if(accessories.len > ties.len)
		.+= ". <a href='?src=\ref[src];list_ungabunga=1'>\[See accessories\]</a>"

/obj/item/clothing/examine(mob/user)
	. = ..()
	var/datum/extension/armor/ablative/armor_datum = get_extension(src, /datum/extension/armor/ablative)
	if(istype(armor_datum) && LAZYLEN(armor_datum.get_visible_damage()))
		to_chat(user, SPAN_WARNING("It has some <a href='?src=\ref[src];list_armor_damage=1'>damage</a>."))

	if(LAZYLEN(accessories))
		to_chat(user, "It has the following attached: [counting_english_list(accessories)]")

	switch(ironed_state)
		if(WRINKLES_WRINKLY)
			to_chat(user, "<span class='bad'>It's wrinkly.</span>")
		if(WRINKLES_NONE)
			to_chat(user, "<span class='notice'>It's completely wrinkle-free!</span>")

	var/rags = RAG_COUNT(src)
	if(rags)
		to_chat(user, SPAN_SUBTLE("With a sharp object, you could cut \the [src] up into [rags] rag\s."))

	var/obj/item/clothing/accessory/vitals_sensor/sensor = locate() in accessories
	if(sensor)
		switch(sensor.sensor_mode)
			if(VITALS_SENSOR_OFF)
				to_chat(user, "Its sensors appear to be disabled.")
			if(VITALS_SENSOR_BINARY)
				to_chat(user, "Its binary life sensors appear to be enabled.")
			if(VITALS_SENSOR_VITAL)
				to_chat(user, "Its vital tracker appears to be enabled.")
			if(VITALS_SENSOR_TRACKING)
				to_chat(user, "Its vital tracker and tracking beacon appear to be enabled.")

#undef RAG_COUNT

/obj/item/clothing/Topic(href, href_list, datum/topic_state/state)
	var/mob/user = usr
	if(istype(user))
		var/turf/T = get_turf(src)
		var/can_see = T.CanUseTopic(user, global.view_topic_state) != STATUS_CLOSE
		if(href_list["list_ungabunga"])
			if(length(accessories) && can_see)
				var/list/ties = list()
				for(var/accessory in accessories)
					ties += "[html_icon(accessory)] \a [accessory]"
				to_chat(user, "Attached to \the [src] are [english_list(ties)].")
			return TOPIC_HANDLED
		if(href_list["list_armor_damage"] && can_see)
			var/datum/extension/armor/ablative/armor_datum = get_extension(src, /datum/extension/armor)
			if(istype(armor_datum))
				var/list/damages = armor_datum.get_visible_damage()
				to_chat(user, "\The [src] [html_icon(src)] has some damage:")
				for(var/key in damages)
					to_chat(user, "<li><b>[capitalize(damages[key])]</b> damage to the <b>[key]</b> armor.")
			return TOPIC_HANDLED
	. = ..()

/obj/item/clothing/get_pressure_weakness(pressure,zone)
	. = ..()
	for(var/obj/item/clothing/accessory/A in accessories)
		. = min(., A.get_pressure_weakness(pressure,zone))

/obj/item/clothing/proc/check_limb_support(var/mob/living/carbon/human/user)
	return FALSE

/obj/item/clothing/verb/toggle_suit_sensors()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	set_sensors(usr)

/obj/item/clothing/proc/set_sensors(mob/user)
	if (isobserver(user) || user.incapacitated())
		return
	var/obj/item/clothing/accessory/vitals_sensor/sensor = locate() in accessories
	if(sensor)
		sensor.user_set_sensors(user)

/obj/item/clothing/handle_loadout_equip_replacement(obj/item/old_item)
	. = ..()
	if(!istype(old_item, /obj/item/clothing) || !(ACCESSORY_SLOT_SENSORS in valid_accessory_slots))
		return
	var/obj/item/clothing/old_clothes = old_item
	var/obj/item/clothing/accessory/vitals_sensor/sensor = locate() in old_clothes.accessories
	if(!sensor)
		return
	sensor.removable = TRUE // This will be refreshed by remove_accessory/attach_accessory
	old_clothes.remove_accessory(null, sensor)
	attach_accessory(null, sensor)


/decl/interaction_handler/clothing_set_sensors
	name = "Set Sensors Level"
	expected_target_type = /obj/item/clothing/under

/decl/interaction_handler/clothing_set_sensors/invoked(var/atom/target, var/mob/user)
	var/obj/item/clothing/under/U = target
	U.set_sensors(user)

/obj/item/clothing/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/clothing_set_sensors)
