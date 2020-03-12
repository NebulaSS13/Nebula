/mob/living/carbon/human/add_grab(var/obj/item/grab/grab)
	. = put_in_active_hand(grab)

/mob/living/carbon/human/can_be_grabbed(var/mob/grabber, var/target_zone)
	. = ..()
	if(.)
		var/obj/item/organ/organ = target_zone && organs_by_name[target_zone]
		if(!istype(organ))
			to_chat(grabber, SPAN_WARNING("\The [src] is missing that body part!"))
			return FALSE
		if(grabber == src)
			var/list/bad_parts = hand ? list(BP_L_ARM, BP_L_HAND) : list(BP_R_ARM, BP_R_HAND)
			if(organ && (organ.organ_tag in bad_parts))
				to_chat(src, SPAN_WARNING("You can't grab your own [organ.name] with itself!"))
				return FALSE
		if(pull_damage())
			to_chat(grabber, SPAN_DANGER("Pulling \the [src] in their current condition would probably be a bad idea."))
		var/obj/item/clothing/C = get_covering_equipped_item_by_zone(target_zone)
		if(istype(C))
			C.leave_evidence(grabber)

/mob/living/carbon/human/make_grab(var/atom/movable/target, var/grab_tag = /decl/grab/simple)
	. = ..()
	if(.)
		remove_cloaking_source(species)
