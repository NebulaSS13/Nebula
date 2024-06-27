/decl/maneuver/leap
	name = "leap"
	stamina_cost = 10
	reflexive_modifier = 1.5
	selection_icon_state = "leap"

/decl/maneuver/leap/perform(var/mob/living/user, var/atom/target, var/strength, var/reflexively = FALSE)
	. = ..()
	if(.)
		var/old_pass_flags = user.pass_flags
		user.pass_flags |= PASS_FLAG_TABLE
		user.visible_message(SPAN_DANGER("\The [user] takes a flying leap!"))
		strength = max(2, strength * user.get_jump_distance())
		if(reflexively)
			strength *= reflexive_modifier
		user.jump_layer_shift()
		animate(user, pixel_z = 16, time = 3, easing = SINE_EASING | EASE_IN)
		animate(pixel_z = user.default_pixel_z, time = 3, easing = SINE_EASING | EASE_OUT)
		user.throw_at(get_turf(target), strength, 1, user, FALSE, CALLBACK(src, TYPE_PROC_REF(/decl/maneuver/leap, end_leap), user, target, old_pass_flags))
		addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, jump_layer_shift_end)), 4.5)

/decl/maneuver/leap/proc/end_leap(var/mob/living/user, var/atom/target, var/pass_flag)
	user.pass_flags = pass_flag

/decl/maneuver/leap/show_initial_message(var/mob/living/user, var/atom/target)
	user.visible_message(SPAN_WARNING("\The [user] crouches, preparing for a leap!"))

/decl/maneuver/leap/can_be_used_by(var/mob/living/user, var/atom/target, var/silent = FALSE)
	. = ..()
	if(.)
		var/can_leap_distance = user.get_jump_distance() * user.get_acrobatics_multiplier()
		. = (can_leap_distance > 0 && (!target || get_dist(user, target) <= can_leap_distance))
		if(!. && !silent)
			to_chat(user, SPAN_WARNING("You cannot leap that far!"))

/decl/maneuver/leap/spider
	stamina_cost = 0

/decl/maneuver/leap/spider/show_initial_message(var/mob/living/user, var/atom/target)
	user.visible_message(SPAN_WARNING("\The [user] reels back and prepares to launch itself at \the [target]!"))

/decl/maneuver/leap/grab/end_leap(var/mob/living/user, var/atom/target)
	. = ..()
	if(!user.current_posture.prone && ismob(target) && user.Adjacent(target) && istype(target, /atom/movable))
		var/atom/movable/AM = target
		AM.try_make_grab(user)
