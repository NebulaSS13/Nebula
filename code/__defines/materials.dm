#define MAT_PLASTIC                 "plastic"
#define MAT_PLASTEEL                "plasteel"
#define MAT_STEEL                   "steel"
#define MAT_GLASS                   "glass"
#define MAT_GOLD                    "gold"
#define MAT_SILVER                  "silver"
#define MAT_DIAMOND                 "diamond"
#define MAT_PHORON                  "phoron"
#define MAT_URANIUM                 "uranium"
#define MAT_CRYSTAL                 "crystal"
#define MAT_SANDSTONE               "sandstone"
#define MAT_CONCRETE                "concrete"
#define MAT_IRON                    "iron"
#define MAT_PLATINUM                "platinum"
#define MAT_BRONZE                  "bronze"
#define MAT_PHORON_GLASS            "phglass"
#define MAT_REINFORCED_PHORON_GLASS "rphglass"
#define MAT_MARBLE                  "marble"
#define MAT_CULT                    "cult"
#define MAT_REINFORCED_CULT         "cult2"
#define MAT_VOX                     "voxalloy"
#define MAT_TITANIUM                "titanium"
#define MAT_RUTILE                  "rutile"
#define MAT_OSMIUM_CARBIDE_PLASTEEL "osmium-carbide plasteel"
#define MAT_OSMIUM                  "osmium"
#define MAT_HYDROGEN                "hydrogen"
#define MAT_METALLIC_HYDROGEN       "mhydrogen"
#define MAT_WASTE                   "waste"
#define MAT_ELEVATORIUM             "elevatorium"
#define MAT_ALIENALLOY              "aliumium"
#define MAT_SAND                    "sand"
#define MAT_GRAPHITE                "graphite"
#define MAT_DEUTERIUM               "deuterium"
#define MAT_TRITIUM                 "tritium"
#define MAT_SUPERMATTER             "supermatter"
#define MAT_PITCHBLENDE             "pitchblende"
#define MAT_HEMATITE                "hematite"
#define MAT_QUARTZ                  "quartz"
#define MAT_PYRITE                  "pyrite"
#define MAT_SPODUMENE               "spodumene"
#define MAT_CINNABAR                "cinnabar"
#define MAT_PHOSPHORITE             "phosphorite"
#define MAT_ROCK_SALT               "rock salt"
#define MAT_POTASH                  "potash"
#define MAT_BAUXITE                 "bauxite"
#define MAT_COPPER                  "copper"
#define MAT_CARDBOARD               "cardboard"
#define MAT_CLOTH                   "cloth"
#define MAT_CARPET                  "carpet"
#define MAT_ALUMINIUM               "aluminium"
#define MAT_NULLGLASS               "nullglass"
#define MAT_HYDROGEN                "hydrogen"
#define MAT_BORON                   "boron"
#define MAT_LITHIUM                 "lithium"
#define MAT_OXYGEN                  "oxygen"
#define MAT_HELIUM                  "helium"

// gasses
#define MAT_CO2                     "carbon_dioxide"
#define MAT_CO                      "carbon_monoxide"
#define MAT_METHYL_BROMIDE          "methyl_bromide"
#define MAT_N2O                     "sleeping_agent"
#define MAT_NITROGEN                "nitrogen"
#define MAT_NO2                     "nitrodioxide"
#define MAT_NO                      "nitricoxide"
#define MAT_METHANE                 "methane"
#define MAT_ALIEN                   "aliether"
#define MAT_ARGON                   "argon"
#define MAT_KRYPTON                 "krypton"
#define MAT_NEON                    "neon"
#define MAT_XENON                   "xenon"
#define MAT_AMMONIA                 "ammonia"
#define MAT_CHLORINE                "chlorine"
#define MAT_SULFUR                  "sulfurdioxide"
#define MAT_STEAM                   "water"

//woods
#define MAT_WOOD                    "wood"
#define MAT_MAHOGANY                "mahogany"
#define MAT_MAPLE                   "maple"
#define MAT_EBONY                   "ebony"
#define MAT_WALNUT                  "walnut"
#define MAT_BAMBOO                  "bamboo"
#define MAT_YEW                     "yew"

