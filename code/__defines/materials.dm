// defaults
#define DEFAULT_WALL_MATERIAL       /decl/material/solid/metal/steel
#define DEFAULT_FURNITURE_MATERIAL  /decl/material/solid/metal/aluminium

#define MAT_FLAG_ALTERATION_NONE    BITFLAG(0)
#define MAT_FLAG_ALTERATION_NAME    BITFLAG(1)
#define MAT_FLAG_ALTERATION_DESC    BITFLAG(2)
#define MAT_FLAG_ALTERATION_COLOR   BITFLAG(3)
#define MAT_FLAG_ALTERATION_ALL     (~MAT_FLAG_ALTERATION_NONE)

#define MAT_FLAG_UNMELTABLE         BITFLAG(0)
#define MAT_FLAG_BRITTLE            BITFLAG(1)
#define MAT_FLAG_PADDING            BITFLAG(2)
#define MAT_FLAG_FUSION_FUEL        BITFLAG(3)

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

//Stack flags
#define USE_MATERIAL_COLOR          BITFLAG(0)
#define USE_MATERIAL_SINGULAR_NAME  BITFLAG(1)
#define USE_MATERIAL_PLURAL_NAME    BITFLAG(2)

//Arbitrary hardness thresholds
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

#define STRUCTURE_BRITTLE_MATERIAL_DAMAGE_MULTIPLIER 4 // Amount table damage is multiplied by if it is made of a brittle material (e.g. glass)

#define ORE_SURFACE  "surface minerals"
#define ORE_PRECIOUS "precious metals"
#define ORE_NUCLEAR  "nuclear fuel"
#define ORE_EXOTIC   "exotic matter"
