/obj/item/clothing
	name = "clothing"
	siemens_coefficient = 0.9
	origin_tech = @'{"materials":1,"engineering":1}'
	material = /decl/material/solid/organic/cloth
	paint_verb = "dyed"
	replaced_in_loadout = TRUE
	w_class = ITEM_SIZE_SMALL
	icon_state = ICON_STATE_WORLD
	_base_attack_force = 0

	var/wizard_garb = 0
	var/flash_protection = FLASH_PROTECTION_NONE	  // Sets the item's level of flash protection.
	var/tint = TINT_NONE							  // Sets the item's level of visual impairment tint.
	var/bodytype_equip_flags    // Bitfields; if null, checking is skipped. Determine if a given mob can equip this item or not.

	var/list/accessories

	var/list/valid_accessory_slots

	var/list/restricted_accessory_slots = list(
		ACCESSORY_SLOT_UTILITY,
		ACCESSORY_SLOT_HOLSTER,
		ACCESSORY_SLOT_ARMBAND,
		ACCESSORY_SLOT_RANK,
		ACCESSORY_SLOT_DEPT,
		ACCESSORY_SLOT_OVER
	)

	var/list/starting_accessories
	var/blood_overlay_type = "uniformblood"
	var/visible_name = "Unknown"
	var/ironed_state = WRINKLES_DEFAULT
	var/move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints // if this item covers the feet, the footprints it should leave
	var/volume_multiplier = 1
	var/markings_state_modifier	// simple colored overlay that would be applied to the icon
	var/markings_color	// for things like colored parts of labcoats or shoes
	var/should_display_id = TRUE
	var/fallback_slot

/obj/item/clothing/get_equipment_tint()
	return tint

/obj/item/clothing/get_matter_amount_modifier()
	return ..() * 5 // clothes are complicated and have a high surface area. todo: a better way to do this?

/obj/item/clothing/Initialize()

	. = ..()
	setup_equip_flags()

	if(accessory_slot)
		if(isnull(accessory_removable))
			accessory_removable = TRUE
		if(isnull(fallback_slot))
			fallback_slot = slot_w_uniform_str
		accessory_hide_on_states = get_initial_accessory_hide_on_states()

	if(starting_accessories)
		for(var/T in starting_accessories)
			attach_accessory(null, new T(src))
	if(ACCESSORY_SLOT_SENSORS in valid_accessory_slots)
		set_extension(src, /datum/extension/interactive/multitool/items/clothing)

	if(update_clothing_state_toggles() || (markings_color && markings_state_modifier))
		update_icon()

/obj/item/clothing/Destroy()
	if(is_accessory())
		on_removed()
	return ..()

/obj/item/clothing/get_fallback_slot(slot)
	return fallback_slot

/obj/item/clothing/get_stored_inventory()
	. = ..()
	if(length(.) && length(accessories))
		. -= accessories

/obj/item/clothing/proc/is_accessory()
	return istype(loc, /obj/item/clothing)

/obj/item/clothing/proc/setup_equip_flags()
	if(!isnull(bodytype_equip_flags))
		if(bodytype_equip_flags & BODY_FLAG_EXCLUDE)
			bodytype_equip_flags |= BODY_FLAG_QUADRUPED
		else
			bodytype_equip_flags &= ~BODY_FLAG_QUADRUPED

/obj/item/clothing/can_contaminate()
	return TRUE

// Sort of a placeholder for proper tailoring.
#define RAG_COUNT(X) ceil((LAZYACCESS(X.matter, /decl/material/solid/organic/cloth) * 0.65) / SHEET_MATERIAL_AMOUNT)

/obj/item/clothing/attackby(obj/item/I, mob/user)
	var/rags = RAG_COUNT(src)
	if(istype(material) && material.default_solid_form && rags && (I.edge || I.sharp) && user.a_intent == I_HURT)
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
			user.visible_message(SPAN_DANGER("\The [user] tears \the [src] apart with \the [I]."))
			material.create_object(get_turf(src), rags)
			if(loc == user)
				user.drop_from_inventory(src)
			LAZYREMOVE(matter, material.type)
			material = null
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

