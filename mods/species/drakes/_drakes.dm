#define SPECIES_GRAFADREKA            "Grafadreka"
#define BODYTYPE_GRAFADREKA           "drake body"
#define BODYTYPE_GRAFADREKA_HATCHLING "hatchling drake body"
#define BP_DRAKE_GIZZARD              "drake gizzard"

/decl/modpack/grafadreka
	name = "Grafadreka Species"

/mob/living/carbon/human/grafadreka/Initialize(mapload)
	. = ..(mapload, SPECIES_GRAFADREKA)
