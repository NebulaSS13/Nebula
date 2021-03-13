/mob // Defined on /mob to avoid having to pass args to every single attack_foo() proc.
	var/list/status_counters
	var/list/pending_status_counters

/mob/living/set_status(var/condition, var/amount)
	if(!ispath(condition, /decl/status_condition))
		return FALSE
	var/decl/status_condition/cond = decls_repository.get_decl(condition)
	if(!cond.check_can_set(src))
		return FALSE
	amount = Clamp(amount, 0, 1000)
	if(amount == PENDING_STATUS(src, condition))
		return FALSE
	LAZYSET(pending_status_counters, condition, amount)
	addtimer(CALLBACK(src, .proc/apply_pending_status_changes), 0, TIMER_UNIQUE)
	return TRUE

/mob/living/proc/apply_pending_status_changes()
	for(var/condition in pending_status_counters)
		var/last_amount = LAZYACCESS(status_counters, condition) || 0
		var/next_amount = LAZYACCESS(pending_status_counters, condition) || 0
		if(last_amount != next_amount)
			if(next_amount == 0)
				LAZYREMOVE(status_counters, condition)
			else
				LAZYSET(status_counters, condition, next_amount)
			status_change(condition, next_amount, last_amount)
	pending_status_counters = null

/mob/living/proc/status_change(var/condition, var/new_amount, var/last_amount)
	var/decl/status_condition/status = decls_repository.get_decl(condition)
	status.handle_changed_amount(src, new_amount, last_amount)

/mob/living/handle_status_effects()
	. = ..()
	for(var/condition in status_counters)
		var/decl/status_condition/status = decls_repository.get_decl(condition)
		status.handle_status(src, status_counters[condition])
		if(GET_STATUS(src, condition) <= 0)
			status_counters -= condition

/mob/living/clear_status_effects()
	for(var/stype in status_counters)
		set_status(stype, 0)
	status_counters = null
