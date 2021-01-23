#define SPECIES_CORVID           "Neo-Corvid"
#define BODYTYPE_CORVID          "Corvid Body"
#define IS_CORVID                "corvid"

/decl/modpack/neocorvids
	name = "Neocorvid Content"

/decl/modpack/neocorvids/initialize()
	. = ..()
	LAZYSET(global.holder_mob_icons, lowertext(SPECIES_CORVID), 'mods/species/neocorvids/icons/holder.dmi')

/datum/robolimb/New()
	..()
	LAZYDISTINCTADD(bodytypes_cannot_use, BODYTYPE_CORVID)
