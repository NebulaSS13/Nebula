/decl/modpack/vatborn
	name = "Vatborn"

/decl/modpack/vatborn/pre_initialize()
	..()
	SSmodpacks.default_submap_whitelisted_species |= /decl/species/human/vatborn::uid

/mob/living/human/vatborn/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	species_uid = /decl/species/human/vatborn::uid
	. = ..()
