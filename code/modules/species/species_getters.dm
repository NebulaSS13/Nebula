/decl/species/proc/get_additional_examine_text(var/mob/living/human/H)
	return

/decl/species/proc/get_knockout_message(var/mob/living/human/H)
	return ((H && H.isSynthetic()) ? "encounters a hardware fault and suddenly reboots!" : knockout_message)

/decl/species/proc/get_species_death_message(var/mob/living/human/H)
	return ((H && H.isSynthetic()) ? "gives one shrill beep before falling lifeless." : death_message)

/decl/species/proc/get_ssd(var/mob/living/human/H)
	return ((H && H.isSynthetic()) ? "flashing a 'system offline' glyph on their monitor" : show_ssd)

/decl/species/proc/get_species_flesh_color(var/mob/living/human/H)
	return ((H && H.isSynthetic()) ? SYNTH_FLESH_COLOUR : flesh_color)

/decl/species/proc/get_vision_flags(var/mob/living/human/H)
	return vision_flags

/decl/species/proc/get_surgery_overlay_icon(var/mob/living/human/H)
	return 'icons/mob/surgery.dmi'

/decl/species/proc/get_footstep(var/mob/living/human/H, var/footstep_type)
	return

/decl/species/proc/get_brute_mod(var/mob/living/human/H)
	. = brute_mod

/decl/species/proc/get_burn_mod(var/mob/living/human/H)
	. = burn_mod

/decl/species/proc/get_radiation_mod(var/mob/living/human/H)
	. = (H && H.isSynthetic() ? 0.5 : radiation_mod)

/decl/species/proc/get_root_species_name(var/mob/living/human/H)
	return H?.get_bodytype()?.get_root_species_name(H) || name

/decl/species/proc/get_bodytype_by_name(var/bodytype_name)
	bodytype_name = trim(lowertext(bodytype_name))
	if(!bodytype_name)
		return
	for(var/decl/bodytype/bodytype in available_bodytypes)
		if(lowertext(bodytype.name) == bodytype_name)
			return bodytype

/decl/species/proc/get_bodytype_by_pronouns(var/decl/pronouns/pronouns)
	if(istype(pronouns))
		for(var/decl/bodytype/bodytype in available_bodytypes)
			if(!isnull(bodytype.associated_gender) && bodytype.associated_gender == pronouns.name)
				return bodytype
	return default_bodytype
