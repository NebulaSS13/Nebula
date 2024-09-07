/datum/extension/shearable
	base_type = /datum/extension/shearable
	expected_type = /mob/living
	flags = EXTENSION_FLAG_IMMEDIATE

	var/has_fleece = FALSE
	var/next_fleece = 0
	var/fleece_time = 5 MINUTES
	var/fleece_type = /obj/item/fleece
	var/decl/material/fleece_material = /decl/material/solid/organic/cloth/wool

	var/decl/skill/shearing_skill = SKILL_BOTANY
	var/shearing_skill_req        = SKILL_BASIC

/datum/extension/shearable/New(datum/holder, _fleece_material)
	. = ..()
	if(ispath(_fleece_material, /decl/material))
		fleece_material = _fleece_material
	if(ispath(fleece_material, /decl/material))
		fleece_material = GET_DECL(fleece_material)
	START_PROCESSING(SSprocessing, src)

/datum/extension/shearable/Process()
	if(has_fleece)
		return PROCESS_KILL
	if(world.time >= next_fleece)

		has_fleece = TRUE
		var/mob/living/critter = holder

		// Update fleeced simple animals with overlay.
		if(istype(holder, /mob/living/simple_animal))
			var/fleece_state = "[critter.icon_state]-fleece"
			if(check_state_in_icon(fleece_state, critter.icon))
				var/mob/living/simple_animal/animal = critter
				LAZYSET(animal.draw_visible_overlays, "fleece", fleece_material.color)

		critter.try_refresh_visible_overlays()
		return PROCESS_KILL

/datum/extension/shearable/proc/handle_sheared(obj/item/shears, mob/user)

	var/mob/living/critter = holder
	if(!has_fleece)
		to_chat(user, SPAN_WARNING("\The [critter] is not ready to be shorn again yet."))
		return TRUE

	if(critter.get_automove_target())
		if(user.skill_check(shearing_skill, SKILL_PROF))
			to_chat(user, SPAN_NOTICE("\The [critter] goes still at your touch."))
			critter.stop_automove()
		else
			to_chat(user, SPAN_WARNING("Wait for \the [critter] to stop moving before you try shearing it."))
			return TRUE

	// Cows don't like being milked if you're unskilled.
	if(user.skill_fail_prob(shearing_skill, 40, shearing_skill_req))
		handle_shearing_failure(user, critter)
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] starts shearing \the [critter]."),
		SPAN_NOTICE("You start shearing \the [critter].")
	)
	if(!user.do_skilled(4 SECONDS, shearing_skill))
		user.visible_message(
			SPAN_NOTICE("\The [user] stops shearing \the [critter]."),
			SPAN_NOTICE("You stop shearing \the [critter].")
		)
		return TRUE

	if(QDELETED(user) || QDELETED(critter) || QDELETED(shears) || user.get_active_held_item() != shears)
		return TRUE

	if(critter.get_automove_target())
		to_chat(user, SPAN_WARNING("Wait for \the [critter] to stop moving before you try shearing it."))
		return TRUE

	if(!has_fleece)
		to_chat(user, SPAN_WARNING("\The [critter] is not ready to be shorn again yet."))
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] finishes shearing \the [critter]."),
		SPAN_NOTICE("You finish shearing \the [critter].")
	)

	new fleece_type(get_turf(critter), fleece_material.type, critter)

	has_fleece = FALSE
	next_fleece = world.time + fleece_time

	// Update fleeced simple animals with overlay.
	if(istype(holder, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal = holder
		LAZYREMOVE(animal.draw_visible_overlays, "fleece")

	if(!is_processing)
		START_PROCESSING(SSprocessing, src)
	critter.try_refresh_visible_overlays()
	return TRUE

/datum/extension/shearable/proc/handle_shearing_failure(mob/user, mob/living/critter)
	critter?.ai?.retaliate()
