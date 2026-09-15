#define ATTACK_POSITION_TOO_FAR 0
#define ATTACK_POSITION_MOVING  1
#define ATTACK_POSITION_IDEAL   2

/datum/mob_controller
	/// Radius of target scan area when looking for valid targets. Set to 0 to disable target scanning.
	var/target_scan_distance = 0
	/// Time tracker for next target scan.
	var/next_target_scan_time
	/// How long minimum between scans.
	var/target_scan_delay = 1 SECOND
	/// Reference to the atom we are targetting.
	var/weakref/target_ref

/datum/mob_controller/proc/get_target()
	if(isnull(target_ref))
		return null
	var/atom/target = target_ref?.resolve()
	if(!istype(target) || QDELETED(target))
		set_target(null)
		return null
	return target

/datum/mob_controller/proc/set_target(atom/new_target)
	var/weakref/new_target_ref = weakref(new_target)
	if(target_ref != new_target_ref)
		target_ref = new_target_ref
		return TRUE
	return FALSE

/datum/mob_controller/proc/find_valid_target()
	SHOULD_CALL_PARENT(TRUE)
	next_target_scan_time = world.time + target_scan_delay
	if(!(ai_flags & AI_FLAG_AGGRESSIVE))
		return
	if(!body.can_act() || !body.faction)
		return null
	resume_wandering()
	for(var/atom/A in get_valid_targets())
		body.face_atom(A)
		return A

/datum/mob_controller/proc/valid_target(var/atom/target)

	if(!istype(target))
		return FALSE
	if(!target.simulated)
		return FALSE
	if(target == body)
		return FALSE
	if(target.invisibility > body.see_invisible)
		return FALSE
	if(!target.loc)
		return FALSE
	if(!ismob(target))
		return TRUE

	var/mob/prey = target
	if(prey.stat || prey.is_invisible_to(body) || is_in_faction(prey))
		return FALSE
	if(LAZYLEN(_friends) && (weakref(prey) in _friends))
		return FALSE
	// Hunters are slightly more discerning about their targets than generally aggressive mobs.
	if((ai_flags & AI_FLAG_HUNTER) && !wants_to_hunt(prey))
		return FALSE
/*
	if(mode == "specific" && !is_enemy(prey))
		return FALSE
*/
	return TRUE

/datum/mob_controller/proc/check_lost_target()
	var/atom/target = get_target()
	if(!target)
		return TRUE
	if(!valid_target(target) || !(target in get_raw_target_list()))
		lose_target()
		return TRUE
	return FALSE

/datum/mob_controller/proc/lose_target()
	path_frustration = 0
	path_obstacles = null
	set_target(null)
	lost_target()

/datum/mob_controller/proc/lost_target()
	set_stance(/decl/mob_controller_stance/idle)
	body.stop_automove()

/datum/mob_controller/proc/list_targets()

	// Base hostile mobs will just destroy everything in view.
	// Mobs with an enemy list will filter the view by their enemies.
	if(!(ai_flags & AI_FLAG_ATTACKS_ENEMIES) || ("everyone" in _enemies))
		return get_raw_target_list()

	// By default, we only target designated enemies.
	var/list/enemies = get_enemies()
	if(!LAZYLEN(enemies))
		return

	var/list/possible_targets = get_raw_target_list()
	if(!length(possible_targets))
		return

	for(var/weakref/enemy in enemies) // Remove all entries that aren't in enemies
		var/target = enemy.resolve()
		if(target in possible_targets)
			LAZYDISTINCTADD(., target)

/datum/mob_controller/proc/do_target_scan()
	. = target_scan_distance > 0 && world.time >= next_target_scan_time

/datum/mob_controller/proc/move_to_attack(atom/target)
	SHOULD_CALL_PARENT(TRUE)

	if(!istype(body) || !body.can_act())
		return FALSE

	// If we're confused, we just wander around.
	if(HAS_STATUS(body, STAT_CONFUSE))
		body.start_automove(pick(orange(2, body)))
		return FALSE

	var/list/available_maneuvers = body.get_available_maneuvers()
	if(length(available_maneuvers))
		for(var/maneuver_type in available_maneuvers)
			var/decl/maneuver/maneuver_decl = RESOLVE_TO_DECL(maneuver_type)
			if(istype(maneuver_decl) && maneuver_decl.ai_should_use(body, target) && body.perform_maneuver(maneuver_type, target))
				return FALSE // Don't permit further behavior upstream

	body.start_automove(target)
	return TRUE

