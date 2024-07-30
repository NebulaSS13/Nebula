/datum/mob_controller/aggressive
	stance = STANCE_IDLE
	stop_wander_when_pulled = FALSE
	try_destroy_surroundings = TRUE
	var/attack_same_faction = FALSE
	var/only_attack_enemies = FALSE
	var/break_stuff_probability = 10
	var/weakref/target_ref

/datum/mob_controller/aggressive/set_target(atom/new_target)
	var/weakref/new_target_ref = weakref(new_target)
	if(target_ref != new_target_ref)
		target_ref = new_target_ref
		return TRUE
	return FALSE

/datum/mob_controller/aggressive/get_target()
	if(isnull(target_ref))
		return null
	var/atom/target = target_ref?.resolve()
	if(!istype(target) || QDELETED(target))
		set_target(null)
		return null
	return target

/datum/mob_controller/aggressive/Destroy()
	set_target(null)
	return ..()

/datum/mob_controller/aggressive/do_process()

	if(!(. = ..()))
		return

	if(!body.can_act())
		body.stop_automove()
		set_stance(get_target() ? STANCE_ATTACK : STANCE_IDLE)
		return

	if(isturf(body.loc) && !body.buckled)
		switch(stance)

			if(STANCE_IDLE)
				set_target(find_target())
				set_stance(STANCE_ATTACK)

			if(STANCE_ATTACK)
				body.face_atom(get_target())
				if(try_destroy_surroundings)
					destroy_surroundings()
				move_to_target()

			if(STANCE_ATTACKING)
				body.face_atom(get_target())
				if(try_destroy_surroundings)
					destroy_surroundings()
				handle_attacking_target()

			if(STANCE_CONTAINED) //we aren't inside something so just switch
				set_stance(STANCE_IDLE)

	else if(get_stance() != STANCE_CONTAINED)
		set_stance(STANCE_CONTAINED)
		body.stop_automove()
		set_target(null)

/datum/mob_controller/aggressive/proc/attackable(target_mob)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if(L.stat)
			return FALSE
	return TRUE

/datum/mob_controller/aggressive/proc/handle_attacking_target()
	stop_wandering()
	var/atom/target = get_target()
	if(!istype(target) || !attackable(target) || !(target in list_targets(10))) // consider replacing this list_targets() call with a distance or LOS check
		lose_target()
		return FALSE
	if (ishuman(target))
		var/mob/living/human/H = target
		if (H.is_cloaked())
			lose_target()
			return FALSE
	if(body.next_move >= world.time)
		return FALSE
	if(get_dist(body, target) > 1)
		move_to_target()
		return FALSE
	//Attacking
	attack_target()
	return TRUE

/datum/mob_controller/aggressive/proc/attack_target()
	var/atom/target = get_target()
	if(!istype(target))
		lose_target()
		return
	if(isliving(target) && body.buckled_mob == target && (!body.faction || body.buckled_mob.faction != body.faction))
		body.visible_message(SPAN_DANGER("\The [body] attempts to unseat \the [body.buckled_mob]!"))
		body.set_dir(pick(global.cardinal))
		body.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(prob(33))
			body.unbuckle_mob()
			if(body.buckled_mob != target && !QDELETED(target))
				to_chat(target, SPAN_DANGER("You are thrown off \the [body]!"))
				var/mob/living/victim = target
				SET_STATUS_MAX(victim, STAT_WEAK, 3)
		return target
	if(body.Adjacent(target))
		body.a_intent = I_HURT
		body.ClickOn(target)
		return target

