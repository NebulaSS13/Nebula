#define SPECIES_SERPENTID      "Serpentid"
#define SPECIES_MANTID_ALATE   "Kharmaan Alate"
#define SPECIES_MANTID_GYNE    "Kharmaan Gyne"
#define SPECIES_MANTID_NYMPH   "Kharmaan Nymph"

#define BODYTYPE_SNAKE "Snakelike Body"
#define BODYTYPE_NYMPH	"Small Nymph Body"
#define BODYTYPE_MANTID_SMALL "Small Mantid Body"
#define BODYTYPE_MANTID_LARGE "Large Mantid Body"

#define CULTURE_ASCENT           "The Ascent"
#define HOME_SYSTEM_KHARMAANI    "Core"
#define FACTION_ASCENT_NYMPH     "Ascent Nymph"
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

#define ALL_ASCENT_SPECIES list(SPECIES_MANTID_ALATE, SPECIES_MANTID_GYNE, SPECIES_SERPENTID)

/decl/modpack/ascent
	name = "The Ascent"