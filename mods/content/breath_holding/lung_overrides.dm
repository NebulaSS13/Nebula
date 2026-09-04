/obj/item/organ/internal/lungs
	var/can_hold_breath = TRUE
	/// The breath currently being held.
	var/datum/gas_mixture/held_breath = null
	/// Whether or not to hold the next breath. If FALSE, any held breath (if it exists) will be exhaled. If TRUE, the next breath will be held.
	var/holding_breath = FALSE

/obj/item/organ/internal/lungs/do_uninstall(in_place, detach, ignore_children)
	var/mob/living/prior_owner = owner
	if(!(. = ..()))
		return
	if(istype(prior_owner) && !prior_owner.get_organ(BP_LUNGS))
		prior_owner.verbs -= /mob/living/proc/hold_breath

/obj/item/organ/internal/lungs/do_install(mob/living/human/target, obj/item/organ/external/affected, in_place)
	. = ..()
	if(istype(owner) && !QDELETED(owner) && can_hold_breath)
		owner.verbs |= /mob/living/proc/hold_breath

/obj/item/organ/internal/lungs/proc/hold_breath()
	if(!can_hold_breath)
		if(owner)
			owner.verbs -= /mob/living/proc/hold_breath
		return
	// if there's ever a reason we should allow ownerless breath-holding this will have to be changed
	if(!owner || owner.stat != CONSCIOUS)
		return
	if(!holding_breath)
		owner.visible_message(SPAN_WARNING("\The [src] starts holding their breath!"), SPAN_WARNING("You start holding your breath!"))
	else
		owner.visible_message(SPAN_NOTICE("\The [src] starts breathing again."), SPAN_NOTICE("You stop holding your breath."))
	holding_breath = !holding_breath
	owner.try_breathe() // inhale/exhale immediately

// OVERRIDE: Can't drown while holding your breath
/obj/item/organ/internal/lungs/can_drown()
	if(holding_breath && held_breath)
		return FALSE
	return ..()