// skins and bones
#define MAT_SKIN_GENERIC            "skin"
#define MAT_SKIN_LIZARD             "lizardskin"
#define MAT_SKIN_CHITIN             "chitin"
#define MAT_SKIN_FUR                "brown fur"
#define MAT_SKIN_FUR_GRAY           "gray fur"
#define MAT_SKIN_FUR_WHITE          "white fur"
#define MAT_SKIN_GOATHIDE           "goathide"
#define MAT_SKIN_COWHIDE            "cowhide"
#define MAT_SKIN_SHARK              "sharkskin"
#define MAT_SKIN_FISH               "fishskin"
#define MAT_SKIN_FUR_ORANGE         "orange fur"
#define MAT_SKIN_FUR_BLACK          "black fur"
#define MAT_SKIN_FUR_HEAVY          "heavy fur"
#define MAT_SKIN_FISH_PURPLE        "purple fishskin"
#define MAT_SKIN_FEATHERS           "white feathers"
#define MAT_SKIN_FEATHERS_PURPLE    "purple feathers"
#define MAT_SKIN_FEATHERS_BLUE      "blue feathers"
#define MAT_SKIN_FEATHERS_GREEN     "green feathers"
#define MAT_SKIN_FEATHERS_BROWN     "brown feathers"
#define MAT_SKIN_FEATHERS_RED       "red feathers"
#define MAT_SKIN_FEATHERS_BLACK     "black feathers"

#define MAT_BONE_GENERIC            "bone"
#define MAT_BONE_CARTILAGE          "cartilage"
#define MAT_BONE_FISH               "fishbone"

#define MAT_LEATHER_GENERIC         "leather"
#define MAT_LEATHER_LIZARD          "scaled hide"
#define MAT_LEATHER_FUR             "furred hide"
#define MAT_LEATHER_CHITIN          "treated chitin"

// defaults
#define DEFAULT_WALL_MATERIAL       MAT_STEEL
#define DEFAULT_FURNITURE_MATERIAL  MAT_ALUMINIUM

#define MAT_FLAG_ALTERATION_NONE    0x1
#define MAT_FLAG_ALTERATION_NAME    0x2
#define MAT_FLAG_ALTERATION_DESC    0x4
#define MAT_FLAG_ALTERATION_COLOR   0x8
#define MAT_FLAG_ALTERATION_ALL     (~MAT_FLAG_ALTERATION_NONE)

#define MAT_FLAG_UNMELTABLE         0x1
#define MAT_FLAG_BRITTLE            0x2
#define MAT_FLAG_PADDING            0x4

#define SHARD_SHARD                 "shard"
#define SHARD_SHRAPNEL              "shrapnel"
#define SHARD_STONE_PIECE           "piece"
#define SHARD_SPLINTER              "splinters"
#define SHARD_NONE                  ""

//Weight thresholds
#define MAT_FLAG_HEAVY              24
#define MAT_FLAG_LIGHT              18

//Construction difficulty
#define MAT_VALUE_EASY_DIY          0
#define MAT_VALUE_NORMAL_DIY        1
#define MAT_VALUE_HARD_DIY          2
#define MAT_VALUE_VERY_HARD_DIY     3

//Stack flags
#define USE_MATERIAL_COLOR          0x1
#define USE_MATERIAL_SINGULAR_NAME  0x2
#define USE_MATERIAL_PLURAL_NAME    0x4

//Arbitrary hardness thresholds
#define  MAT_VALUE_SOFT             10
#define  MAT_VALUE_FLEXIBLE         20
#define  MAT_VALUE_RIGID            40
#define  MAT_VALUE_HARD             60
#define  MAT_VALUE_VERY_HARD        80

#define TABLE_BRITTLE_MATERIAL_MULTIPLIER 4 // Amount table damage is multiplied by if it is made of a brittle material (e.g. glass)
