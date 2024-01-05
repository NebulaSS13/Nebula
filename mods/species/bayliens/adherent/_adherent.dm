#define SPECIES_ADHERENT  "Adherent"
#define BODYTYPE_ADHERENT "adherent body"
#define LANGUAGE_ADHERENT "Protocol"

#define BP_FLOAT        "floatation disc"
#define BP_JETS         "maneuvering jets"
#define BP_COOLING_FINS "cooling fins"

/mob/living/carbon/human/adherent/Initialize()
	. = ..(species_name = SPECIES_ADHERENT)