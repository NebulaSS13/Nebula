#define SPECIES_SKRELL   "Skrell"

/decl/modpack/skrell
	name = "Skrell"

/decl/modpack/skrell/pre_initialize()
	..()
	SSmodpacks.default_submap_whitelisted_species |= SPECIES_SKRELL

/mob/living/human/skrell/Initialize(mapload, species_name, datum/mob_snapshot/supplied_appearance)
	species_name = SPECIES_SKRELL
	. = ..()
