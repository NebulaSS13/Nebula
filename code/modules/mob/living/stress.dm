#define GET_STRESSOR(S) (istype(S, /datum/stressor) ? S : SSmanaged_instances.get(S, cache_category = /datum/stressor))

/mob/living/proc/get_stress_modifier()
	if(!config.adjust_healing_from_stress)
		return 0
	return stress

/mob/living/proc/add_stressor(var/stressor_id, duration)
	var/datum/stressor/stressor = GET_STRESSOR(stressor_id)
	if(stressor in stressors)
		stressor.refresh(src, duration)
	else
		if(length(stressor.incompatible_with_stressors))
			for(var/datum/stressor/other_stressor in stressor.incompatible_with_stressors)
				if(other_stressor in stressors)
					return FALSE
		stressor.add_to(src, duration)
	return TRUE

/mob/living/proc/remove_stressor(var/stressor_id)
	var/datum/stressor/stressor = GET_STRESSOR(stressor_id)
	if(stressor in stressors)
		stressor.remove_from(src)
		return TRUE
	return FALSE

/mob/living/proc/update_stress()
	set waitfor = FALSE
	if(currently_updating_stress)
		return
	currently_updating_stress = TRUE
	sleep(1)
	stress = 0
	// Work out what stressors we're hiding.
	var/list/suppressed = list()
	for(var/datum/stressor/stressor as anything in stressors)
		if(length(stressor.suppress_stressors))
			suppressed |= stressor.suppress_stressors
	// Accumulate our current stress.
	for(var/datum/stressor/stressor as anything in stressors)
		var/add_stress = stressor.tick(src)
		if(!(stressor in suppressed))
			stress += add_stress
	stress = clamp(stress, MIN_STRESS, MAX_STRESS)
	currently_updating_stress = FALSE

/mob/living/verb/check_stressors()

	set name = "Check Stressors"
	set category = "IC"
	set src = usr

	if(incapacitated(INCAPACITATION_KNOCKOUT))
		to_chat(src, SPAN_WARNING("You are in no state for accurate self-assessment."))
		return

	if(length(stressors))

		var/list/suppressed = list()
		for(var/datum/stressor/stressor as anything in stressors)
			if(length(stressor.suppress_stressors))
				suppressed |= stressor.suppress_stressors

		to_chat(src, SPAN_NOTICE("You are currently..."))
		for(var/datum/stressor/stressor as anything in stressors)
			if(stressor in suppressed)
				continue
			if(stressor.stress_value < 0)
				to_chat(src, "[SPAN_GOOD("...[stressor.desc]")]")
			else if(stressor.stress_value > 0)
				to_chat(src, "[SPAN_BAD("...[stressor.desc]")]")
			else
				to_chat(src, "[SPAN_NEUTRAL("...[stressor.desc]")]")

	// TODO: less loaded/more informative terminology
	var/stress_string
	if(stress <= -1)
		stress_string = "extremely relaxed"
	else if(stress <= -0.65)
		stress_string = "somewhat relaxed"
	else if(stress <= -0.35)
		stress_string = "relaxed"
	else if(stress >= 0.35)
		stress_string = "stressed"
	else if(stress >= 0.65)
		stress_string = "somewhat stressed"
	else if(stress >= 1)
		stress_string = "extremely stressed"
	else
		stress_string = "neither stressed nor relaxed"
	to_chat(src, SPAN_NEUTRAL("Overall, you are feeling [stress_string]."))

#undef GET_STRESSOR
