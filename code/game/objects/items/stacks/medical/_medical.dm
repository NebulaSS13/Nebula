/obj/item/stack/medical
	abstract_type = /obj/item/stack/medical
	icon = 'icons/obj/medical_kits.dmi'
	amount = 5
	max_amount = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 20

	var/heal_brute = 0
	var/heal_burn = 0
	var/animal_heal = 3

/obj/item/stack/medical/proc/get_apply_sounds()
	return

/obj/item/stack/medical/proc/play_apply_sound()
	var/list/apply_sounds = get_apply_sounds()
	if(length(apply_sounds))
		playsound(loc, pick(apply_sounds), 25)

// Returns the number of stacks to use.
/obj/item/stack/medical/proc/try_treat_limb(mob/living/target, mob/living/user, obj/item/organ/external/affecting)
	return 0

/obj/item/stack/medical/proc/check_limb_state(var/mob/user, var/obj/item/organ/external/limb)
	. = FALSE
	if(BP_IS_CRYSTAL(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat a crystalline limb."))
	else if(BP_IS_PROSTHETIC(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat a prosthetic limb."))
	else
		. = TRUE

/obj/item/stack/medical/proc/limb_is_injured(obj/item/organ/external/affecting)
	return length(affecting.wounds) > 0

/obj/item/stack/medical/proc/get_covering_clothing(mob/living/target, obj/item/organ/external/affecting)
	// For perfect coverage checks; generally considered too restrictive but left for reference.
	// return target.get_covering_equipped_item(affecting.body_part)
	// More limited coverage checking:
	var/static/list/check_slots = list(
		slot_wear_suit_str,
		slot_head_str,
		slot_wear_mask_str
	)
	for(var/check_slot in check_slots)
		var/obj/item/checking = target.get_equipped_item(check_slot)
		if(checking && (checking.body_parts_covered & affecting.body_part))
			return checking

/obj/item/stack/medical/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if(!user.can_wield_item(src) || user.a_intent == I_HURT)
		return ..()

	if(get_amount() < 1)
		to_chat(user, SPAN_WARNING("You need at least 1 [singular_name] to treat injuries."))
		return TRUE

	// If they have organs, we try to treat a specific organ being targeted.
	if(length(target.get_organs()))

		var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(target, user.get_target_zone())
		if(!affecting)
			to_chat(user, SPAN_WARNING("\The [target] is missing that body part!"))
			return TRUE

		if(!limb_is_injured(affecting))
			to_chat(user, SPAN_WARNING("\The [target]'s [affecting.name] has no wounds to treat."))
			return FALSE

		if(!check_limb_state(user, affecting))
			return TRUE


		var/obj/item/covering = get_covering_clothing(target, affecting)
		if(covering)
			to_chat(user, SPAN_WARNING("You can't apply \the [src] through \the [covering]!"))
			return TRUE

		var/use_stacks = try_treat_limb(target, user, affecting)
		if(use_stacks)
			use(use_stacks)
		return TRUE

	// Simpler mobs just use general damage handlers.
	if(!target.getBruteLoss() && !target.getFireLoss())
		to_chat(user, SPAN_WARNING("\The [target] has no injuries to treat."))
		return TRUE

	if(target.isSynthetic())
		to_chat(user, SPAN_WARNING("\The [target] is synthetic and cannot be treated with \the [src]."))
		return TRUE

	target.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
	user.visible_message(
		SPAN_NOTICE("\The [user] treats \the [target] with \the [src]."),
		SPAN_NOTICE("You treat \the [target] with \the [src].")
	)
	play_apply_sound()
	use(1)
	return TRUE
