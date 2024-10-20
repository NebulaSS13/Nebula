#define SPECIES_PROMETHEAN   "Promethean"

/decl/modpack/promethean
	name = "Promethean"

/decl/modpack/promethean/pre_initialize()
	..()
	SSmodpacks.default_submap_whitelisted_species |= SPECIES_PROMETHEAN

/mob/living/human/promethean/Initialize(mapload, species_name, datum/mob_snapshot/supplied_appearance)
	species_name = SPECIES_PROMETHEAN
	. = ..()