/obj/item/clothing/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)

	if(!overlay)
		return ..()

	// Synchronize our modifiers.
	// Holder takes precedence, if we're attached as an accessory.
	var/list/sync_modifiers = list(overlay.icon_state)
	var/obj/item/clothing/holder = istype(loc, /obj/item/clothing) ? loc : null
	var/list/modifiers = list()
	if(length(clothing_state_modifiers))
		modifiers |= clothing_state_modifiers
	if(length(holder?.clothing_state_modifiers))
		modifiers |= holder.clothing_state_modifiers
	for(var/modifier_type in modifiers)
		var/decl/clothing_state_modifier/modifier = GET_DECL(modifier_type)
		// Do we even care about this one?
		if(!modifier.applies_icon_state_modifier)
			continue
		if(!(modifier_type in clothing_state_modifiers))
			continue
		if(holder?.clothing_state_modifiers && !holder.clothing_state_modifiers[modifier_type])
			continue
		if(!LAZYACCESS(clothing_state_modifiers, modifier_type))
			continue
		LAZYADD(sync_modifiers, modifier.icon_state_modifier)

	var/new_state = JOINTEXT(sync_modifiers)
	if(check_state_in_icon(new_state, overlay.icon))
		overlay.icon_state = new_state

	// Apply our bodytype modifier if any applies. At time of writing this is restricted to some specific
	// uniforms with a 'feminine' version that looks like someone has used an industrial press on their waist.
	var/decl/bodytype/root_bodytype = user_mob?.get_bodytype()
	if(slot in root_bodytype?.onmob_state_modifiers)
		new_state = jointext(list(overlay.icon_state, root_bodytype.onmob_state_modifiers[slot]), "-")
		if(check_state_in_icon(new_state, overlay.icon))
			overlay.icon_state = new_state

	// Apply any marking overlays that we have defined.
	if(markings_state_modifier && markings_color)
		new_state = JOINTEXT(list(overlay.icon_state, markings_state_modifier))
		if(check_state_in_icon(new_state, overlay.icon))
			overlay.overlays += mutable_appearance(overlay.icon, new_state, markings_color)

	// Apply a bloodied effect if the mob has been besmirched.
	// Don't do this for inhands as the overlay is generally not slot based.
	// TODO: make this slot based and masked to the onmob overlay?
	if(!(slot in user_mob?.get_held_item_slots()) && blood_DNA && blood_overlay_type)
		var/mob_blood_overlay = user_mob?.get_bodytype()?.get_blood_overlays(user_mob)
		if(mob_blood_overlay)
			var/image/bloodsies = overlay_image(mob_blood_overlay, blood_overlay_type, blood_color, RESET_COLOR)
			bloodsies.appearance_flags |= NO_CLIENT_COLOR
			overlay.overlays += bloodsies

	// We apply accessory overlays after calling parent so accessories are not offset twice.
	overlay = ..()
	if(overlay && length(accessories))
		for(var/obj/item/clothing/accessory in accessories)
			if(accessory.should_overlay())
				overlay.overlays += accessory.get_mob_overlay(user_mob, slot, bodypart)
	return overlay

/obj/item/clothing/set_dir(ndir)
	// Avoid rendering the profile or back sides of the mob overlay we used when accessories are rendered.
	if(length(accessories))
		ndir = SOUTH
	return ..()

/obj/item/clothing/on_update_icon()
	. = ..()

	// Clothing does not generally align with each other's world icons, so we just use the mob overlay in this case.
	var/set_appearance = FALSE
	if(length(accessories))
		var/image/I = get_mob_overlay(ismob(loc) ? loc : null, get_fallback_slot())
		if(I)
			I.plane = plane
			I.layer = layer
			I.alpha = alpha
			I.color = color
			I.name = name
			appearance = I
			set_dir(SOUTH)
			set_appearance = TRUE
	if(!set_appearance)
		icon_state = JOINTEXT(list(get_world_inventory_state(), get_clothing_state_modifier()))
		if(markings_state_modifier && markings_color)
			add_overlay(mutable_appearance(icon, "[icon_state][markings_state_modifier]", markings_color))

	update_clothing_icon()


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
	for(var/obj/item/clothing/accessory in accessories)
		if(prob(40) && accessory.get_fibers())
			acc += accessory.get_fibers()
	if(acc.len)
		. += " with traces of [english_list(acc)]"

/obj/item/clothing/proc/leave_evidence(mob/source)
	add_fingerprint(source)
	if(prob(10))
		ironed_state = WRINKLES_WRINKLY

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
	update_icon()
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

/obj/item/clothing/get_examine_name()
	var/list/ensemble = list(name)
	for(var/obj/item/clothing/accessory in accessories)
		if(accessory.accessory_visibility == ACCESSORY_VISIBILITY_ENSEMBLE)
			LAZYADD(ensemble, accessory.get_examine_name())
	if(length(ensemble) <= 1)
		return ..()
	return english_list(ensemble, summarize = TRUE)

