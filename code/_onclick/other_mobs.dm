// Generic damage proc (slimes and monkeys).
/atom/proc/attack_generic(mob/user)
	return 0

/atom/proc/handle_grab_interaction(var/mob/user)
	return FALSE

/atom/proc/can_interact_with_storage(user, strict = FALSE)
	return isliving(user)

/atom/proc/get_required_interaction_dexterity()
	return DEXTERITY_NONE

/atom/proc/attack_hand(mob/user)
	SHOULD_CALL_PARENT(TRUE)

	if(!user.check_dexterity(get_required_interaction_dexterity(), silent = TRUE))
		return FALSE

	if(can_interact_with_storage(user, strict = TRUE) && storage && user.check_dexterity((DEXTERITY_HOLD_ITEM|DEXTERITY_EQUIP_ITEM), TRUE))
		add_fingerprint(user)
		storage.open(user)
		return TRUE

	if(handle_grab_interaction(user))
		return TRUE

	if(try_handle_interactions(user, get_standard_interactions(user), user?.get_active_held_item(), check_alt_interactions = FALSE))
		return TRUE

	if(!LAZYLEN(climbers) || (user in climbers) || !user.check_dexterity(DEXTERITY_HOLD_ITEM, silent = TRUE))
		return FALSE

	user.visible_message(
		SPAN_DANGER("\The [user] shakes \the [src]!"),
		SPAN_DANGER("You shake \the [src]!")
	)

	object_shaken()
	return TRUE

/mob/proc/attack_empty_hand()
	return

/mob/living/attack_empty_hand()
	// Handle any prepared ability/spell/power invocations.
	var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
	if(abilities?.do_self_invocation())
		return TRUE
	return FALSE

/mob/living/human/RangedAttack(var/atom/A, var/params)
	//Climbing up open spaces
	if(isturf(loc) && bound_overlay && !is_physically_disabled() && istype(A) && A.can_climb_from_below(src))
		return climb_up(A)

	var/obj/item/clothing/gloves/G = get_equipped_item(slot_gloves_str)
	if(istype(G) && G.Touch(A, FALSE)) // for magic gloves
		return TRUE

	. = ..()

/atom/proc/attack_hand_ranged(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return FALSE

/mob/living/RestrainedClickOn(var/atom/A)
	if (A != src)
		return ..()
	if(world.time < next_restraint_chew || !get_equipped_item(slot_handcuffed_str) || !check_intent(I_FLAG_HARM) || get_target_zone() != BP_MOUTH)
		return FALSE
	// Cannot chew with a mask or a full body restraint.
	if (get_equipped_item(slot_wear_mask_str) || istype(get_equipped_item(slot_wear_suit_str), /obj/item/clothing/suit/straight_jacket))
		return FALSE
	// Type to hand so drakes don't chew off their own head.
	var/obj/item/organ/external/hand/O = GET_EXTERNAL_ORGAN(src, get_active_held_item_slot())
	if(!istype(O))
		return FALSE
	var/decl/pronouns/pronouns = get_pronouns()
	visible_message(
		SPAN_DANGER("\The [src] chews on [pronouns.his] [O.name]"),
		SPAN_DANGER("You chew on your [O.name]!")
	)
	admin_attacker_log(src, "chewed on their [O.name]!")
	O.take_damage(3, damage_flags = (DAM_SHARP|DAM_EDGE), inflicter = "teeth marks")
	next_restraint_chew = world.time + (2.5 SECONDS)
	return TRUE

/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/new_player/ClickOn()
	return

/*
	Animals
*/
/// Make unarmed attacks use natural weapons on harm intent.
/mob/living/simple_animal/ResolveUnarmedAttack(atom/A)
	var/attacking_with = get_natural_weapon()
	if(check_intent(I_FLAG_HELP) || !attacking_with)
		return A.attack_animal(src)

	set_intent(I_FLAG_HARM)
	. = A.attackby(attacking_with, src)
	// attack effects are handled in natural_weapon's apply_hit_effect() instead of here
	if(!.)
		reset_offsets(anim_time = 2)

// Attack hand but for simple animals
/atom/proc/attack_animal(mob/user)
	return attack_hand_with_interaction_checks(user)

// Used to check for physical interactivity in case of nonstandard attack_hand calls.
/atom/proc/attack_hand_with_interaction_checks(var/mob/user)
	return CanPhysicallyInteract(user) && attack_hand(user)