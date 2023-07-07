/obj/item/clothing
	name = "clothing"
	siemens_coefficient = 0.9
	origin_tech = "{'materials':1,'engineering':1}"
	material = /decl/material/solid/cloth

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
	var/smell_state = SMELL_DEFAULT
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
#define RAG_COUNT(X) CEILING((LAZYACCESS(X.matter, /decl/material/solid/cloth) * 0.65) / SHEET_MATERIAL_AMOUNT)

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
			LAZYREMOVE(matter, /decl/material/solid/cloth)
			physically_destroyed()
		return TRUE
	. = ..()
// End placeholder.

// Updates the vision of the mob wearing the clothing item, if any
/obj/item/clothing/proc/update_vision()
	if(isliving(src.loc))
		var/mob/living/L = src.loc
		L.handle_vision()

// Checked when equipped, returns true when the wearing mob's vision should be updated
/obj/item/clothing/proc/needs_vision_update()
	return flash_protection || tint

/obj/item/clothing/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)

	if(overlay)

		if(length(accessories))
			for(var/obj/item/clothing/accessory/A in accessories)
				if(A.should_overlay())
					overlay.overlays += A.get_mob_overlay(user_mob, slot)

		if(markings_icon && markings_color && check_state_in_icon("[overlay.icon_state][markings_icon]", overlay.icon))
			overlay.overlays += mutable_appearance(overlay.icon, "[overlay.icon_state][markings_icon]", markings_color)

		if(!(slot in user_mob?.get_held_item_slots()))
			if(ishuman(user_mob))
				var/mob/living/carbon/human/user_human = user_mob
				if(blood_DNA)
					var/mob_blood_overlay = user_human.bodytype.get_blood_overlays(user_human)
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

/obj/item/clothing/proc/change_smell(smell = SMELL_DEFAULT)
	smell_state = smell

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

/obj/item/clothing/mob_can_equip(mob/living/M, slot, disable_warning = FALSE, force = FALSE, ignore_equipped = FALSE)
	. = ..()
	if(. && !isnull(bodytype_equip_flags) && ishuman(M) && !(slot in list(slot_l_store_str, slot_r_store_str, slot_s_store_str)) && !(slot in M.get_held_item_slots()))
		var/mob/living/carbon/human/H = M
		. = (bodytype_equip_flags & BODY_FLAG_EXCLUDE) ? !(bodytype_equip_flags & H.bodytype.bodytype_flag) : (bodytype_equip_flags & H.bodytype.bodytype_flag)
		if(!. && !disable_warning)
			to_chat(H, SPAN_WARNING("\The [src] [gender == PLURAL ? "do" : "does"] not fit you."))

/obj/item/clothing/equipped(var/mob/user)
	if(needs_vision_update())
		update_vision()
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

	switch(smell_state)
		if(SMELL_CLEAN)
			to_chat(user, "<span class='notice'>It smells clean!</span>")
		if(SMELL_STINKY)
			to_chat(user, "<span class='bad'>It's quite stinky!</span>")

	var/rags = RAG_COUNT(src)
	if(rags)
		to_chat(user, SPAN_SUBTLE("With a sharp object, you could cut \the [src] up into [rags] rag\s."))

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
