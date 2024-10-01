/mob/living/attack_hand(mob/user)
	// Allow grabbing a mob that you are buckled to, so that you can generate a control grab (for riding).
	if(buckled == user && user.a_intent == I_GRAB)
		return try_make_grab(user)
	return ..() || (user && default_interaction(user))

/mob/living/proc/default_interaction(var/mob/user)

	SHOULD_CALL_PARENT(TRUE)

	switch(user.a_intent)
		if(I_HURT)
			. = default_hurt_interaction(user)
		if(I_HELP)
			. = default_help_interaction(user)
		if(I_DISARM)
			. = default_disarm_interaction(user)
		if(I_GRAB)
			. = default_grab_interaction(user)

/mob/living/proc/default_hurt_interaction(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	// TODO: integrate/generalize this ugly code instead of using boilerplate from
	// simple_animal/UnarmedAttack() due to complexities with existing proc flow.
	if(isanimal(user))
		var/mob/living/simple_animal/predator = user
		var/obj/item/attacking_with = predator.get_natural_weapon()
		if(attacking_with)
			attackby(attacking_with, predator)
		else
			attack_animal(predator)
		return TRUE
	return FALSE

/mob/living/proc/default_help_interaction(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if(try_extinguish(user))
		return TRUE
	if(try_awaken(user))
		return TRUE
	return FALSE

/mob/living/proc/default_disarm_interaction(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return FALSE

/mob/living/proc/default_grab_interaction(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return scoop_check(user) ? get_scooped(user, user) : try_make_grab(user)

// This proc is where movable atoms handle being grabbed, but we handle it additionally in
// default_grab_interaction, so we override it here to return FALSE and avoid double-grabbing.
/mob/living/handle_grab_interaction(var/mob/user)
	return FALSE

// Returns TRUE if further interactions should be halted, FALSE otherwise.
/mob/living/proc/try_extinguish(mob/living/user)
	if (!on_fire || !istype(user))
		return FALSE

	playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	if (user.on_fire)
		user.visible_message(
			SPAN_WARNING("\The [user] tries to pat out \the [src]'s flames, but to no avail!"),
			SPAN_WARNING("You try to pat out [src]'s flames, but to no avail! Put yourself out first!")
		)
		return TRUE

	user.visible_message(
		SPAN_WARNING("\The [user] tries to pat out \the [src]'s flames!"),
		SPAN_WARNING("You try to pat out \the [src]'s flames! Hot!")
	)

	if(!do_mob(user, src, 15))
		return TRUE

	fire_stacks -= 0.5
	if (prob(10) && (user.fire_stacks <= 0))
		user.fire_stacks += 1
	user.IgniteMob()
	if (user.on_fire)
		user.visible_message(
			SPAN_DANGER("The fire spreads from \the [src] to \the [user]!"),
			SPAN_DANGER("The fire spreads to you as well!")
		)
		return TRUE

	fire_stacks -= 0.5 //Less effective than stop, drop, and roll - also accounting for the fact that it takes half as long.
	if (fire_stacks <= 0)
		user.visible_message(
			SPAN_NOTICE("\The [user] successfully pats out \the [src]'s flames."),
			SPAN_NOTICE("You successfully pat out \the [src]'s flames.")
		)
		ExtinguishMob()
		fire_stacks = 0

	return TRUE

// Returns TRUE if further interactions should be halted, FALSE otherwise.
/mob/living/proc/try_awaken(mob/user)

	var/decl/pronouns/pronouns = get_pronouns()
	var/obj/item/uniform = get_equipped_item(slot_w_uniform_str)
	if(uniform)
		uniform.add_fingerprint(user)

	// They're SSD, so permanently asleep.
	var/show_ssd = get_species_name()
	if(show_ssd && ssd_check())
		user.visible_message(
			SPAN_NOTICE("\The [user] shakes \the [src] trying to wake [pronouns.him] up!"),
			SPAN_NOTICE("You shake \the [src], but they do not respond...")
		)
		playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		. = TRUE

	// Not SSD, so try to wake them up.
	else if(current_posture?.prone || HAS_STATUS(src, STAT_ASLEEP) || player_triggered_sleeping)
		player_triggered_sleeping = FALSE
		ADJ_STATUS(src, STAT_ASLEEP, -5)
		if(!HAS_STATUS(src, STAT_ASLEEP))
			set_posture(/decl/posture/lying) // overrides 'delibrate' lying so you will stand up if possible.
		user.visible_message(
			SPAN_NOTICE("\The [user] shakes \the [src] trying to wake [pronouns.him] up!"),
			SPAN_NOTICE("You shake \the [src] trying to wake [pronouns.him] up!")
		)
		. = TRUE

	if(.)
		playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		if(stat != DEAD)
			ADJ_STATUS(src, STAT_PARA, -3)
			ADJ_STATUS(src, STAT_STUN, -3)
			ADJ_STATUS(src, STAT_WEAK, -3)
		return

	// Fallback.
	return user.attempt_hug(src)
