#define SPECIES_CORVID           "Neo-Corvid"
#define BODYTYPE_CORVID          "corvid body"
#define IS_CORVID                "corvid"

/decl/modpack/neocorvids
	name = "Neocorvid Content"

/datum/robolimb/New()
	..()
	LAZYDISTINCTADD(bodytypes_cannot_use, BODYTYPE_CORVID)
