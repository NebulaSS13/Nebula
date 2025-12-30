/decl/modpack/skrell
	name = "Skrell Species"
	tabloid_headlines = list(
		"TENTACLES OF TERROR: SKRELL BLACK OPS SEIGE NYX NAVAL DEPOT. SHOCKING PHOTOGRAPHS INSIDE!",
		"LOCAL MAN HAS SEIZURE AFTER SAYING SKRELLIAN NAME; FORCED ASSIMILATION SOON?"
	)

/decl/modpack/skrell/pre_initialize()
	..()
	SSmodpacks.default_submap_whitelisted_species |= /decl/species/skrell::uid

/mob/living/human/skrell/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	species_uid = /decl/species/skrell::uid
	. = ..()