/datum/mob_controller/aggressive/destroy_surroundings()

	if(!body.can_act())
		return

	// If we're not hunting something, don't destroy stuff.
	var/atom/target = get_target()
	if(!istype(target))
		return

	// Not breaking stuff, or already adjacent to a target.
	if(!prob(break_stuff_probability) || body.Adjacent(target))
		return

	// Try to get our next step towards the target.
	body.face_atom(target)
	var/turf/targ = get_step_towards(body, target)
	if(!targ)
		return

	// Attack anything on the target turf.
	var/obj/effect/shield/S = locate(/obj/effect/shield) in targ
	if(S && S.gen && S.gen.check_flag(MODEFLAG_NONHUMANS))
		body.a_intent = I_HURT
		body.ClickOn(S)
		return

	// Hostile mobs will bash through these in order with their natural weapon
	// Note that airlocks and blast doors are handled separately below.
	// TODO: mobs should destroy powered/unforceable doors before trying to pry them.
	var/static/list/valid_obstacles_by_priority = list(
		/obj/structure/window,
		/obj/structure/closet,
		/obj/machinery/door/window,
		/obj/structure/table,
		/obj/structure/grille,
		/obj/structure/barricade,
		/obj/structure/wall_frame,
		/obj/structure/railing
	)

	for(var/type in valid_obstacles_by_priority)
		var/obj/obstacle = locate(type) in targ
		if(obstacle)
			body.a_intent = I_HURT
			body.ClickOn(obstacle)
			return

	if(body.can_pry_door())
		for(var/obj/machinery/door/obstacle in targ)
			if(obstacle.density)
				if(!obstacle.can_open(1))
					return
				body.face_atom(obstacle)
				body.pry_door(obstacle, (obstacle.pry_mod * body.get_door_pry_time()))
				return

/datum/mob_controller/aggressive/retaliate(atom/source)

	if(!(. = ..()))
		return

	if(!only_attack_enemies)
		if(source)
			set_target(source)
			move_to_target(move_only = TRUE)
		return

	var/list/allies
	var/list/around = view(body, 7)
	for(var/atom/movable/A in around)
		if(A == body || !isliving(A))
			continue
		var/mob/living/M = A
		if(attack_same_faction || M.faction != body.faction)
			add_enemy(M)
		else if(istype(M.ai))
			LAZYADD(allies, M.ai)

	var/list/enemies = get_enemies()
	if(LAZYLEN(enemies) && LAZYLEN(allies))
		for(var/datum/mob_controller/ally as anything in allies)
			ally.add_enemies(enemies)

/datum/mob_controller/aggressive/move_to_target(var/move_only = FALSE)
	if(!body.can_act())
		return
	if(HAS_STATUS(body, STAT_CONFUSE))
		body.start_automove(pick(orange(2, body)))
		return
	stop_wandering()
	var/atom/target = get_target()
	if(!istype(target) || !attackable(target) || !(target in list_targets(10)))
		lose_target()
		return
	if(body.has_ranged_attack() && get_dist(body, target) <= body.get_ranged_attack_distance() && !move_only)
		body.stop_automove()
		open_fire()
		return
	set_stance(STANCE_ATTACKING)
	body.start_automove(target)

/datum/mob_controller/aggressive/list_targets(var/dist = 7)
	// Base hostile mobs will just destroy everything in view.
	// Mobs with an enemy list will filter the view by their enemies.
	if(!only_attack_enemies)
		return hearers(body, dist)-body
	var/list/enemies = get_enemies()
	if(!LAZYLEN(enemies))
		return
	var/list/possible_targets = hearers(body, dist)-body
	if(!length(possible_targets))
		return
	for(var/weakref/enemy in enemies) // Remove all entries that aren't in enemies
		var/M = enemy.resolve()
		if(M in possible_targets)
			LAZYDISTINCTADD(., M)

/datum/mob_controller/aggressive/find_target()
	if(!body.can_act() || !body.faction)
		return null
	resume_wandering()
	for(var/atom/A in list_targets(10))
		if(valid_target(A))
			set_stance(STANCE_ATTACK)
			body.face_atom(A)
			return A

/datum/mob_controller/aggressive/valid_target(var/atom/A)
	if(A == body)
		return FALSE
	if(ismob(A))
		var/mob/M = A
		if(M.faction == body.faction && !attack_same_faction)
			return FALSE
		else if(weakref(M) in get_friends())
			return FALSE
		if(M.stat)
			return FALSE
		if(ishuman(M))
			var/mob/living/human/H = M
			if (H.is_cloaked())
				return FALSE
	return TRUE

/datum/mob_controller/aggressive/open_fire()
	if(!body.can_act())
		return FALSE
	body.handle_ranged_attack(get_target())
	return TRUE

/datum/mob_controller/aggressive/lose_target()
	set_target(null)
	lost_target()

/datum/mob_controller/aggressive/lost_target()
	set_stance(STANCE_IDLE)
	body.stop_automove()

/datum/mob_controller/aggressive/pacify(mob/user)
	..()
	attack_same_faction = FALSE
