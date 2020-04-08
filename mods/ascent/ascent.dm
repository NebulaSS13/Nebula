#define BODYTYPE_SNAKE        "Snakelike Body"
#define BODYTYPE_MANTID_SMALL "Small Mantid Body"
#define BODYTYPE_MANTID_LARGE "Large Mantid Body"

#define CULTURE_ASCENT           "The Ascent"
#define HOME_SYSTEM_KHARMAANI    "Core"
#define FACTION_ASCENT_GYNE      "Ascent Gyne"
#define FACTION_ASCENT_ALATE     "Ascent Alate"
#define FACTION_ASCENT_SERPENTID "Ascent Serpentid"
#define RELIGION_KHARMAANI       "Nest-Lineage Veneration"

#define MODE_HUNTER  "hunter"
#define IS_MANTID    "mantid"
#define IS_SERPENTID "serpentid"

#define MANTIDIFY(_thing, _name, _desc) \
##_thing/ascent/name = _name; \
##_thing/ascent/desc = "Some kind of strange alien " + _desc + " technology."; \
##_thing/ascent/color = COLOR_PURPLE;

#define ALL_ASCENT_SPECIES list(/decl/species/mantid, /decl/species/mantid/gyne, /decl/species/serpentid)

/decl/modpack/ascent
	name = "The Ascent"