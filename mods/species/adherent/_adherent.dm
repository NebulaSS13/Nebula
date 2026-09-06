#define LANGUAGE_ADHERENT "Protocol"
#define BP_FLOAT        "floatation disc"
#define BP_JETS         "maneuvering jets"
#define BP_COOLING_FINS "cooling fins"

#define BODYTYPE_ADHERENT "adherent body"

/decl/modpack/adherent
	name = "Adherent Species"

/decl/modpack/adherent/pre_initialize()
	..()
	SSmodpacks.default_submap_whitelisted_species |= /decl/species/adherent::uid

/mob/living/human/adherent/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	species_uid = /decl/species/adherent::uid
	. = ..()
