/obj/item/organ/external/stump
	name = "limb stump"
	icon_name = ""
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE //Needs this for limb replacement surgery. Since you need to remove stumps first

/obj/item/organ/external/stump/Initialize(mapload, var/internal, var/obj/item/organ/external/limb)
	if(istype(limb))
		SetName("stump of \a [limb.name]")
		organ_tag = limb.organ_tag
		body_part = limb.body_part
		amputation_point = limb.amputation_point
		joint = limb.joint
		parent_organ = limb.parent_organ
		artery_name = "mangled [limb.artery_name]"
		arterial_bleed_severity = limb.arterial_bleed_severity
	. = ..(mapload, internal)
	if(istype(limb))
		max_damage = limb.max_damage
		if(BP_IS_PROSTHETIC(limb) && (!parent || BP_IS_PROSTHETIC(parent)))
			robotize() //if both limb and the parent are robotic, the stump is robotic too
		if(BP_IS_CRYSTAL(limb) && (!parent || BP_IS_CRYSTAL(parent)))
			status |= ORGAN_CRYSTAL // Likewise with crystalline limbs.

/obj/item/organ/external/stump/is_stump()
	return TRUE

//Don't let stumps be dropped
/obj/item/organ/external/stump/is_droppable()
	return FALSE

//Stumps don't generate droplimb messages
/obj/item/organ/external/stump/get_droplimb_messages_for(droptype, clean)
	return

//Warn on dropping a stump. 
/obj/item/organ/external/stump/dropInto(atom/destination)
	. = ..()
	//QDeleted stumps will be dropped due to how items works. But otherwise make sure to make a stack trace
	if(!QDELETED(src))
		CRASH("[src] was dropped into the world!")