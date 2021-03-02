// Check code/modules/mob/mob_status.dm code/modules/mob/living/living_status.dm 
// for the procs that check/set/process these status conditions. 
/decl/status_condition
	var/name
	var/check_flags = 0
	var/list/victim_data

/decl/status_condition/proc/handle_changed_amount(var/mob/living/victim, var/new_amount, var/last_amount)
	set waitfor = FALSE

/decl/status_condition/proc/check_can_set(var/mob/living/victim)
	return !check_flags || (victim.status_flags & check_flags)

/decl/status_condition/proc/handle_status(var/mob/living/victim, var/amount)
	ADJ_STATUS(victim, type, -1)
