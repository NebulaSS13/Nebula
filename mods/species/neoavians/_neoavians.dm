#define SPECIES_AVIAN            "Neo-Avian"
#define BODYTYPE_AVIAN           "avian body"
#define IS_AVIAN                 "avian"

/decl/modpack/neoavians
	name = "Neo-Avian Content"

/decl/modpack/neoavians/initialize()
	. = ..()
	LAZYSET(global.holder_mob_icons, lowertext(SPECIES_AVIAN), 'mods/species/neoavians/icons/holder.dmi')

/decl/prosthetics_manufacturer/New()
	..()
	LAZYDISTINCTADD(bodytypes_cannot_use, BODYTYPE_AVIAN)
