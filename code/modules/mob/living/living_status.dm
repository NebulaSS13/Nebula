/mob // Defined on /mob to avoid having to pass args to every single attack_foo() proc.
	var/datum/status_marker_holder/status_markers
	var/list/status_counters
	var/list/pending_status_counters

/mob/living/set_status(var/condition, var/amount)
	if(!ispath(condition, /decl/status_condition))
		return FALSE
	var/decl/status_condition/cond = GET_DECL(condition)
	if(!cond.check_can_set(src))
		return FALSE

	var/decl/species/my_species = get_species()
	if(my_species)
		amount = my_species.adjust_status(src, condition, amount)
	var/decl/bodytype/my_bodytype = get_bodytype()
	if(my_bodytype)
		amount = my_bodytype.adjust_status(src, condition, amount)
	amount = clamp(amount, 0, 1000)

	if(amount == PENDING_STATUS(src, condition))
		return FALSE
	LAZYSET(pending_status_counters, condition, amount)
	addtimer(CALLBACK(src, PROC_REF(apply_pending_status_changes)), 0, TIMER_UNIQUE)
	return TRUE

/mob/living/proc/rebuild_status_markers()
	if(!length(status_counters) || stat == DEAD)
		if(status_markers)
			status_markers.clear_markers()
		return
	if(!status_markers)
		status_markers = new(src)
	status_markers.refresh_markers(src)

/mob/living/proc/apply_pending_status_changes()
	var/rebuild_markers = FALSE
	if(!isnull(pending_status_counters))
		for(var/condition in pending_status_counters)
			var/last_amount = LAZYACCESS(status_counters, condition) || 0
			var/next_amount = LAZYACCESS(pending_status_counters, condition) || 0
			if(last_amount != next_amount)
				rebuild_markers = TRUE
				if(next_amount == 0)
					LAZYREMOVE(status_counters, condition)
				else
					LAZYSET(status_counters, condition, next_amount)
				status_change(condition, next_amount, last_amount)
		pending_status_counters = null
	if(rebuild_markers)
		rebuild_status_markers()
		update_icon()

/mob/living/proc/status_change(var/condition, var/new_amount, var/last_amount)
	var/decl/status_condition/status = GET_DECL(condition)
	status.handle_changed_amount(src, new_amount, last_amount)

/mob/living/handle_status_effects()
	. = ..()
	var/refresh_icon = FALSE
	for(var/condition in status_counters)
		var/decl/status_condition/status = GET_DECL(condition)
		status.handle_status(src, status_counters[condition])
		if(GET_STATUS(src, condition) <= 0)
			status_counters -= condition
			refresh_icon = TRUE
	if(refresh_icon)
		update_icon()

/mob/living/clear_status_effects()
	var/had_counters = !!LAZYLEN(status_counters)
	for(var/stype in status_counters)
		set_status(stype, 0)
	status_counters = null
	pending_status_counters = null
	if(had_counters)
		rebuild_status_markers()
		update_icon()
