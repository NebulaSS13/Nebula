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

	setClickCooldown(attack_delay)
	var/attacking_with = get_natural_weapon()
	if(a_intent == I_HELP || !attacking_with)
		return A.attack_animal(src)

	var/decl/pronouns/G = get_pronouns()
	face_atom(A)
	if(attack_delay)
		stop_automove() // Cancel any baked-in movement.
		do_windup_animation(A, attack_delay, no_reset = TRUE)
		if(!do_after(src, attack_delay, A) || !Adjacent(A))
			visible_message(SPAN_NOTICE("\The [src] misses [G.his] attack on \the [A]!"))
			animate(src, pixel_x = default_pixel_x, pixel_y = default_pixel_y, time = 2) // reset wherever the attack animation got us to.
			MoveToTarget(TRUE) // Restart hostile mob tracking.
			return TRUE
		MoveToTarget(TRUE) // Restart hostile mob tracking.

	if(ismob(A)) // Clientless mobs are too dum to move away, so they can be missed.
		var/mob/mob = A
		if(!mob.ckey && !prob(get_melee_accuracy()))
			visible_message(SPAN_NOTICE("\The [src] misses [G.his] attack on \the [A]!"))
			return TRUE

	return A.attackby(attacking_with, src)

// Attack hand but for simple animals
/atom/proc/attack_animal(mob/user)
	return attack_hand_with_interaction_checks(user)

// Used to check for physical interactivity in case of nonstandard attack_hand calls.
/atom/proc/attack_hand_with_interaction_checks(var/mob/user)
	return CanPhysicallyInteract(user) && attack_hand(user)