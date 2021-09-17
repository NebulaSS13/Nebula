#define SPECIES_AVIAN            "Neo-Avian"
#define BODYTYPE_AVIAN           "avian body"
#define IS_AVIAN                 "avian"
#define BODY_FLAG_AVIAN          BITFLAG(6)

/decl/modpack/neoavians
	name = "Neo-Avian Content"

/decl/prosthetics_manufacturer/Initialize()
	. = ..()
	LAZYDISTINCTADD(bodytypes_cannot_use, BODYTYPE_AVIAN)
