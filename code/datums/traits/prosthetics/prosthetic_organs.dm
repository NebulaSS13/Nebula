/decl/trait/prosthetic_organ
	name = "Prosthetic Heart"
	description = "You have a synthetic heart."
	trait_cost = 1
	available_at_chargen = TRUE
	available_at_map_tech = MAP_TECH_LEVEL_SPACE
	category = "Prosthetic Organs"
	reapply_on_rejuvenation = TRUE
	var/synthetic_bodytype_restricted = FALSE
	var/apply_to_organ = BP_HEART

/decl/trait/prosthetic_organ/is_available_to(datum/preferences/pref)
	. = ..()
	if(. && pref.species && pref.bodytype)

		var/decl/species/mob_species = pref.get_species_decl()
		var/decl/bodytype/mob_bodytype = pref.get_bodytype_decl()

		if(!istype(mob_bodytype))
			return FALSE

		// Synthetic organs are generally unnecessary in FBPs as they have robotic innards regardless.
		if(synthetic_bodytype_restricted)
			if(!mob_bodytype.is_robotic)
				return FALSE
		else
			if(mob_bodytype.is_robotic)
				return FALSE

		if(!(apply_to_organ in mob_bodytype.has_organ))
			return FALSE

		if(mob_species.species_flags & SPECIES_NO_ROBOTIC_INTERNAL_ORGANS)
			return FALSE

		return TRUE

/decl/trait/prosthetic_organ/applies_to_organ(var/organ)
	return apply_to_organ && organ == apply_to_organ

/decl/trait/prosthetic_organ/apply_trait(mob/living/holder)
	. = ..()
	if(.)
		var/obj/item/organ/internal/I = GET_INTERNAL_ORGAN(holder, apply_to_organ)
		if(I)
			I.set_bodytype(I.species.base_internal_prosthetics_model)

/decl/trait/prosthetic_organ/eyes
	name = "Prosthetic Eyes"
	description = "Your vision is augmented."
	apply_to_organ = BP_EYES
	incompatible_with = list(
		/decl/trait/malus/impaired_vision,
		/decl/trait/malus/colourblind,
		/decl/trait/malus/colourblind/protanopia,
		/decl/trait/malus/colourblind/tritanopia,
		/decl/trait/malus/colourblind/achromatopsia
	)

/decl/trait/prosthetic_organ/kidneys
	name = "Prosthetic Kidneys"
	description = "You have synthetic kidneys."
	apply_to_organ = BP_KIDNEYS

/decl/trait/prosthetic_organ/liver
	name = "Prosthetic Liver"
	description = "You have a literal iron liver."
	apply_to_organ = BP_LIVER

/decl/trait/prosthetic_organ/lungs
	name = "Prosthetic Lungs"
	description = "You have synthetic lungs."
	apply_to_organ = BP_LUNGS

/decl/trait/prosthetic_organ/stomach
	name = "Prosthetic Stomach"
	description = "You have a literal iron stomach."
	apply_to_organ = BP_STOMACH

/decl/trait/prosthetic_organ/brain
	name = "Synthetic Brain"
	description = "You are an artificial lifeform, with a mind made of steel and light."
	apply_to_organ = BP_BRAIN
	synthetic_bodytype_restricted = TRUE
	var/new_brain_type = /obj/item/organ/internal/brain/robotic

/decl/trait/prosthetic_organ/brain/apply_trait(mob/living/holder)
	. = ..()
	if(.)
		var/obj/item/organ/external/affected
		var/obj/item/organ/internal/I = GET_INTERNAL_ORGAN(holder, apply_to_organ)
		if(I)
			affected = GET_EXTERNAL_ORGAN(holder, I.parent_organ)
			I.transfer_brainmob_with_organ = FALSE // we don't want to pull them out of the mob
			holder.remove_organ(I, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE)
			qdel(I)
		var/obj/item/organ/organ = new new_brain_type(holder)
		if(!affected)
			affected = GET_EXTERNAL_ORGAN(holder, organ.parent_organ)
		if(affected)
			holder.add_organ(organ, affected, TRUE, FALSE, FALSE, TRUE)
