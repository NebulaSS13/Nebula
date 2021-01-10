/obj/item/clothing
	name = "clothing"
	siemens_coefficient = 0.9

	var/wizard_garb = 0
	var/flash_protection = FLASH_PROTECTION_NONE	  // Sets the item's level of flash protection.
	var/tint = TINT_NONE							  // Sets the item's level of visual impairment tint.
	var/list/bodytype_restricted = list(BODYTYPE_HUMANOID)
	var/list/accessories = list()
	var/list/valid_accessory_slots
	var/list/restricted_accessory_slots
	var/list/starting_accessories
	var/blood_overlay_type = "uniformblood"
	var/visible_name = "Unknown"
	var/ironed_state = WRINKLES_DEFAULT
	var/smell_state = SMELL_DEFAULT
	var/move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints // if this item covers the feet, the footprints it should leave
	var/made_of_cloth = FALSE
	var/volume_multiplier = 1
	var/markings_icon	// simple colored overlay that would be applied to the icon
	var/markings_color	// for things like colored parts of labcoats or shoes

/obj/item/clothing/Initialize()
	. = ..()
	if(markings_icon && markings_color)
		update_icon()

// Sort of a placeholder for proper tailoring.
/obj/item/clothing/attackby(obj/item/I, mob/user)
	if(made_of_cloth && (I.edge || I.sharp) && user.a_intent == I_HURT)
		if(!isturf(loc) && !(src in user.get_held_items()))
			var/it = gender == PLURAL ? "them" : "it"
			to_chat(user, SPAN_WARNING("You must either be holding \the [src], or [it] must be on the ground, before you can shred [it]."))
			return
		user.visible_message(SPAN_DANGER("\The [user] begins tearing up \the [src] with \the [I]."))
		if(do_after(user, 5 SECONDS, src))
			user.visible_message(SPAN_DANGER("\The [user] tears \the [src] into rags with \the [I]."))
			for(var/i = 1 to rand(2,3))
				new /obj/item/chems/glass/rag(get_turf(src))
			if(loc == user)
				user.drop_from_inventory(src)
			qdel(src)
		return
	. = ..()
// End placeholder.

// Updates the icons of the mob wearing the clothing item, if any.
/obj/item/clothing/proc/update_clothing_icon()
	return

// Updates the vision of the mob wearing the clothing item, if any
/obj/item/clothing/proc/update_vision()
	if(isliving(src.loc))
		var/mob/living/L = src.loc
		L.handle_vision()

// Checked when equipped, returns true when the wearing mob's vision should be updated
/obj/item/clothing/proc/needs_vision_update()
	return flash_protection || tint

/obj/item/clothing/get_mob_overlay(mob/living/user_mob, slot, bodypart)
	var/image/ret = ..()

	if(slot in user_mob?.held_item_slots)
		return ret

	if(ishuman(user_mob))
		var/mob/living/carbon/human/user_human = user_mob
		if(blood_DNA && user_human.species.blood_mask)
			var/image/bloodsies = overlay_image(user_human.species.blood_mask, blood_overlay_type, blood_color, RESET_COLOR)
			bloodsies.appearance_flags |= NO_CLIENT_COLOR
			ret.overlays	+= bloodsies

	if(length(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			ret.overlays += A.get_mob_overlay(user_mob, slot)

	if(markings_icon && markings_color)
		ret.overlays += mutable_appearance(ret.icon, markings_icon, markings_color)
	return ret

/obj/item/clothing/apply_overlays(var/mob/user_mob, var/bodytype, var/image/overlay, var/slot)
	var/image/ret = ..()
	if(length(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			ret.overlays += A.get_mob_overlay(user_mob, slot)

	if(markings_icon && markings_color && check_state_in_icon("[ret.icon_state][markings_icon]", ret.icon))
		ret.overlays += mutable_appearance(ret.icon, "[ret.icon_state][markings_icon]", markings_color)
	
	return ret

/obj/item/clothing/on_update_icon()
	..()
	if(markings_icon && markings_color)
		overlays += mutable_appearance(icon, "[get_world_inventory_state()][markings_icon]", markings_color)
		
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

/obj/item/clothing/mob_can_equip(mob/living/M, slot, disable_warning = 0)
	. = ..()
	if(. && length(bodytype_restricted) && ishuman(M) && !(slot in list(slot_l_store_str, slot_r_store_str, slot_s_store_str)) && !(slot in M.held_item_slots))
		var/mob/living/carbon/human/H = M
		. = ("exclude" in bodytype_restricted) ? !(H.species.get_bodytype(H) in bodytype_restricted) : (H.species.get_bodytype(H) in bodytype_restricted)
		if(!. && !disable_warning)
			to_chat(H, SPAN_WARNING("\The [src] [gender == PLURAL ? "do" : "does"] not fit you."))

/obj/item/clothing/equipped(var/mob/user)
	if(needs_vision_update())
		update_vision()
	return ..()

/obj/item/clothing/proc/refit_for_bodytype(var/target_bodytype)
	if(!bodytype_restricted)
		return
	bodytype_restricted = list(target_bodytype)
	if(!use_single_icon)
		if (sprite_sheets_obj && (target_bodytype in sprite_sheets_obj))
			icon = sprite_sheets_obj[target_bodytype]
		else
			icon = initial(icon)

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

/obj/item/clothing/Topic(href, href_list, datum/topic_state/state)
	var/mob/user = usr
	if(istype(user))
		var/turf/T = get_turf(src)
		var/can_see = T.CanUseTopic(user, GLOB.view_state) != STATUS_CLOSE
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
