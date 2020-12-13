/datum/ailment
	var/timer_id
	var/min_time = 1 MINUTES
	var/max_time = 10 MINUTES
	var/category = /datum/ailment
	var/obj/item/organ/organ

	// Requirements before applying to a target.
	var/list/applies_to_organ
	var/specific_organ_subtype = /obj/item/organ/external
	var/affects_robotics = FALSE

/datum/ailment/New(var/obj/item/organ/_organ)
	..()
	if(_organ)
		organ = _organ
		if(organ.owner)
			begin_malfunction()

/datum/ailment/proc/can_apply_to(var/obj/item/organ/_organ)
	if(specific_organ_subtype && !istype(_organ, specific_organ_subtype))
		return FALSE
	if(affects_robotics)
		if(!BP_IS_PROSTHETIC(organ))
			return FALSE
	else if(BP_IS_PROSTHETIC(organ))
		return FALSE
	if(length(applies_to_organ) && !(_organ?.organ_tag in applies_to_organ))
		return FALSE
	return TRUE

/datum/ailment/Destroy(force)
	. = ..()
	organ = null
	deltimer(timer_id)
	timer_id = null

/datum/ailment/proc/begin_malfunction()
	if(!organ?.owner)
		return
	timer_id = addtimer(CALLBACK(src, .proc/do_malfunction), rand(min_time, max_time), TIMER_STOPPABLE | TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)

/datum/ailment/proc/do_malfunction()
	if(!organ?.owner)
		timer_id = null
		return
	begin_malfunction()
	on_malfunction()

/datum/ailment/proc/on_malfunction()
	return
