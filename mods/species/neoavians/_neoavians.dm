#define SPECIES_AVIAN            "Neo-Avian"
#define BODYTYPE_AVIAN           "avian body"
#define IS_AVIAN                 "avian"
#define BODYTYPE_EQUIP_FLAG_AVIAN          BITFLAG(6)

/decl/modpack/neoavians
	name = "Neo-Avian Content"

/decl/bodytype/prosthetic/Initialize()
	. = ..()
	LAZYDISTINCTADD(bodytypes_cannot_use, BODYTYPE_AVIAN)
