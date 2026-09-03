/datum/mob_controller/aggressive/giant_spider/tunneller/move_to_target(var/move_only = FALSE)
	if(body.can_act() && body.perform_maneuver(/decl/maneuver/tunnel, get_target()))
		return
	. = ..()

/decl/maneuver/tunnel
	name = "tunnel"
	stamina_cost = 10
	reflexive_modifier = 1.5
	selection_icon_state = "leap"
	cooldown = 10 SECONDS
	var/tunnel_min_range  = 2
	var/tunnel_max_range  = 6
	var/tunnel_warning    = 0.5 SECONDS	// How long the dig telegraphing is.
	var/tunnel_tile_speed = 2			// How long to wait between each tile. Higher numbers result in an easier to dodge tunnel attack.

/decl/maneuver/tunnel/perform(var/mob/living/user, var/atom/target, var/strength, var/reflexively = FALSE)
	if(!(. = ..()) || !target)
		return

	user.do_windup_animation(target, windup_time = tunnel_warning)
	sleep(tunnel_warning)

	user.visible_message(SPAN_DANGER("\The [user] tunnels towards \the [target]!"))

	var/turf/target_turf = get_turf(target)
	var/turf/current_turf = get_turf(user)
	var/turf/origin_turf = current_turf

	user.forceMove(null)
	new /obj/effect/temporary/tunneller_hole(origin_turf, 1 MINUTE, 'icons/effects/effects.dmi', "tunnel_hole")

	var/overshot = FALSE
	var/hit_target
	for(var/i = 0 to tunnel_max_range)

		var/turf/next_turf
		if(overshot)
			next_turf = get_step(current_turf, get_dir(origin_turf, target_turf))
		else
			next_turf = get_step(current_turf, get_dir(current_turf, target_turf))
			if(next_turf && next_turf == get_turf(target_turf))
				if(locate(target) in target_turf)
					user.visible_message(SPAN_DANGER("\The [src] erupts from underneath and cannons into \the [target]!"))
					user.forceMove(next_turf)
					playsound(next_turf, 'sound/weapons/heavysmash.ogg', 75, 1)
					if(isliving(target))
						var/mob/victim = target
						SET_STATUS_MAX(victim, STAT_WEAK, 3)
					hit_target = TRUE
					break

				overshot = TRUE
				to_chat(user, SPAN_WARNING("You overshoot your target!"))
				playsound(user, 'sound/weapons/punchmiss.ogg', 75, 1)

		if(!next_turf)
			break

		var/atom/bonked = turf_contains_dense_objects(next_turf)
		if(bonked && bonked != target)
			user.visible_message(SPAN_DANGER("\The [user] collides with \the [bonked]!"))
			playsound(user, 'sound/weapons/heavysmash.ogg', 75, 1)
			SET_STATUS_MAX(user, STAT_WEAK, 3)
			break

		current_turf = next_turf
		current_turf.drop_diggable_resources(user)
		playsound(current_turf, 'sound/effects/break_stone.ogg', 75, 1)
		sleep(tunnel_tile_speed)

	if(!hit_target)
		user.forceMove(current_turf)

	if(user.loc == null)
		user.forceMove(origin_turf)

	var/turf/final_turf = get_turf(user)
	if(istype(final_turf) && !(locate(/obj/effect/temporary/tunneller_hole) in final_turf))
		new /obj/effect/temporary/tunneller_hole(origin_turf, 1 MINUTE, 'icons/effects/effects.dmi', "tunnel_hole")

/decl/maneuver/tunnel/show_initial_message(var/mob/living/user, var/atom/target)
	user.visible_message(SPAN_DANGER("\The [user] begins digging with its pedipalps..."))

/decl/maneuver/tunnel/can_be_used_by(var/mob/living/user, var/atom/target, var/silent = FALSE)
	. = ..() && target
	if(.)
		var/dist = get_dist(user, target)
		. = (dist >= tunnel_min_range && dist <= tunnel_max_range)
	if(!. && !silent)
		to_chat(user, SPAN_WARNING("You cannot tunnel to that point!"))

/obj/effect/temporary/tunneller_hole
	name = "hole"
	desc = "A collapsing tunnel hole."
	layer = TURF_DETAIL_LAYER
	plane = DEFAULT_PLANE
