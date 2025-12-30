/mob/living/human/skeleton/meredrake/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	if(!species_uid)
		species_uid = /decl/species/grafadreka::uid
	. = ..()

/mob/living/human/zombie/meredrake/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	if(!species_uid)
		species_uid = /decl/species/grafadreka::uid
	. = ..()
