/obj/item/organ/external/tail
	var/tail_icon
	var/tail_state
	var/tail_hair
	var/tail_animation
	var/tail_states

	organ_tag = BP_TAIL
	render_alpha = 0
	name = "tail"
	max_damage = 20
	min_broken_damage = 10
	w_class = ITEM_SIZE_NORMAL
	body_part = SLOT_LOWER_BODY
	parent_organ = BP_GROIN
	joint = "tail"
	amputation_point = "tail"
	artery_name = "vein"
	arterial_bleed_severity = 0.3
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_BREAK

/obj/item/organ/external/tail/sync_colour_to_human(var/mob/living/carbon/human/human)
	if(owner.bodytype || !(tail_icon && tail_state && tail_hair && tail_animation && tail_states))//no overriding if something there
		tail_icon = owner.bodytype.tail_icon
		tail_state = owner.bodytype.tail
		tail_hair = owner.bodytype.tail_hair
		tail_animation = owner.bodytype.tail_animation
		tail_states = owner.bodytype.tail_states
	. = ..()

/obj/item/organ/external/tail/proc/get_tail()
	return tail_state

/obj/item/organ/external/tail/proc/get_tail_animation()
	return tail_animation

/obj/item/organ/external/tail/proc/get_tail_hair()
	return tail_hair

/obj/item/organ/external/tail/proc/get_tail_icon()
	return tail_icon
