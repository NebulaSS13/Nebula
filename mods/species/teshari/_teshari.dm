#define SPECIES_AVIAN            "Teshari"
#define BODYTYPE_AVIAN           "teshari body"
#define BODY_FLAG_AVIAN          BITFLAG(6)

/decl/modpack/neoavians
	name = "Teshari Content"

/decl/modpack/neoavians/pre_initialize()
	..()
	SSmodpacks.default_submap_whitelisted_species |= SPECIES_AVIAN
