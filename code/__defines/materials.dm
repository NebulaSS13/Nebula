// defaults
#define DEFAULT_WALL_MATERIAL       /decl/material/solid/metal/steel
#define DEFAULT_FURNITURE_MATERIAL  /decl/material/solid/metal/aluminium

#define MAT_FLAG_ALTERATION_NONE    0
#define MAT_FLAG_ALTERATION_NAME    BITFLAG(0)
#define MAT_FLAG_ALTERATION_DESC    BITFLAG(1)
#define MAT_FLAG_ALTERATION_COLOR   BITFLAG(2)
#define MAT_FLAG_ALTERATION_ALL     (~MAT_FLAG_ALTERATION_NONE)

#define MAT_FLAG_UNMELTABLE         BITFLAG(0)
#define MAT_FLAG_BRITTLE            BITFLAG(1)
#define MAT_FLAG_PADDING            BITFLAG(2)
#define MAT_FLAG_FUSION_FUEL        BITFLAG(3)
#define MAT_FLAG_FISSIBLE           BITFLAG(4)	// This material has use in a fission reactor.

#define SHARD_SHARD                 "shard"
#define SHARD_SHRAPNEL              "shrapnel"
#define SHARD_STONE_PIECE           "piece"
#define SHARD_SPLINTER              "splinters"
#define SHARD_NONE                  ""

//Arbitrary weight thresholds
#define MAT_VALUE_EXTREMELY_LIGHT	 10		// fabric tier
#define MAT_VALUE_VERY_LIGHT         30		// glass tier
#define MAT_VALUE_LIGHT              40		// titanium tier
#define MAT_VALUE_NORMAL             50		// steel tier
#define MAT_VALUE_HEAVY              70		// silver tier
#define MAT_VALUE_VERY_HEAVY         80		// uranium tier

//Construction difficulty
#define MAT_VALUE_EASY_DIY          0
#define MAT_VALUE_NORMAL_DIY        1
#define MAT_VALUE_HARD_DIY          2
#define MAT_VALUE_VERY_HARD_DIY     3

//Arbitrary hardness thresholds
#define MAT_VALUE_MALLEABLE          0
#define MAT_VALUE_SOFT              10
#define MAT_VALUE_FLEXIBLE          20
#define MAT_VALUE_RIGID             40
#define MAT_VALUE_HARD              60
#define MAT_VALUE_VERY_HARD         80

// Arbitrary reflectiveness thresholds
#define MAT_VALUE_DULL              10
#define MAT_VALUE_MATTE             20
#define MAT_VALUE_SHINY             40
#define MAT_VALUE_VERY_SHINY        60
#define MAT_VALUE_MIRRORED          80

// Wall layering flags
#define PAINT_PAINTABLE BITFLAG(0)
#define PAINT_STRIPABLE BITFLAG(1)
#define PAINT_DETAILABLE BITFLAG(2)
#define PAINT_WINDOW_PAINTABLE BITFLAG(3)
#define WALL_HAS_EDGES BITFLAG(4)

#define STRUCTURE_BRITTLE_MATERIAL_DAMAGE_MULTIPLIER 4 // Amount table damage is multiplied by if it is made of a brittle material (e.g. glass)

#define ORE_SURFACE  "surface minerals"
#define ORE_PRECIOUS "precious metals"
#define ORE_NUCLEAR  "nuclear fuel"
#define ORE_EXOTIC   "exotic matter"

//Phase of matter placeholders
#define MAT_PHASE_SOLID     BITFLAG(0)
#define MAT_PHASE_LIQUID    BITFLAG(1)
#define MAT_PHASE_GAS       BITFLAG(2)
#define MAT_PHASE_PLASMA    BITFLAG(3)

// Fission interactions.
// For these, associated value is ideal neutron energy for reaction.
#define INTERACTION_FISSION        "fission"
#define INTERACTION_ABSORPTION     "absorption"
#define INTERACTION_SCATTER        "scatter"

#define MAT_RARITY_NOWHERE  0
#define MAT_RARITY_EXOTIC   5
#define MAT_RARITY_UNCOMMON 10
#define MAT_RARITY_MUNDANE  20
