var/global/datum/automove_metadata/_flee_automove_metadata = new(
	_move_delay = 2,
	_acceptable_distance = 7,
	_avoid_target = TRUE
)

/datum/mob_controller/passive
	expected_type = /mob/living/simple_animal
	var/weakref/flee_target
	var/turns_since_scan

/datum/mob_controller/passive/proc/update_targets()
	//see if we should stop fleeing
	var/mob/living/simple_animal/critter = body
	var/atom/flee_target_atom = flee_target?.resolve()
	if(istype(flee_target_atom) && (flee_target_atom.loc in view(body)))
		critter.set_moving_quickly()
		critter.start_automove(flee_target_atom, metadata = global._flee_automove_metadata)
		critter.stop_wandering = TRUE
	else
		flee_target = null
		critter.set_moving_slowly()
		critter.stop_wandering = FALSE
	return !isnull(flee_target)

/datum/mob_controller/passive/do_process(time_elapsed)
	..()

	// Handle fleeing from aggressors.
	turns_since_scan++
	if (turns_since_scan > 5)
		body.stop_automove()
		turns_since_scan = 0
		if(update_targets())
			return

	var/mob/living/simple_animal/critter = body
	// Handle sleeping or wandering.
	if(body.stat == CONSCIOUS && prob(0.5))
		body.set_stat(UNCONSCIOUS)
		critter.wander = FALSE
		critter.speak_chance = 0
	else if(body.stat == UNCONSCIOUS && prob(1))
		body.set_stat(CONSCIOUS)
		critter.wander = TRUE

/datum/mob_controller/passive/proc/set_flee_target(atom/A)
	if(A)
		flee_target = weakref(A)
		turns_since_scan = 5

/mob/living/simple_animal/passive
	possession_candidate = TRUE
	abstract_type        = /mob/living/simple_animal/passive
	ai                   = /datum/mob_controller/passive
	speak_chance         = 0.5
	turns_per_wander       = 5
	see_in_dark          = 6
	minbodytemp          = 223
	maxbodytemp          = 323

/mob/living/simple_animal/passive/attackby(var/obj/item/O, var/mob/user)
	. = ..()
	if(O.force)
		var/datum/mob_controller/passive/preyi = ai
		if(istype(preyi))
			preyi.set_flee_target(user? user : loc)

/mob/living/simple_animal/passive/default_hurt_interaction(mob/user)
	. = ..()
	if(.)
		var/datum/mob_controller/passive/preyi = ai
		if(istype(preyi))
			preyi.set_flee_target(user)

/mob/living/simple_animal/passive/explosion_act()
	. = ..()
	var/datum/mob_controller/passive/preyi = ai
	if(istype(preyi))
		preyi.set_flee_target(loc)

/mob/living/simple_animal/passive/bullet_act(var/obj/item/projectile/proj)
	. = ..()
	var/datum/mob_controller/passive/preyi = ai
	if(istype(preyi))
		preyi.set_flee_target(isliving(proj.firer) ? proj.firer : loc)

/mob/living/simple_animal/passive/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	. = ..()
	var/datum/mob_controller/passive/preyi = ai
	if(istype(preyi))
		preyi.set_flee_target(TT.thrower || loc)
