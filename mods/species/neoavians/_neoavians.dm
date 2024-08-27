#define SPECIES_AVIAN            "Neo-Avian"
#define BODYTYPE_AVIAN           "avian body"
#define BODY_EQUIP_FLAG_AVIAN    BITFLAG(6)

/decl/modpack/neoavians
	name = "Teshari Content"

/decl/modpack/neoavians/pre_initialize()
	..()
	SSmodpacks.default_submap_whitelisted_species |= SPECIES_AVIAN
