#define SPECIES_LIZARD  "Lizard"
#define LANGUAGE_LIZARD "Lizard Language"
#define IS_LIZARD       "lizard"

/decl/modpack/lizard
	name = "Lizard"

/mob/living/carbon/human/lizard/Initialize(mapload)
	..(mapload, SPECIES_LIZARD)
