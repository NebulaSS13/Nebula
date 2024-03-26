#define SPECIES_SKRELL "Skrell"

/mob/living/carbon/human/skrell/Initialize(mapload, species_name, datum/dna/new_dna, decl/bodytype/new_bodytype)
	species_name = SPECIES_SKRELL
	. = ..()