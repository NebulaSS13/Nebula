#define SPECIES_LIZARD  "Unathi"
#define LANGUAGE_LIZARD "Sinta'unathi"

/mob/living/human/lizard/Initialize(mapload, species_name, datum/dna/new_dna, decl/bodytype/new_bodytype)
	species_name = SPECIES_LIZARD
	. = ..()
