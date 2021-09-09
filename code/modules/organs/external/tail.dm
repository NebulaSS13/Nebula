/obj/item/organ/external/tail
	var/tail_icon
	var/tail_state
	var/tail_hair
	var/tail_animation

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
	arterial_bleed_severity = 03
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_BREAK

/obj/item/organ/external/tail/set_dna(datum/dna/new_dna)
	. = ..()
	if(owner.bodytype)
		tail_icon = owner.bodytype.tail_icon
		tail_state = owner.bodytype.tail
		tail_hair = owner.bodytype.tail_hair
		tail_animation = owner.bodytype.tail_animation