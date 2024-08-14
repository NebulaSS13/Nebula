/decl/bodytype/shapeshifter
	name = "protean form"
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_shapeshifter"

/decl/bodytype/shapeshifter/apply_limb_colouration(var/obj/item/organ/external/E, var/icon/applying)
	applying.MapColors("#4d4d4d","#969696","#1c1c1c", "#000000")
	applying.SetIntensity(limb_icon_intensity)
	applying += rgb(,,,180) // Makes the icon translucent, SO INTUITIVE TY BYOND
	return applying

/decl/bodytype/shapeshifter/check_dismember_type_override(var/disintegrate)
	if(disintegrate == DISMEMBER_METHOD_EDGE)
		return DISMEMBER_METHOD_BLUNT
	return ..()

/decl/bodytype/shapeshifter/get_base_icon(var/mob/living/human/H, var/get_deform)
	if(!H) return ..(null, get_deform)
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.default_bodytype.get_base_icon(H, get_deform)

/decl/bodytype/shapeshifter/get_blood_overlays(var/mob/living/human/H)
	if(!H) return ..()
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.default_bodytype.get_blood_overlays(H)

/decl/bodytype/shapeshifter/get_damage_overlays(var/mob/living/human/H)
	if(!H) return ..()
	var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
	return S.default_bodytype.get_damage_overlays(H)

/decl/bodytype/shapeshifter/get_husk_icon(var/mob/living/human/H)
	if(H)
		var/decl/species/S = get_species_by_key(wrapped_species_by_ref["\ref[H]"])
		if(S) return S.default_bodytype.get_husk_icon(H)
	 return ..()

/decl/bodytype/shapeshifter/get_icon_cache_uid(var/mob/H)
	. = ..()
	if(H)
		. = "[.]-[wrapped_species_by_ref["\ref[H]"]]"

/decl/bodytype/shapeshifter/apply_bodytype_organ_modifications(obj/item/organ/org)
	..()
	var/obj/item/organ/external/E = org
	if(istype(E) && E.owner)
		E.sync_colour_to_human(E.owner)