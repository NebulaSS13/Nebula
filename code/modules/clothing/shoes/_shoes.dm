/obj/item/clothing/shoes
	name = "shoes"
	desc = "Comfortable-looking shoes."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/feet/generic_shoes.dmi'
	gender = PLURAL
	siemens_coefficient = 0.9
	cold_protection = SLOT_FEET
	body_parts_covered = SLOT_FEET
	heat_protection = SLOT_FEET
	slot_flags = SLOT_FEET
	permeability_coefficient = 0.50
	force = 2
	blood_overlay_type = "shoeblood"
	material = /decl/material/solid/leather
	origin_tech = "{'materials':1,'engineering':1}"

	var/can_fit_under_magboots = TRUE
	var/can_add_cuffs = TRUE
	var/obj/item/handcuffs/attached_cuffs = null
	var/can_add_hidden_item = TRUE
	var/hidden_item_max_w_class = ITEM_SIZE_SMALL
	var/obj/item/hidden_item = null
	var/shine = -1 // if material should apply shine overlay. Set to -1 for it to not do that

/obj/item/clothing/shoes/Destroy()
	. = ..()
	if (hidden_item)
		QDEL_NULL(hidden_item)
	if (attached_cuffs)
		QDEL_NULL(attached_cuffs)

/obj/item/clothing/shoes/examine(mob/user)
	. = ..()
	if (attached_cuffs)
		to_chat(user, SPAN_WARNING("They are connected by \the [attached_cuffs]."))
	if (hidden_item)
		if (loc == user)
			to_chat(user, SPAN_ITALIC("\An [hidden_item] is inside."))
		else if (get_dist(src, user) == 1)
			to_chat(user, SPAN_ITALIC("Something is hidden inside."))

/obj/item/clothing/shoes/attack_hand(var/mob/user)
	if (remove_hidden(user))
		return
	..()

/obj/item/clothing/shoes/attack_self(var/mob/user)
	remove_cuffs(user)
	..()

/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	if (istype(I, /obj/item/handcuffs))
		add_cuffs(I, user)
		return TRUE
	. = add_hidden(I, user)
	if(!.)
		. = ..()

/obj/item/clothing/shoes/proc/add_cuffs(var/obj/item/handcuffs/cuffs, var/mob/user)
	if(!can_add_cuffs)
		if(user)
			to_chat(user, SPAN_WARNING("\The [cuffs] can't be attached to \the [src]."))
		return
	if(attached_cuffs)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] already has [attached_cuffs] attached."))
		return
	if(user)
		if(!user.do_skilled(5 SECONDS, SKILL_COMBAT, src) || (QDELETED(cuffs) || QDELETED(src)))
			return
		if(!user.unEquip(cuffs, src))
			return
		user.visible_message(SPAN_ITALIC("\The [user] attaches \the [cuffs] to \the [src]."), range = 2)
	else
		cuffs.forceMove(src)

	attached_cuffs = cuffs
	if(cuffs)
		LAZYINITLIST(slowdown_per_slot[slot_shoes_str])
		verbs |= /obj/item/clothing/shoes/proc/remove_cuffs
		slowdown_per_slot[slot_shoes_str] += attached_cuffs.elastic ? 10 : 15
	return TRUE

/obj/item/clothing/shoes/proc/remove_cuffs(var/mob/user)
	if(!attached_cuffs)
		return
	if(user)
		if(!user.do_skilled(5 SECONDS, SKILL_COMBAT, src) && (QDELETED(src) || QDELETED(attached_cuffs)))
			return FALSE
		user.put_in_hands(attached_cuffs)
		user.visible_message(SPAN_ITALIC("\The [user] removes \the [attached_cuffs] from \the [src]."), range = 2)
		attached_cuffs.add_fingerprint(user)
	else
		attached_cuffs.dropInto(loc)

	verbs -= /obj/item/clothing/shoes/proc/remove_cuffs
	if(slowdown_per_slot[slot_shoes_str])
		slowdown_per_slot[slot_shoes_str] -= attached_cuffs.elastic ? 10 : 15
	attached_cuffs = null

