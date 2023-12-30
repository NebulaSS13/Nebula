// Generic damage proc (slimes and monkeys).
/atom/proc/attack_generic(mob/user)
	return 0

/atom/proc/handle_grab_interaction(var/mob/user)
	return FALSE

/atom/proc/attack_hand(mob/user)
	SHOULD_CALL_PARENT(TRUE)
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

/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/human/RangedAttack(var/atom/A, var/params)
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
	Aliens
*/

/mob/living/carbon/alien/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/alien/UnarmedAttack(var/atom/A, var/proximity)

	. = ..()
	if(.)
		return

	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	return A.attack_generic(src,rand(5,6),"bites")

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

	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(isliving(A))
		if(a_intent == I_HELP || !get_natural_weapon())
			custom_emote(1,"[friendly] [A]!")
			return TRUE
		else if(ckey)
			admin_attack_log(src, A, "Has attacked its victim.", "Has been attacked by its attacker.")
			return TRUE
	if(a_intent == I_HELP)
		return A.attack_animal(src)
	else
		var/attacking_with = get_natural_weapon()
		if(attacking_with)
			return A.attackby(attacking_with, src)
	return FALSE

// Attack hand but for simple animals
/atom/proc/attack_animal(mob/user)
	return attack_hand_with_interaction_checks(user)

// Used to check for physical interactivity in case of nonstandard attack_hand calls.
/atom/proc/attack_hand_with_interaction_checks(var/mob/user)
	return CanPhysicallyInteract(user) && attack_hand(user)