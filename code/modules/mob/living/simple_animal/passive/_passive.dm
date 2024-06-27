/datum/ai/passive
	expected_type = /mob/living/simple_animal
	var/weakref/flee_target
	var/turns_since_scan

/datum/ai/passive/proc/update_targets()
	//see if we should stop fleeing
	var/mob/living/simple_animal/critter = body
	var/atom/flee_target_atom = flee_target?.resolve()
	if(istype(flee_target_atom) && (flee_target_atom.loc in view(body)))
		if(body.MayMove())
			walk_away(body, flee_target_atom, 7, 2)
		critter.stop_automated_movement = TRUE
	else
		flee_target = null
		critter.stop_automated_movement = FALSE
	return !isnull(flee_target)

/datum/ai/passive/do_process(time_elapsed)
	..()

	// Handle fleeing from aggressors.
	turns_since_scan++
	if (turns_since_scan > 5)
		walk_to(body, 0)
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

/datum/ai/passive/proc/set_flee_target(atom/A)
	if(A)
		flee_target = weakref(A)
		turns_since_scan = 5

/mob/living/simple_animal/passive
	possession_candidate = TRUE
	abstract_type        = /mob/living/simple_animal/passive
	ai                   = /datum/ai/passive
	speak_chance         = 0.5
	turns_per_move       = 5
	see_in_dark          = 6
	minbodytemp          = 223
	maxbodytemp          = 323

/mob/living/simple_animal/passive/attackby(var/obj/item/O, var/mob/user)
	. = ..()
	if(O.force)
		var/datum/ai/passive/preyi = ai
		if(istype(preyi))
			preyi.set_flee_target(user? user : loc)

/mob/living/simple_animal/passive/default_hurt_interaction(mob/user)
	. = ..()
	if(.)
		var/datum/ai/passive/preyi = ai
		if(istype(preyi))
			preyi.set_flee_target(user)

/mob/living/simple_animal/passive/explosion_act()
	. = ..()
	var/datum/ai/passive/preyi = ai
	if(istype(preyi))
		preyi.set_flee_target(loc)

/mob/living/simple_animal/passive/bullet_act(var/obj/item/projectile/proj)
	. = ..()
	var/datum/ai/passive/preyi = ai
	if(istype(preyi))
		preyi.set_flee_target(isliving(proj.firer) ? proj.firer : loc)

/mob/living/simple_animal/passive/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	. = ..()
	var/datum/ai/passive/preyi = ai
	if(istype(preyi))
		preyi.set_flee_target(TT.thrower || loc)
