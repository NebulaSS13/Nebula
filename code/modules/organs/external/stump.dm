/obj/item/organ/external/stump
	name = "limb stump"
	icon_name = ""
	dislocated = -1

/obj/item/organ/external/stump/on_remove_effects(mob/living/last_owner)
	if(!(. = ..()))
		return
	qdel(src)

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
	return 1
