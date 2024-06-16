/datum/artifact_trigger/touch
	name = "touch"

/datum/artifact_trigger/touch/proc/can_touch(mob/living/human/H, bodypart)
	return TRUE

/datum/artifact_trigger/touch/on_touch(mob/living/M)
	return can_touch(M, M.get_active_held_item_slot())

/datum/artifact_trigger/touch/on_bump(atom/movable/AM)
	if(prob(25))
		return can_touch(AM, pick(BP_R_HAND, BP_L_HAND))

/datum/artifact_trigger/touch/organic
	name = "organic touch"

/datum/artifact_trigger/touch/organic/can_touch(mob/living/human/H, bodypart)
	if(!istype(H))
		return FALSE
	if(H.get_covering_equipped_item_by_zone(bodypart))
		return FALSE
	return TRUE

/datum/artifact_trigger/touch/organic/on_hit(obj/O, mob/user)
	return istype(O, /obj/item/organ/external)

/datum/artifact_trigger/touch/synth
	name = "robotic touch"

/datum/artifact_trigger/touch/synth/can_touch(mob/living/L, bodypart)
	if(issilicon(L))
		return TRUE
	if(ishuman(L))
		var/mob/living/human/H = L
		if(H.isSynthetic())
			return TRUE
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(H, bodypart)
		if(E && BP_IS_PROSTHETIC(E))
			return TRUE
		return FALSE
		