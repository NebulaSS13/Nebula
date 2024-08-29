
/datum/mob_controller/aggressive/giant_spider/guard
	expected_type = /mob/living/simple_animal/hostile/giant_spider/guard
	break_stuff_probability = 15
	var/vengance
	var/berserking
	var/weakref/paired_nurse

/datum/mob_controller/aggressive/giant_spider/guard/do_process(time_elapsed)
	. = ..()
	if(berserking)
		return
	if(!paired_nurse)
		find_nurse()
	if(paired_nurse && get_activity() == AI_ACTIVITY_IDLE && get_stance() == STANCE_IDLE)
		protect(paired_nurse)

/datum/mob_controller/aggressive/giant_spider/guard/handle_death(gibbed)
	if((. = ..()) && paired_nurse)
		var/datum/mob_controller/aggressive/giant_spider/nurse/paired_nurse_instance = paired_nurse.resolve()
		if(istype(paired_nurse_instance) && paired_nurse_instance.paired_guard == weakref(src))
			paired_nurse_instance.paired_guard = null
		paired_nurse = null

/datum/mob_controller/aggressive/giant_spider/guard/proc/find_nurse()
	for(var/mob/living/simple_animal/hostile/giant_spider/nurse/nurse in list_targets(10))
		if(nurse.stat || !istype(nurse.ai, /datum/mob_controller/aggressive/giant_spider/nurse))
			continue
		var/datum/mob_controller/aggressive/giant_spider/nurse/nurse_ai = nurse.ai
		if(nurse_ai.paired_guard)
			continue
		paired_nurse          = weakref(nurse_ai)
		nurse_ai.paired_guard = weakref(src)
		return TRUE
	return FALSE

/datum/mob_controller/aggressive/giant_spider/guard/proc/protect(weakref/nurse)
	stop_wandering()
	var/datum/mob_controller/aggressive/giant_spider/nurse/paired_nurse_instance = paired_nurse?.resolve()
	if(istype(paired_nurse_instance))
		var/static/datum/automove_metadata/_guard_nurse_metadata = new(
			_acceptable_distance = 2
		)
		body.start_automove(paired_nurse_instance.body, metadata = _guard_nurse_metadata)
		addtimer(CALLBACK(body, TYPE_PROC_REF(/mob/living/simple_animal/hostile/giant_spider, disable_stop_automated_movement)), 5 SECONDS)

/datum/mob_controller/aggressive/giant_spider/guard/proc/go_berserk()
	body.audible_message(SPAN_DANGER("\The [body] chitters wildly!"))
	var/mob/living/simple_animal/critter = body
	if(istype(critter))
		var/obj/item/attacking_with = critter.get_natural_weapon()
		if(attacking_with)
			attacking_with.set_base_attack_force(attacking_with.get_initial_base_attack_force() + 5)
	break_stuff_probability = 45
	addtimer(CALLBACK(src, PROC_REF(calm_down)), 3 MINUTES)

/datum/mob_controller/aggressive/giant_spider/guard/proc/calm_down()
	berserking = FALSE
	body.visible_message(SPAN_NOTICE("\The [body] calms down and surveys the area."))
	var/mob/living/simple_animal/critter = body
	if(istype(critter))
		var/obj/item/attacking_with = critter.get_natural_weapon()
		if(attacking_with)
			attacking_with.set_base_attack_force(attacking_with.get_initial_base_attack_force())
	break_stuff_probability = 10
