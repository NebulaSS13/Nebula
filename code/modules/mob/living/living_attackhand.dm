/mob/living/attack_hand(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	. = ..() || (user && default_interaction(user))

/mob/living/proc/default_interaction(var/mob/user)

	SHOULD_CALL_PARENT(TRUE)

	var/datum/extension/hattable/hattable = get_extension(src, /datum/extension/hattable)
	if(hattable && hattable.hat)
		hattable.hat.forceMove(get_turf(src))
		user.put_in_hands(hattable.hat)
		user.visible_message(SPAN_DANGER("\The [user] removes \the [src]'s [hattable.hat]!"))
		hattable.hat = null
		update_icon()
		return TRUE

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
	return FALSE

/mob/living/proc/default_help_interaction(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if(is_asystole())
		return FALSE

	if(on_fire)
		var/mob/living/living_user = isliving(user) && user
		playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		if(living_user?.on_fire)
			user.visible_message(
				SPAN_WARNING("\The [user] tries to pat out \the [src]'s flames, but to no avail!"),
				SPAN_WARNING("You try to pat out \the [src]'s flames, but to no avail! Put yourself out first!")
			)
			return TRUE

		user.visible_message(
			SPAN_WARNING("<span class='warning'>[user] tries to pat out [src]'s flames!"),
			SPAN_WARNING("<span class='warning'>You try to pat out [src]'s flames! Hot!")
		)
		if(do_mob(user, src, 15))
			fire_stacks -= 0.5
			if(living_user)
				if(prob(10) && living_user.fire_stacks <= 0)
					living_user?.fire_stacks += 1
				living_user.IgniteMob()
				if(living_user.on_fire)
					user.visible_message(
						SPAN_DANGER("The fire spreads from [src] to [user]!"),
						SPAN_DANGER("The fire spreads to you as well!")
					)
					return TRUE
			fire_stacks -= 0.5 //Less effective than stop, drop, and roll - also accounting for the fact that it takes half as long.
			if(fire_stacks <= 0)
				user.visible_message(
					SPAN_WARNING("\The [user] successfully pats out \the [src]'s flames."),
					SPAN_WARNING("You successfully pat out \the [src]'s flames.")
				)
				ExtinguishMob()
				fire_stacks = 0
			return TRUE

	var/decl/pronouns/P = get_pronouns()
	var/obj/item/uniform = get_equipped_item(slot_w_uniform_str)
	if(uniform)
		uniform.add_fingerprint(user)

	var/show_ssd = get_species_name()
	if(show_ssd && ssd_check())
		user.visible_message(
			SPAN_NOTICE("\The [user] shakes [src] trying to wake [P.him] up!"),
			SPAN_NOTICE("You shake \the [src], but they do not respond... Maybe they have S.S.D?")
		)
	else if(lying ||HAS_STATUS(src, STAT_ASLEEP) || player_triggered_sleeping)
		player_triggered_sleeping = 0
		ADJ_STATUS(src, STAT_ASLEEP, -5)
		if(!HAS_STATUS(src, STAT_ASLEEP))
			resting = FALSE
		user.visible_message(
			SPAN_NOTICE("\The [user] shakes [src] trying to wake [P.him] up!"),
			SPAN_NOTICE("You shake \the [src] trying to wake [P.him] up!")
		)
	else
		user.attempt_hug(src)

	playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

	if(stat != DEAD)
		ADJ_STATUS(src, STAT_PARA, -3)
		ADJ_STATUS(src, STAT_STUN, -3)
		ADJ_STATUS(src, STAT_WEAK, -3)
	return TRUE

/mob/living/proc/default_disarm_interaction(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return FALSE

/mob/living/proc/default_grab_interaction(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return (scoop_check(user) && get_scooped(user, user)) || try_make_grab(user)

// This proc is where movable atoms handle being grabbed, but we handle it additionally in
// default_grab_interaction, so we override it here to return FALSE and avoid double-grabbing.
/mob/living/handle_grab_interaction(var/mob/user)
	return FALSE
