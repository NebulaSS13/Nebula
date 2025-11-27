#define BODYTYPE_AVIAN           "avian body"
#define BODY_EQUIP_FLAG_AVIAN    BITFLAG(6)

/decl/modpack/teshari
	name = "Teshari Species"

/decl/modpack/teshari/pre_initialize()
	..()
	SSmodpacks.default_submap_whitelisted_species |= /decl/species/teshari::uid
