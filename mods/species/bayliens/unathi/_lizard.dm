#define SPECIES_LIZARD  "Unathi"
#define LANGUAGE_LIZARD "Sinta'unathi"

/mob/living/carbon/human/lizard/Initialize(mapload, species_name, datum/dna/new_dna, decl/bodytype/new_bodytype)
	. = ..(mapload, SPECIES_LIZARD, dna, new_bodytype)
