/decl/maneuver/teleport
	name = "Teleport"
	stamina_cost = 0
	selection_icon_state = "smoke" // close enough
	/// How far away to be at most after we teleport.
	var/teleport_distance = 7
	/// How far we can teleport. Don't teleport from further than the default view.
	var/max_teleport_range = 7
	/// What style to use for our arrival text.
	var/teleport_style = "notice"

/decl/maneuver/teleport/show_initial_message(var/mob/user, var/atom/target)
	user?.visible_message(SPAN_NOTICE("\The [user] begins to blur at the edges..."))

/decl/maneuver/teleport/can_be_used_by(mob/living/user, atom/target, silent)
	if((. = ..()) && get_dist(user, target) > max_teleport_range)
		to_chat(user, SPAN_WARNING("You are too far away!"))
		return FALSE

/decl/maneuver/teleport/perform(mob/living/user, atom/target, strength, reflexively)

	var/list/things_seen = view(max_teleport_range, user)
	var/list/potential_turfs = list()
	for(var/turf/potential_turf in RANGE_TURFS(target, teleport_distance))
		if((potential_turf in things_seen) && !turf_contains_dense_objects(potential_turf))
			potential_turfs += potential_turf

	if(!length(potential_turfs))
		to_chat(user, SPAN_WARNING("There's nowhere to teleport to near \the [target]!"))
		return FALSE

	. = ..()
	if(!.)
		return

	var/turf/target_turf = pick(potential_turfs)
	spark_at(get_turf(user))
	user.forceMove(target_turf)
	user.visible_message(SPAN_STYLE(teleport_style, "\The [user] appears in a flare of eye-twisting light!"))
	playsound(target_turf, 'sound/effects/phasein.ogg', 50, 1)
	spark_at(get_turf(user))