/obj/item/clothing/get_examine_line()
	. = ..()
	var/list/ties
	for(var/obj/item/clothing/accessory in accessories)
		if(accessory.accessory_visibility == ACCESSORY_VISIBILITY_ATTACHMENT)
			LAZYADD(ties, "\a [accessory.get_examine_line()]")
	if(LAZYLEN(ties))
		.+= " with [english_list(ties)] attached"
	if(LAZYLEN(accessories) > LAZYLEN(ties))
		.+= ". <a href='byond://?src=\ref[src];list_ungabunga=1'>\[See accessories\]</a>"

/obj/item/clothing/examine(mob/user)
	. = ..()
	var/datum/extension/armor/ablative/armor_datum = get_extension(src, /datum/extension/armor/ablative)
	if(istype(armor_datum) && LAZYLEN(armor_datum.get_visible_damage()))
		to_chat(user, SPAN_WARNING("It has some <a href='byond://?src=\ref[src];list_armor_damage=1'>damage</a>."))

	if(LAZYLEN(accessories))
		to_chat(user, "It has the following attached: [counting_english_list(accessories)]")

	switch(ironed_state)
		if(WRINKLES_WRINKLY)
			to_chat(user, "<span class='bad'>It's wrinkly.</span>")
		if(WRINKLES_NONE)
			to_chat(user, "<span class='notice'>It's completely wrinkle-free!</span>")

	var/rags = RAG_COUNT(src)
	if(rags)
		to_chat(user, SPAN_SUBTLE("With a sharp object, you could cut \the [src] up into [rags] section\s."))

	var/obj/item/clothing/sensor/vitals/sensor = locate() in accessories
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

	if(length(clothing_state_modifiers))
		var/list/interactions = list()
		for(var/modifier_type in clothing_state_modifiers)
			var/decl/clothing_state_modifier/modifier = GET_DECL(modifier_type)
			interactions += modifier.name
		to_chat(user, SPAN_SUBTLE("Use alt-click to [english_list(interactions, and_text = " or ")]."))

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

/obj/item/clothing/get_pressure_weakness(pressure, zone)
	. = (body_parts_covered & zone) ? ..() : 1
	for(var/obj/item/clothing/accessory in accessories)
		. = min(., accessory.get_pressure_weakness(pressure,zone))

/obj/item/clothing/proc/check_limb_support(var/mob/living/human/user)
	return FALSE

/obj/item/clothing/verb/toggle_suit_sensors()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	set_sensors(usr)

/obj/item/clothing/proc/set_sensors(mob/user)
	if (isobserver(user) || user.incapacitated())
		return
	var/obj/item/clothing/sensor/vitals/sensor = locate() in accessories
	if(sensor)
		sensor.user_set_sensors(user)

/obj/item/clothing/handle_loadout_equip_replacement(obj/item/old_item)
	. = ..()
	if(!istype(old_item, /obj/item/clothing) || !(ACCESSORY_SLOT_SENSORS in valid_accessory_slots))
		return
	var/obj/item/clothing/old_clothes = old_item
	var/obj/item/clothing/sensor/vitals/sensor = locate() in old_clothes.accessories
	if(!sensor)
		return
	sensor.accessory_removable = TRUE // This will be refreshed by remove_accessory/attach_accessory
	old_clothes.remove_accessory(null, sensor)
	attach_accessory(null, sensor)

/obj/item/clothing/proc/get_hood()
	return null

/obj/item/clothing/proc/remove_hood(skip_update = FALSE)
	var/obj/item/check_hood = get_hood()
	if(!istype(check_hood) || check_hood.loc == src)
		return
	if(ismob(check_hood.loc))
		var/mob/M = check_hood.loc
		M.drop_from_inventory(check_hood)
	check_hood.forceMove(src)
	if(!skip_update)
		update_clothing_icon()

/obj/item/clothing/dropped()
	. = ..()
	remove_hood(skip_update = TRUE)
	update_icon()

/obj/item/clothing/get_alt_interactions(var/mob/user)
	. = ..()
	var/list/all_clothing_state_modifiers = list()
	for(var/obj/item/clothing/accessory in get_flat_accessory_list())
		for(var/modifier_type in accessory.clothing_state_modifiers)
			all_clothing_state_modifiers |= modifier_type
	for(var/modifier_type in all_clothing_state_modifiers)
		var/decl/clothing_state_modifier/modifier = GET_DECL(modifier_type)
		if(modifier.alt_interaction_type)
			LAZYADD(., modifier.alt_interaction_type)
	LAZYADD(., /decl/interaction_handler/clothing_set_sensors)

/decl/interaction_handler/clothing_set_sensors
	name = "Set Sensors Level"
	expected_target_type = /obj/item/clothing

/decl/interaction_handler/clothing_set_sensors/invoked(var/atom/target, var/mob/user)
	var/obj/item/clothing/U = target
	U.set_sensors(user)

