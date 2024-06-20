#define SPECIES_GRAFADREKA            "Grafadreka"
#define BODYTYPE_GRAFADREKA           "drake body"
#define BODYTYPE_GRAFADREKA_HATCHLING "hatchling drake body"
#define BP_DRAKE_GIZZARD              "drake gizzard"

/decl/modpack/grafadreka
	name = "Grafadreka Species"

/mob/living/human/grafadreka/Initialize(mapload, species_name, datum/mob_snapshot/supplied_appearance)
	// fantasy modpack overrides drake name, so can't use the #define
	var/decl/species/grafadreka/drakes = GET_DECL(/decl/species/grafadreka)
	. = ..(mapload, drakes.name)
