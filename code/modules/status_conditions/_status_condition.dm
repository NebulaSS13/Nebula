var/global/list/status_marker_holders = list()

// Check code/modules/mob/mob_status.dm code/modules/mob/living/living_status.dm
// for the procs that check/set/process these status conditions.
/decl/status_condition
	var/name
	var/check_flags = 0
	var/list/victim_data

	var/decl/mob_modifier/associated_mob_modifier

	var/status_marker_icon = 'icons/effects/status.dmi'
	var/status_marker_state
	var/status_marker_private = FALSE

/decl/status_condition/Initialize()
	. = ..()
	if(ispath(associated_mob_modifier))
		associated_mob_modifier = GET_DECL(associated_mob_modifier)

/decl/status_condition/validate()
	. = ..()
	if(associated_mob_modifier && !istype(associated_mob_modifier))
		. += "invalid associated_mob_modifier '[associated_mob_modifier]'"

/decl/status_condition/proc/handle_changed_amount(var/mob/living/victim, var/new_amount, var/last_amount)
	set waitfor = FALSE

/decl/status_condition/proc/check_can_set(var/mob/living/victim)
	return !check_flags || (victim.status_flags & check_flags)

/decl/status_condition/proc/handle_status(var/mob/living/victim, var/amount)
	ADJ_STATUS(victim, type, -1)

/decl/status_condition/proc/show_status(var/mob/owner)
	return !status_marker_private && istype(owner) && owner.stat == CONSCIOUS