/datum/mob_controller/proc/get_raw_target_list()
	if(target_scan_distance)
		return hearers(body, target_scan_distance)-body
	return null

/datum/mob_controller/proc/get_valid_targets()
	. = list()
	for(var/target in list_targets(target_scan_distance))
		if(valid_target(target))
			. += target

/datum/mob_controller/proc/handle_ranged_target(atom/target)
	body.handle_ranged_attack(target)
	return TRUE

/datum/mob_controller/proc/in_attack_position(atom/target)

	if(!istype(target))
		return

	var/ranged_attacker = body.has_ranged_attack(target)

	// If we are cloaked, or if we are cautious and have a ranged attack ready, keep a minimum distance from the target.
	var/run_away = FALSE
	if((ai_flags & AI_FLAG_CAUTIOUS) && get_dist(body, target) < 3 && ranged_attacker)
		run_away = TRUE
	if((ai_flags & AI_FLAG_AMBUSHER) && !body.is_fully_cloaked())
		run_away = TRUE

	if(run_away)
		var/static/datum/automove_metadata/_ambusher_flee_metadata = new(
			_avoid_target = TRUE,
			_acceptable_distance = 3
		)
		body.start_automove(target, metadata = _ambusher_flee_metadata)
		return ATTACK_POSITION_MOVING

	// Are we close enough for ranged or melee?
	if((ranged_attacker && get_dist(body, target) < body.get_ranged_attack_distance()) || body.Adjacent(target))
		return ATTACK_POSITION_IDEAL
	return ATTACK_POSITION_TOO_FAR

/datum/mob_controller/proc/try_attack(atom/target)
	if(body.has_ranged_attack(target) && get_dist(body, target) > 1)
		handle_ranged_target(target)
	else if(body.Adjacent(target))
		melee_attack_target(target)

/datum/mob_controller/proc/melee_attack_target(atom/target)

	set waitfor = FALSE

	if(!istype(target) || !body.Adjacent(target))
		lose_target()
		return

	// TODO: update this to handle being ridden by an enemy we are not targeting; maybe update target to that mob prior to this block.
	var/mob/living/target_mob = target
	if(istype(target_mob) && (target in body.get_buckled_mobs()) && !is_in_faction(target))
		body.visible_message(SPAN_DANGER("\The [body] attempts to unseat \the [target]!"))
		body.set_dir(pick(global.cardinal))
		body.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(prob(33))
			body.unbuckle_mob(target)
			if(!(target in body.get_buckled_mobs()) && !QDELETED(target))
				to_chat(target, SPAN_DANGER("You are thrown off \the [body]!"))
				var/mob/living/victim = target
				SET_STATUS_MAX(victim, STAT_WEAK, 3)
		return

	if(!body.Adjacent(target))
		return

	if((ai_flags & AI_FLAG_HUNTER) && target_mob.stat == DEAD)
		consume_prey(target_mob)
		return

	// AI-driven mobs have a melee telegraph that needs to be handled here.
	if(!body.do_attack_windup_checking(target))
		return

	if(QDELETED(body) || body.incapacitated() || QDELETED(target))
		return

	body.set_intent(I_FLAG_HARM)
	body.ClickOn(target)

/datum/mob_controller/proc/get_targets_by_string(message, filter_friendlies = FALSE)
	for(var/mob/living/target in view(body, 10))
		if((filter_friendlies && is_friend(target)) || is_in_faction(target))
			continue
		var/found = FALSE
		if(findtext(message, "[target]"))
			found = TRUE
		else
			//this big MESS is basically 'turn this into words, no punctuation, lowercase so we can check first name/last name/etc'
			var/static/list/depunct_list = list("-"=" ", "."=" ", "," = " ", "'" = " ")
			var/list/parsed_name = splittext(replace_characters(lowertext(html_decode("[target]")),depunct_list), " ")
			for(var/token in parsed_name)
				if(token == "the" || length(token) < 2) //get rid of shit words.
					continue
				if(findtext(message,"[token]"))
					found = TRUE
					break
		if(found)
			LAZYADD(., weakref(target))

// By default, randomize the target area a bit to make armor/combat
// a bit more dynamic (and avoid constant organ damage to the chest)
/datum/mob_controller/proc/update_target_zone()
	if(body)
		return body.set_target_zone(ran_zone())
	return FALSE

/datum/mob_controller/proc/is_attackable(atom/target)
	if(!isliving(target))
		return TRUE
	var/mob/living/target_mob = target
	if(target_mob.stat)
		return FALSE
	if(target_mob.is_invisible_to(body))
		return FALSE
	return TRUE
