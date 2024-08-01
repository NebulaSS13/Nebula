#define BODYTYPE_ADHERENT "adherent body"
#define LANGUAGE_ADHERENT "Protocol"

#define BP_FLOAT        "floatation disc"
#define BP_JETS         "maneuvering jets"
#define BP_COOLING_FINS "cooling fins"

/mob/living/human/adherent/Initialize(mapload, species_name, datum/mob_snapshot/supplied_appearance)
	species_name = SPECIES_ADHERENT
	. = ..()