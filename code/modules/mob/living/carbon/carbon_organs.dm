/mob/living/carbon/handle_organ_replaced(var/obj/item/organ/organ)
	..()
	LAZYSET(organs_by_tag, organ.organ_tag, organ)
	return TRUE

/mob/living/carbon/handle_organ_removed(var/obj/item/organ/organ, var/mob/user)
	..()
	LAZYREMOVE(organs_by_tag, organ.organ_tag)
	if(organ.vital)
		if(user)
			admin_attack_log(user, src, "Removed a vital organ ([organ]).", "Had a vital organ ([organ]) removed.", "removed a vital organ ([organ]) from")
		death()
	return TRUE

/mob/living/carbon/handle_internal_organ_replaced(var/obj/item/organ/internal/organ, var/mob/user)
	..()
	LAZYDISTINCTADD(internal_organs, organ)
	var/obj/item/organ/external/E = get_organ(organ.parent_organ)
	if(E)
		E.update_contained_organs_cost()
	return TRUE

/mob/living/carbon/handle_internal_organ_removed(var/obj/item/organ/internal/organ, var/mob/user)
	..()
	LAZYREMOVE(internal_organs, organ)
	var/obj/item/organ/external/E = get_organ(organ.parent_organ)
	if(E)
		E.update_contained_organs_cost()
	return TRUE

/mob/living/carbon/handle_external_organ_replaced(var/obj/item/organ/external/organ, var/mob/user)	
	..()
	LAZYDISTINCTADD(external_organs, organ)
	return TRUE

/mob/living/carbon/handle_external_organ_removed(var/obj/item/organ/external/organ, var/mob/user)
	LAZYREMOVE(external_organs, organ)
	return TRUE
