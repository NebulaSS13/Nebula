#define SPECIES_AVIAN            "Neo-Avian"
#define BODYTYPE_AVIAN           "avian body"
#define IS_AVIAN                 "avian"

/decl/modpack/neoavians
	name = "Neo-Avian Content"

/decl/prosthetics_manufacturer/Initialize()
	. = ..()
	LAZYDISTINCTADD(bodytypes_cannot_use, BODYTYPE_AVIAN)
