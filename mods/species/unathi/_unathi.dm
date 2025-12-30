#define LANGUAGE_LIZARD "Sinta'unathi"

/decl/modpack/unathi
	name = "Unathi Species"
	tabloid_headlines = list(
		"SHOCKING FIGURES REVEAL MORE TEENS DIE TO UNATHI HONOUR DUELS THAN GUN VIOLENCE",
		"LOCAL UNATHI SYMPATHIZER: 'I really think you should stop with these spacebaiting articles.'",
		"DO UNATHI SYMPATHIZERS HATE THE HUMAN RACE?"
	)

/decl/modpack/unathi/pre_initialize()
	..()
	SSmodpacks.default_submap_whitelisted_species |= /decl/species/unathi::uid

/mob/living/human/unathi/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	species_uid = /decl/species/unathi::uid
	. = ..()
