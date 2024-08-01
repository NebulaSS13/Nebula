#define LANGUAGE_LIZARD "Sinta'unathi"

/mob/living/carbon/human/lizard/Initialize(mapload, species_name, datum/dna/new_dna, decl/bodytype/new_bodytype)
	species_name = SPECIES_LIZARD
	. = ..()
