#ifndef CONTENT_PACKAGE_SPACEMEN
#define CONTENT_PACKAGE_SPACEMEN

// SS13/spacetech related concepts.
/decl/content_package/spacemen
	credits_topics = list("SPACE", "ANCIENT AMERICAN CARTOONS", "SPACEBALL", "DECOMPRESSION PROCEDURES", "XENIC SENSITIVITY", "RADIATION PROTECTION", "XENO MATING RITUALS", "CARBON MONOXIDE")
	dreams = list(
		"deep space",                 "blinking lights",         "pirates",            "mercenaries",
		"a beaker of strange liquid", "space",                   "the supermatter",    "a stowaway",
		"a toolbox",                  "the engine",              "a monkey",           "a gun",
		"a ruined station",           "a planet",                "phoron",             "the medical bay",
		"the bridge",                 "an abandoned laboratory", "an ID card",         "the holodeck",
		"a crewmember",               "an operating table",      "the AI core")
	credits_other = list(
		"SEX BOMB", "GUNS, GUNS EVERYWHERE", "THE LITTLEST ARMALIS", "HUNT FOR THE GREEN WEENIE",
		"WHAT HAPPENS WHEN YOU MIX MAINTENANCE DRONES AND COMMERCIAL-GRADE PACKING FOAM",
		"ALIEN VS VENDOMAT", "SPACE TRACK")
	credits_crew_names = list("THE CREW")
	credits_nouns = list("SPACEMEN", "THE VENDOMAT PRICES", "THE SUPERMATTER CRYSTAL")

/decl/content_package/spacemen/Initialize()
	credits_other += "THE LEGEND OF THE ALIEN ARTIFACT: PART [pick("I","II","III","IV","V","VI","VII","VIII","IX", "X", "C","M","L")]"
	return ..()
#endif