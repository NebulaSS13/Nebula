/mob/living
	VAR_PRIVATE/_updating_genetic_conditions
	VAR_PRIVATE/list/_genetic_conditions

/mob/living/proc/queue_genetic_condition_update()
	set waitfor = FALSE
	if(_updating_genetic_conditions)
		return
	_updating_genetic_conditions = TRUE
	sleep(1)
	_updating_genetic_conditions = FALSE
	update_genetic_conditions()

/mob/living/get_genetic_conditions()
	RETURN_TYPE(/list)
	return _genetic_conditions

/mob/living/can_have_genetic_conditions()
	return has_genetic_information()

/mob/living/has_genetic_condition(condition_type)
	if(!LAZYLEN(_genetic_conditions))
		return FALSE
	var/decl/genetic_condition/condition = GET_DECL(condition_type)
	return (condition in _genetic_conditions)

/mob/living/add_genetic_condition(condition_type, temporary_time)
	var/decl/genetic_condition/condition = GET_DECL(condition_type)
	if(condition && !(condition in _genetic_conditions) && condition.activate_condition(src))
		LAZYDISTINCTADD(_genetic_conditions, condition)
		if(temporary_time)
			// TODO: some kind of world.time key or parameter so overlapping calls don't remove each other.
			addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living, remove_genetic_condition)), temporary_time)
		queue_genetic_condition_update()
		return TRUE
	return FALSE

/mob/living/remove_genetic_condition(condition_type)
	if(!LAZYLEN(_genetic_conditions))
		return FALSE
	var/decl/genetic_condition/condition = GET_DECL(condition_type)
	if(condition && (condition in _genetic_conditions) && condition.deactivate_condition(src))
		LAZYREMOVE(_genetic_conditions, condition)
		queue_genetic_condition_update()
		return TRUE
	return FALSE

/mob/living/reset_genetic_conditions()
	if(!LAZYLEN(_genetic_conditions))
		return FALSE
	for(var/decl/genetic_condition/condition as anything in _genetic_conditions)
		if(condition.deactivate_condition(src))
			. = TRUE
	_genetic_conditions = null
	if(.)
		update_icon()
