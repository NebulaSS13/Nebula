/decl/species/proc/get_valid_shapeshifter_forms(var/mob/living/carbon/human/H)
	return list()

/decl/species/proc/get_additional_examine_text(var/mob/living/carbon/human/H)
	return

/decl/species/proc/get_tail(var/mob/living/carbon/human/H)
	return tail

/decl/species/proc/get_tail_animation(var/mob/living/carbon/human/H)
	return tail_animation

/decl/species/proc/get_tail_hair(var/mob/living/carbon/human/H)
	return tail_hair

/decl/species/proc/get_blood_mask(var/mob/living/carbon/human/H)
	return blood_mask

/decl/species/proc/get_damage_overlays(var/mob/living/carbon/human/H)
	return damage_overlays

/decl/species/proc/get_damage_mask(var/mob/living/carbon/human/H)
	return damage_mask

/decl/species/proc/get_examine_name(var/mob/living/carbon/human/H)
	return name

/decl/species/proc/get_icobase(var/mob/living/carbon/human/H, var/get_deform)
	return (get_deform ? deform : icobase)

/decl/species/proc/get_station_variant()
	return name

/decl/species/proc/get_icon_cache_uid(var/mob/H)
	if(!icon_cache_uid)
		icon_cache_uid = "[sequential_id(/decl/species)]"
	return icon_cache_uid

/decl/species/proc/get_bodytype(var/mob/living/carbon/human/H)
	return bodytype

/decl/species/proc/get_knockout_message(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "encounters a hardware fault and suddenly reboots!" : knockout_message)

/decl/species/proc/get_death_message(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "gives one shrill beep before falling lifeless." : death_message)

/decl/species/proc/get_ssd(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "flashing a 'system offline' glyph on their monitor" : show_ssd)

/decl/species/proc/get_blood_colour(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? SYNTH_BLOOD_COLOUR : blood_color)

/decl/species/proc/get_flesh_colour(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? SYNTH_FLESH_COLOUR : flesh_color)

/decl/species/proc/get_environment_discomfort(var/mob/living/carbon/human/H, var/msg_type)

	if(!prob(5))
		return

	var/covered = 0 // Basic coverage can help.
	var/held_items = H.get_held_items()
	for(var/obj/item/clothing/clothes in H)
		if(clothes in held_items)
			continue
		if((clothes.body_parts_covered & SLOT_UPPER_BODY) && (clothes.body_parts_covered & SLOT_LOWER_BODY))
			covered = 1
			break

	switch(msg_type)
		if("cold")
			if(!covered)
				to_chat(H, "<span class='danger'>[pick(cold_discomfort_strings)]</span>")
		if("heat")
			if(covered)
				to_chat(H, "<span class='danger'>[pick(heat_discomfort_strings)]</span>")

/decl/species/proc/get_vision_flags(var/mob/living/carbon/human/H)
	return vision_flags

/decl/species/proc/get_husk_icon(var/mob/living/carbon/human/H)
	return husk_icon

/decl/species/proc/get_sex(var/mob/living/carbon/H)
	return H.gender

/decl/species/proc/get_surgery_overlay_icon(var/mob/living/carbon/human/H)
	return 'icons/mob/surgery.dmi'

/decl/species/proc/get_footstep(var/mob/living/carbon/human/H, var/footstep_type)
	return

/decl/species/proc/get_brute_mod(var/mob/living/carbon/human/H)
	. = brute_mod

/decl/species/proc/get_burn_mod(var/mob/living/carbon/human/H)
	. = burn_mod

/decl/species/proc/get_toxins_mod(var/mob/living/carbon/human/H)
	. = toxins_mod

/decl/species/proc/get_radiation_mod(var/mob/living/carbon/human/H)
	. = (H && H.isSynthetic() ? 0.5 : radiation_mod)

/decl/species/proc/get_slowdown(var/mob/living/carbon/human/H)
	. = (H && H.isSynthetic() ? 0 : slowdown)

/decl/species/proc/get_root_species_name(var/mob/living/carbon/human/H)
	return name

/decl/species/proc/get_limb_from_zone(var/limb)
	. = length(LAZYACCESS(limb_mapping, limb)) ? pick(limb_mapping[limb]) : limb
