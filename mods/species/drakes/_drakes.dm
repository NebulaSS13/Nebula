#define SPECIES_GRAFADREKA            "Grafadreka"
#define BODYTYPE_GRAFADREKA           "drake body"
#define BODYTYPE_GRAFADREKA_HATCHLING "hatchling drake body"
#define BP_DRAKE_GIZZARD              "drake gizzard"

/decl/modpack/grafadreka
	name = "Grafadreka Species"

/obj/item/backpack/setup_sprite_sheets()
	. = ..()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_GRAFADREKA]           = 'mods/species/drakes/icons/clothing/backpack.dmi'
	sprite_sheets[BODYTYPE_GRAFADREKA_HATCHLING] = 'mods/species/drakes/icons/clothing/hatchling_backpack.dmi'

/obj/item/card/id/setup_sprite_sheets()
	. = ..()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_GRAFADREKA]           = 'mods/species/drakes/icons/clothing/id.dmi'
	sprite_sheets[BODYTYPE_GRAFADREKA_HATCHLING] = 'mods/species/drakes/icons/clothing/hatchling_id.dmi'

/mob/living/carbon/human/grafadreka/Initialize(mapload)
	. = ..(mapload, SPECIES_GRAFADREKA)
