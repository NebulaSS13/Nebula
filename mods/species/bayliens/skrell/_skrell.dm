#define SPECIES_SKRELL "Skrell"
#define BODYTYPE_SKRELL "skrellian body"

/mob/living/carbon/human/skrell/Initialize(mapload, species_name, datum/dna/new_dna, decl/bodytype/new_bodytype)
	. = ..(mapload, SPECIES_SKRELL, dna, new_bodytype)