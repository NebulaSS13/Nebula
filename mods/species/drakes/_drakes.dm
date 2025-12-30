#define BODYTYPE_GRAFADREKA           "drake body"
#define BODYTYPE_GRAFADREKA_HATCHLING "hatchling drake body"
#define BP_DRAKE_GIZZARD              "drake gizzard"

/decl/modpack/grafadreka
	name = "Grafadreka Species"

/mob/living/human/grafadreka/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	species_uid = /decl/species/grafadreka::uid
	. = ..()
