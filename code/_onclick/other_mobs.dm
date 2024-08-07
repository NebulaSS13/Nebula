// Generic damage proc (slimes and monkeys).
/atom/proc/attack_generic(mob/user)
	return 0

/atom/proc/handle_grab_interaction(var/mob/user)
	return FALSE

/atom/proc/can_interact_with_storage(user, strict = FALSE)
	return isliving(user)

/atom/proc/attack_hand(mob/user)
	SHOULD_CALL_PARENT(TRUE)

	if(can_interact_with_storage(user, strict = TRUE) && storage && user.check_dexterity((DEXTERITY_HOLD_ITEM|DEXTERITY_EQUIP_ITEM), TRUE))
		add_fingerprint(user)
		storage.open(user)
		return TRUE

	if(handle_grab_interaction(user))
		return TRUE

	if(!LAZYLEN(climbers) || (user in climbers) || !user.check_dexterity(DEXTERITY_HOLD_ITEM, silent = TRUE))
		return FALSE

	user.visible_message(
		SPAN_DANGER("\The [user] shakes \the [src]!"),
		SPAN_DANGER("You shake \the [src]!"))

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


/mob/living/human/RestrainedClickOn(var/atom/A)
	return

/mob/living/human/RangedAttack(var/atom/A, var/params)
	//Climbing up open spaces
	if(isturf(loc) && bound_overlay && !is_physically_disabled() && istype(A) && A.can_climb_from_below(src))
		return climb_up(A)

	var/obj/item/clothing/gloves/G = get_equipped_item(slot_gloves_str)
	if(istype(G) && G.Touch(A,0)) // for magic gloves
		return TRUE

	. = ..()

/atom/proc/attack_hand_ranged(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return FALSE

/mob/living/RestrainedClickOn(var/atom/A)
	return

/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/new_player/ClickOn()
	return

/*
	Animals
*/

/mob/living/simple_animal/UnarmedAttack(var/atom/A, var/proximity)

	. = ..()
	if(.)
		return

	var/attacking_with = get_natural_weapon()
	if(a_intent == I_HELP || !attacking_with)
		return A.attack_animal(src)

	a_intent = I_HURT
	. = A.attackby(attacking_with, src)
	if(!.)
		reset_offsets(anim_time = 2)
	else if(isliving(A))
		apply_attack_effects(A)

// Attack hand but for simple animals
/atom/proc/attack_animal(mob/user)
	return attack_hand_with_interaction_checks(user)

// Used to check for physical interactivity in case of nonstandard attack_hand calls.
/atom/proc/attack_hand_with_interaction_checks(var/mob/user)
	return CanPhysicallyInteract(user) && attack_hand(user)