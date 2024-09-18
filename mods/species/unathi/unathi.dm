#define SPECIES_UNATHI   "Unathi"
#define LANGUAGE_UNATHI "Sinta'unathi"

/decl/modpack/unathi
	name = "Unathi"

/decl/modpack/unathi/pre_initialize()
	..()
	SSmodpacks.default_submap_whitelisted_species |= SPECIES_UNATHI

/mob/living/human/unathi/Initialize(mapload, species_name, datum/mob_snapshot/supplied_appearance)
	species_name = SPECIES_UNATHI
	. = ..()
