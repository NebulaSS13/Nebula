/decl/status_condition/sleeping
	name = "asleep"
	status_marker_state = "asleep"

/decl/status_condition/sleeping/show_status(var/mob/owner)
	return istype(owner) && owner.stat != DEAD

/decl/status_condition/sleeping/handle_changed_amount(var/mob/living/victim, var/new_amount, var/last_amount)
	. = ..()
	victim.facing_dir = null
	victim.UpdateLyingBuckledAndVerbStatus()
	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		H.handle_dreams()
		H.species.handle_sleeping(H)

/decl/status_condition/sleeping/handle_status(mob/living/victim, var/amount)
	. = ..()
	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		H.handle_dreams()
		H.species.handle_sleeping(H)
