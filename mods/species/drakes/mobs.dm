/mob/living/human/grafadreka/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	species_uid = /decl/species/grafadreka::uid
	. = ..()

/mob/living/human/grafadreka/hatchling/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	. = ..()
	set_bodytype(/decl/bodytype/quadruped/grafadreka/hatchling)
