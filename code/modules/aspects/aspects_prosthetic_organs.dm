/decl/aspect/prosthetic_organ
	name = "Prosthetic Heart"
	aspect_flags = ASPECTS_PHYSICAL
	desc = "You have a synthetic heart."
	aspect_cost = 1
	category = "Prosthetic Organs"
	sort_value = 2
	var/apply_to_organ = BP_HEART

/decl/aspect/prosthetic_organ/is_available_to(datum/preferences/pref)
	. = ..()
	if(. && pref.bodytype && pref.species)
		var/decl/species/species = global.all_species[pref.species]
		if(istype(species))
			var/decl/bodytype/bodytype = species.get_bodytype_by_name(pref.bodytype)
			return bodytype && (apply_to_organ in bodytype.has_organs) && !(species.species_flags & SPECIES_NO_ROBOTIC_INTERNAL_ORGANS)

/decl/aspect/prosthetic_organ/applies_to_organ(var/organ)
	return apply_to_organ && organ == apply_to_organ

/decl/aspect/prosthetic_organ/apply(var/mob/living/carbon/human/holder)
	. = ..()
	if(.)
		var/obj/item/organ/internal/I = GET_INTERNAL_ORGAN(holder, apply_to_organ)
		if(istype(I))
			I.robotize()

/decl/aspect/prosthetic_organ/eyes
	name = "Prosthetic Eyes"
	desc = "Your vision is augmented."
	apply_to_organ = BP_EYES
	incompatible_with = list(
		/decl/aspect/handicap/impaired_vision,
		/decl/aspect/handicap/colourblind,
		/decl/aspect/handicap/colourblind/protanopia,
		/decl/aspect/handicap/colourblind/tritanopia,
		/decl/aspect/handicap/colourblind/achromatopsia
	)

/decl/aspect/prosthetic_organ/kidneys
	name = "Prosthetic Kidneys"
	desc = "You have synthetic kidneys."
	apply_to_organ = BP_KIDNEYS

/decl/aspect/prosthetic_organ/liver
	name = "Prosthetic Liver"
	desc = "You have a literal iron liver."
	apply_to_organ = BP_LIVER

/decl/aspect/prosthetic_organ/lungs
	name = "Prosthetic Lungs"
	desc = "You have synthetic lungs."
	apply_to_organ = BP_LUNGS

/decl/aspect/prosthetic_organ/stomach
	name = "Prosthetic Stomach"
	desc = "You have a literal iron stomach."
	apply_to_organ = BP_STOMACH