/obj/item/clothing/shoes/proc/add_hidden(var/obj/item/I, var/mob/user)
	if (!(I.item_flags & ITEM_FLAG_CAN_HIDE_IN_SHOES)) // fail silently
		return FALSE
	if (!can_add_hidden_item)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] can't hold anything."))
		return FALSE
	if (hidden_item)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] already holds \an [hidden_item]."))
		return FALSE
	if (I.w_class > hidden_item_max_w_class)
		if(user)
			to_chat(user, SPAN_WARNING("\The [I] is too large to fit in the [src]."))
		return FALSE

	if(user)
		if(!do_after(user, 1 SECONDS) || (QDELETED(src) || QDELETED(hidden_item)))
			return FALSE
		if(!user.unEquip(I, src))
			return FALSE
		user.visible_message(SPAN_ITALIC("\The [user] shoves \the [I] into \the [src]."), range = 1)
	else
		I.forceMove(src)

	verbs |= /obj/item/clothing/shoes/proc/remove_hidden
	hidden_item = I
	return TRUE

/obj/item/clothing/shoes/proc/remove_hidden(var/mob/user)
	if(!hidden_item)
		return FALSE
	
	if(user)
		if(user.incapacitated())
			return FALSE
		if(loc != user)
			return FALSE
		if(!do_after(user, 2 SECONDS) || (QDELETED(src) || QDELETED(hidden_item)))
			return FALSE
		user.put_in_hands(hidden_item)
		user.visible_message(SPAN_ITALIC("\The [user] pulls \the [hidden_item] from \the [src]."), range = 1)
	else
		hidden_item.dropInto(loc)

	playsound(get_turf(src), 'sound/effects/holster/tactiholsterout.ogg', 25)
	verbs -= /obj/item/clothing/shoes/proc/remove_hidden
	hidden_item = null
	return TRUE

/obj/item/clothing/shoes/proc/handle_movement(var/turf/walking, var/running)
	if (attached_cuffs && running)
		attached_cuffs.take_damage(1, armor_pen = 100)
	return

/obj/item/clothing/shoes/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_shoes()

/obj/item/clothing/shoes/set_material(var/new_material)
	..()
	if(shine != -1 && material.reflectiveness >= MAT_VALUE_DULL)
		shine = material.reflectiveness

/obj/item/clothing/shoes/on_update_icon()
	. = ..()
	if(shine > 0 && check_state_in_icon("[icon_state]_shine", icon))
		var/mutable_appearance/S = mutable_appearance(icon, "[icon_state]_shine")
		S.alpha = 127 * shine / 100
		S.blend_mode = BLEND_ADD
		add_overlay(S)

/obj/item/clothing/shoes/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && shine > 0 && slot == slot_shoes_str)
		var/mutable_appearance/S = mutable_appearance(overlay.icon, "shine")
		S.alpha = 127 * shine / 100
		S.blend_mode = BLEND_ADD
		overlay.overlays += S
	. = ..()

// Interactions
/obj/item/clothing/shoes/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/remove_cuffs/shoes)
	LAZYADD(., /decl/interaction_handler/remove_item/shoes)

//Remove Shoe Cuffs
/decl/interaction_handler/remove_cuffs/shoes
	name = "Remove Shoe Handcuffs"
	expected_target_type = /obj/item/clothing/shoes

/decl/interaction_handler/remove_cuffs/shoes/is_possible(obj/item/clothing/shoes/target, mob/user, obj/item/prop)
	return ..() && target.attached_cuffs

/decl/interaction_handler/remove_cuffs/shoes/invoked(obj/item/clothing/shoes/target, mob/user)
	target.remove_cuffs(user)
	return TRUE

//Remove Hidden Item
/decl/interaction_handler/remove_item/shoes
	name = "Remove Shoe Item"
	expected_target_type = /obj/item/clothing/shoes

/decl/interaction_handler/remove_item/shoes/is_possible(obj/item/clothing/shoes/target, mob/user, obj/item/prop)
	return ..() && target.hidden_item

/decl/interaction_handler/remove_item/shoes/invoked(obj/item/clothing/shoes/target, mob/user)
	target.remove_hidden(user)
	return TRUE