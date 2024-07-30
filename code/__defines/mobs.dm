// /mob/var/stat things.
#define CONSCIOUS   0
#define UNCONSCIOUS 1
#define DEAD        2

// Bitflags defining which status effects could be or are inflicted on a mob.
#define CANSTUN      BITFLAG(0)
#define CANWEAKEN    BITFLAG(1)
#define CANPARALYSE  BITFLAG(2)
#define CANPUSH      BITFLAG(3)
#define PASSEMOTES   BITFLAG(4) // Mob has a holder inside of it that need to see emotes.
#define GODMODE      BITFLAG(5)
#define FAKEDEATH    BITFLAG(6)
#define NO_ANTAG     BITFLAG(7) // Players are restricted from gaining antag roles when occupying this mob
#define ENABLE_AI    BITFLAG(8) // Regardless of player control, the mob is using AI.

#define BORGMESON    BITFLAG(0)
#define BORGTHERM    BITFLAG(1)
#define BORGXRAY     BITFLAG(2)
#define BORGMATERIAL BITFLAG(3)

#define LEFT  BITFLAG(0)
#define RIGHT BITFLAG(1)
#define UNDER BITFLAG(2)

// Pulse levels, very simplified.
#define PULSE_NONE    0   // So !M.pulse checks would be possible.
#define PULSE_SLOW    1   // <60     bpm
#define PULSE_NORM    2   //  60-90  bpm
#define PULSE_FAST    3   //  90-120 bpm
#define PULSE_2FAST   4   // >120    bpm
#define PULSE_THREADY 5   // Occurs during hypovolemic shock
#define GETPULSE_HAND 0   // Less accurate. (hand)
#define GETPULSE_TOOL 1   // More accurate. (med scanner, sleeper, etc.)
#define PULSE_MAX_BPM 250 // Highest, readable BPM by machines and humans.

//intent flags
#define I_HELP		"help"
#define I_DISARM	"disarm"
#define I_GRAB		"grab"
#define I_HURT		"harm"

//These are used Bump() code for living mobs, in the mob_bump_flag, mob_swap_flags, and mob_push_flags vars to determine whom can bump/swap with whom.
#define HUMAN 1
#define MONKEY 2
#define ALIEN 4
#define ROBOT 8
#define SLIME 16
#define SIMPLE_ANIMAL 32
#define HEAVY 64
#define ALLMOBS (HUMAN|MONKEY|ALIEN|ROBOT|SLIME|SIMPLE_ANIMAL|HEAVY)

// Robot AI notifications
#define ROBOT_NOTIFICATION_NEW_UNIT 1
#define ROBOT_NOTIFICATION_NEW_NAME 2
#define ROBOT_NOTIFICATION_NEW_MODULE 3
#define ROBOT_NOTIFICATION_MODULE_RESET 4

// Appearance change flags
#define APPEARANCE_RACE              BITFLAG(0)
#define APPEARANCE_GENDER            BITFLAG(1)
#define APPEARANCE_BODY              BITFLAG(2)
#define APPEARANCE_SKIN              BITFLAG(3)
#define APPEARANCE_HAIR              BITFLAG(4)
#define APPEARANCE_HAIR_COLOR        BITFLAG(5)
#define APPEARANCE_FACIAL_HAIR       BITFLAG(6)
#define APPEARANCE_FACIAL_HAIR_COLOR BITFLAG(7)
#define APPEARANCE_EYE_COLOR         BITFLAG(8)
#define APPEARANCE_ALL_HAIR          (APPEARANCE_HAIR|APPEARANCE_HAIR_COLOR|APPEARANCE_FACIAL_HAIR|APPEARANCE_FACIAL_HAIR_COLOR)
#define APPEARANCE_ALL               (APPEARANCE_RACE|APPEARANCE_GENDER|APPEARANCE_BODY|APPEARANCE_SKIN|APPEARANCE_EYE_COLOR|APPEARANCE_ALL_HAIR)

// Click cooldown
#define DEFAULT_ATTACK_COOLDOWN 8 //Default timeout for aggressive actions
#define DEFAULT_QUICK_COOLDOWN  4

#define FAST_WEAPON_COOLDOWN 3
#define DEFAULT_WEAPON_COOLDOWN 5
#define SLOW_WEAPON_COOLDOWN 7

#define MIN_SUPPLIED_LAW_NUMBER 15
#define MAX_SUPPLIED_LAW_NUMBER 50

// Corporate alignment for the character
#define COMPANY_LOYAL 			"Loyal"
#define COMPANY_SUPPORTATIVE	"Supportive"
#define COMPANY_NEUTRAL 		"Neutral"
#define COMPANY_SKEPTICAL		"Skeptical"
#define COMPANY_OPPOSED			"Opposed"

#define COMPANY_ALIGNMENTS		list(COMPANY_LOYAL,COMPANY_SUPPORTATIVE,COMPANY_NEUTRAL,COMPANY_SKEPTICAL,COMPANY_OPPOSED)

// Defines mob sizes, used by lockers and to determine what is considered a small sized mob, etc.
#define MOB_SIZE_LARGE     40
#define MOB_SIZE_MEDIUM    20
#define MOB_SIZE_SMALL     10
#define MOB_SIZE_TINY      5
#define MOB_SIZE_MINISCULE 1

#define MOB_SIZE_MIN       MOB_SIZE_MINISCULE
#define MOB_SIZE_MAX       MOB_SIZE_LARGE

// Defines how strong the species is compared to humans. Think like strength in D&D
#define STR_VHIGH       2
#define STR_HIGH        1
#define STR_MEDIUM      0
#define STR_LOW        -1
#define STR_VLOW       -2

// Gluttony levels.
#define GLUT_TINY 1       // Eat anything tiny and smaller
#define GLUT_SMALLER 2    // Eat anything smaller than we are
#define GLUT_ANYTHING 4   // Eat anything, ever

#define GLUT_ITEM_TINY 8         // Eat items with a w_class of small or smaller
#define GLUT_ITEM_NORMAL 16      // Eat items with a w_class of normal or smaller
#define GLUT_ITEM_ANYTHING 32    // Eat any item
#define GLUT_PROJECTILE_VOMIT 64 // When vomitting, does it fly out?

// Devour speeds, returned by can_devour()
#define DEVOUR_SLOW 1
#define DEVOUR_FAST 2

#define TINT_NONE 0
#define TINT_MODERATE 1
#define TINT_HEAVY 2
#define TINT_BLIND 3

#define FLASH_PROTECTION_VULNERABLE -2
#define FLASH_PROTECTION_REDUCED -1
#define FLASH_PROTECTION_NONE 0
#define FLASH_PROTECTION_MINOR 1
#define FLASH_PROTECTION_MODERATE 2
#define FLASH_PROTECTION_MAJOR 3

#define ANIMAL_SPAWN_DELAY round(get_config_value(/decl/config/num/respawn_delay) / 6)
#define DRONE_SPAWN_DELAY  round(get_config_value(/decl/config/num/respawn_delay) / 3)

// Incapacitation flags, used by the mob/proc/incapacitated() proc
#define INCAPACITATION_NONE              0
#define INCAPACITATION_RESTRAINED        BITFLAG(0)
#define INCAPACITATION_BUCKLED_PARTIALLY BITFLAG(1)
#define INCAPACITATION_BUCKLED_FULLY     BITFLAG(2)
#define INCAPACITATION_STUNNED           BITFLAG(3)
#define INCAPACITATION_FORCELYING        BITFLAG(4) //needs a better name - represents being knocked down BUT still conscious.
#define INCAPACITATION_KNOCKOUT          BITFLAG(5)
#define INCAPACITATION_WEAKENED          BITFLAG(6)

#define INCAPACITATION_UNRESISTING (INCAPACITATION_KNOCKOUT|INCAPACITATION_STUNNED)
#define INCAPACITATION_DISRUPTED   (INCAPACITATION_UNRESISTING|INCAPACITATION_WEAKENED)
#define INCAPACITATION_KNOCKDOWN   (INCAPACITATION_KNOCKOUT|INCAPACITATION_FORCELYING)
#define INCAPACITATION_DISABLED    (INCAPACITATION_KNOCKDOWN|INCAPACITATION_STUNNED)
#define INCAPACITATION_DEFAULT     (INCAPACITATION_RESTRAINED|INCAPACITATION_BUCKLED_FULLY|INCAPACITATION_DISABLED)
#define INCAPACITATION_ALL         (~INCAPACITATION_NONE)

// Organs.
#define BP_EYES     "eyes"
#define BP_HEART    "heart"
#define BP_LUNGS    "lungs"
#define BP_TRACH	"tracheae"
#define BP_BRAIN    "brain"
#define BP_LIVER    "liver"
#define BP_KIDNEYS  "kidneys"
#define BP_STOMACH  "stomach"
#define BP_PLASMA   "plasma vessel"
#define BP_APPENDIX "appendix"
#define BP_CELL     "cell"
#define BP_HIVE     "hive node"
#define BP_NUTRIENT "nutrient vessel"
#define BP_ACID     "acid gland"
#define BP_EGG      "egg sac"
#define BP_RESIN    "resin spinner"
#define BP_STRATA   "neural strata"
#define BP_RESPONSE "response node"
#define BP_GBLADDER "gas bladder"
#define BP_POLYP    "polyp segment"
#define BP_ANCHOR   "anchoring ligament"
#define BP_ACETONE  "acetone reactor"

// Robo Organs.
#define BP_VOICE             "vocal synthesiser"
#define BP_STACK             "stack"
#define BP_OPTICS            "optics"

//Augmetations
#define BP_AUGMENT_R_ARM        "right arm augment"
#define BP_AUGMENT_L_ARM        "left arm augment"
#define BP_AUGMENT_R_HAND       "right hand augment"
#define BP_AUGMENT_L_HAND       "left hand augment"
#define BP_AUGMENT_R_LEG        "right leg augment"
#define BP_AUGMENT_L_LEG        "left leg augment"
#define BP_AUGMENT_CHEST_ARMOUR "chest armor augment"
#define BP_AUGMENT_CHEST_ACTIVE "active chest augment"
#define BP_AUGMENT_HEAD         "head augment"

//Augment flags
#define AUGMENTATION_MECHANIC 1
#define AUGMENTATION_ORGANIC  2

// Prosthetic helpers.
#define BP_IS_PROSTHETIC(org) (!QDELETED(org) && (org.organ_properties & ORGAN_PROP_PROSTHETIC))
#define BP_IS_ROBOTIC(org)    (!QDELETED(org) && (org.bodytype?.is_robotic))
#define BP_IS_BRITTLE(org)    (!QDELETED(org) && (org.status           & ORGAN_BRITTLE))
#define BP_IS_CRYSTAL(org)    (!QDELETED(org) && (org.organ_properties & ORGAN_PROP_CRYSTAL))

//Organ Properties Setters
#define BP_SET_PROSTHETIC(org) org.organ_properties |= ORGAN_PROP_PROSTHETIC;
#define BP_SET_CRYSTAL(org)    org.organ_properties |= ORGAN_PROP_CRYSTAL;

// Limb flag helpers
#define BP_IS_DEFORMED(org) (org.limb_flags & ORGAN_FLAG_DEFORMED)

#define SYNTH_BLOOD_COLOR "#030303"
#define SYNTH_FLESH_COLOUR "#575757"

#define MOB_PULL_NONE 0
#define MOB_PULL_SMALLER 1
#define MOB_PULL_SAME 2
#define MOB_PULL_LARGER 3

// Taste sensitivity defines, used in mob/living/proc/ingest.
#define TASTE_HYPERSENSITIVE 3 //anything below 5%
#define TASTE_SENSITIVE 2 //anything below 7%
#define TASTE_NORMAL 1 //anything below 15%
#define TASTE_DULL 0.5 //anything below 30%
#define TASTE_NUMB 0.1 //anything below 150%

// One 'unit' of taste sensitivity probability, used in mob/living/proc/ingest
#define TASTE_DEGREE_PROB 15

//Used by show_message() and emotes
#define VISIBLE_MESSAGE 1
#define AUDIBLE_MESSAGE 2

//used for getting species temp values
#define COLD_LEVEL_1 -1
#define COLD_LEVEL_2 -2
#define COLD_LEVEL_3 -3
#define HEAT_LEVEL_1 1
#define HEAT_LEVEL_2 2
#define HEAT_LEVEL_3 3

//Synthetic human temperature vals
#define SYNTH_COLD_LEVEL_1 50
#define SYNTH_COLD_LEVEL_2 -1
#define SYNTH_COLD_LEVEL_3 -1
#define SYNTH_HEAT_LEVEL_1 500
#define SYNTH_HEAT_LEVEL_2 1000
#define SYNTH_HEAT_LEVEL_3 2000

#define CORPSE_CAN_REENTER 1
#define CORPSE_CAN_REENTER_AND_RESPAWN 2

#define SPECIES_HUMAN            "Human"
#define SPECIES_MONKEY           "Monkey"
#define SPECIES_ALIEN            "Humanoid"
#define SPECIES_GOLEM            "Golem"

#define SURGERY_CLOSED 0
#define SURGERY_OPEN 1
#define SURGERY_RETRACTED 2
#define SURGERY_ENCASED 3

#define STASIS_MISC     "misc"
#define STASIS_CRYOBAG  "cryobag"
#define STASIS_COLD     "cold"

#define AURA_CANCEL 1
#define AURA_FALSE  2
#define AURA_TYPE_BULLET "Bullet"
#define AURA_TYPE_WEAPON "Weapon"
#define AURA_TYPE_THROWN "Thrown"
#define AURA_TYPE_LIFE   "Life"

#define SPECIES_BLOOD_DEFAULT 560

#define SLIME_EVOLUTION_THRESHOLD 15

//Used in mob/proc/get_input
#define MOB_INPUT_TEXT "text"
#define MOB_INPUT_MESSAGE "message"
#define MOB_INPUT_NUM "num"

#define MOB_CLIMB_TIME_SMALL 30
#define MOB_CLIMB_TIME_MEDIUM 50

#define MOB_FACTION_NEUTRAL "neutral"

#define ROBOT_MODULE_TYPE_GROUNDED "grounded"
#define ROBOT_MODULE_TYPE_FLYING   "flying"

#define RADIO_INTERRUPT_DEFAULT 30

#define MOB_FLAG_HOLY_BAD BITFLAG(0)  // If this mob is allergic to holiness

#define DEXTERITY_NONE            0
#define DEXTERITY_SIMPLE_MACHINES BITFLAG(0)
// TODO: let HOLD equip items to hand just not other slots
#define DEXTERITY_HOLD_ITEM       BITFLAG(1)
#define DEXTERITY_WIELD_ITEM      BITFLAG(2)
#define DEXTERITY_EQUIP_ITEM      BITFLAG(3)
#define DEXTERITY_KEYBOARDS       BITFLAG(4)
#define DEXTERITY_TOUCHSCREENS    BITFLAG(5)
// TODO: actually get grab code to check this one.
#define DEXTERITY_GRAPPLE         BITFLAG(6) // Can the mob grab other mobs?
#define DEXTERITY_WEAPONS         BITFLAG(7) // Can the mob use guns?
#define DEXTERITY_COMPLEX_TOOLS   BITFLAG(8) // Can the mob use complex items like flashlights, handcuffs, etc?
#define DEXTERITY_BASE (DEXTERITY_SIMPLE_MACHINES|DEXTERITY_HOLD_ITEM|DEXTERITY_WIELD_ITEM|DEXTERITY_EQUIP_ITEM)
#define DEXTERITY_FULL (DEXTERITY_BASE|DEXTERITY_KEYBOARDS|DEXTERITY_TOUCHSCREENS|DEXTERITY_GRAPPLE|DEXTERITY_WEAPONS|DEXTERITY_COMPLEX_TOOLS)

// List of dexterity flags ordered by 'complexity' for use in brainloss dex malus checking.
var/global/list/dexterity_levels = list(
	"[DEXTERITY_COMPLEX_TOOLS]",
	"[DEXTERITY_WEAPONS]",
	"[DEXTERITY_GRAPPLE]",
	"[DEXTERITY_TOUCHSCREENS]",
	"[DEXTERITY_KEYBOARDS]",
	"[DEXTERITY_BASE]"
)

// used in /mob/living/human/can_inject, and by various callers of that proc
#define CAN_INJECT 1
#define INJECTION_PORT 2
#define INJECTION_PORT_DELAY 3 SECONDS // used by injectors to apply delay due to searching for a port on the injectee's suit

#define ADJUSTED_GLIDE_SIZE(DELAY) (NONUNIT_CEILING((WORLD_ICON_SIZE / max((DELAY), world.tick_lag) * world.tick_lag) - world.tick_lag, 1) + (get_config_value(/decl/config/num/movement_glide_size)))

#define PREF_MEM_RECORD "memory"
#define PREF_SEC_RECORD "sec_record"
#define PREF_PUB_RECORD "public_record"
#define PREF_MED_RECORD "med_record"
#define PREF_GEN_RECORD "gen_record"

// Simple animal icon state flags.
#define MOB_ICON_HAS_LIVING_STATE    BITFLAG(0)
#define MOB_ICON_HAS_DEAD_STATE      BITFLAG(1)
#define MOB_ICON_HAS_REST_STATE      BITFLAG(2)
#define MOB_ICON_HAS_SLEEP_STATE     BITFLAG(3)
#define MOB_ICON_HAS_GIB_STATE       BITFLAG(4)
#define MOB_ICON_HAS_DUST_STATE      BITFLAG(5)
#define MOB_ICON_HAS_PARALYZED_STATE BITFLAG(6)
#define NEUTER_ANIMATE "animate singular neutral"

// Equipment Overlays Indices //
#define HO_CONDITION_LAYER  1
#define HO_SKIN_LAYER       2
#define HO_DAMAGE_LAYER     3
#define HO_SURGERY_LAYER    4 //bs12 specific.
#define HO_BANDAGE_LAYER    5
#define HO_UNDERWEAR_LAYER  6
#define HO_UNIFORM_LAYER    7
#define HO_ID_LAYER         8
#define HO_SHOES_LAYER      9
#define HO_GLOVES_LAYER     10
#define HO_BELT_LAYER       11
#define HO_SUIT_LAYER       12
#define HO_GLASSES_LAYER    13
#define HO_BELT_LAYER_ALT   14
#define HO_SUIT_STORE_LAYER 15
#define HO_BACK_LAYER       16
#define HO_TAIL_LAYER       17 //bs12 specific. this hack is probably gonna come back to haunt me
#define HO_HAIR_LAYER       18 //TODO: make part of head layer?
#define HO_GOGGLES_LAYER    19
#define HO_L_EAR_LAYER      20
#define HO_R_EAR_LAYER      21
#define HO_FACEMASK_LAYER   22
#define HO_HEAD_LAYER       23
#define HO_COLLAR_LAYER     24
#define HO_HANDCUFF_LAYER   25
#define HO_INHAND_LAYER     26
#define HO_FIRE_LAYER       27 //If you're on fire
#define TOTAL_OVER_LAYERS   27
//////////////////////////////////

// Underlay defines; vestigal implementation currently.
#define HU_TAIL_LAYER 1
#define TOTAL_UNDER_LAYERS 1

// Enum for result of an attempt to eat/eat from an item.
#define EATEN_INVALID 0
#define EATEN_UNABLE  1
#define EATEN_SUCCESS 2

// Enum for type of consumption, largely just cosmetic currently.
#define EATING_METHOD_EAT   0
#define EATING_METHOD_DRINK 1

#define SAC_HAIR        /decl/sprite_accessory_category/hair
#define SAC_FACIAL_HAIR /decl/sprite_accessory_category/facial_hair
#define SAC_COSMETICS   /decl/sprite_accessory_category/cosmetics
#define SAC_MARKINGS    /decl/sprite_accessory_category/markings
#define SAC_EARS        /decl/sprite_accessory_category/ears
#define SAC_HORNS       /decl/sprite_accessory_category/horns
#define SAC_FRILLS      /decl/sprite_accessory_category/frills

// Helpers for setting mob appearance. They are extremely ugly, hence the helpers.
#define SET_HAIR_STYLE(TARGET, STYLE, SKIP_UPDATE)          (TARGET.set_organ_sprite_accessory_by_category((STYLE), SAC_HAIR, null, TRUE, FALSE, BP_HEAD, SKIP_UPDATE))
#define GET_HAIR_STYLE(TARGET)                              (TARGET.get_organ_sprite_accessory_by_category(SAC_HAIR, BP_HEAD))
#define SET_HAIR_COLOUR(TARGET, COLOUR, SKIP_UPDATE)        (TARGET.set_organ_sprite_accessory_by_category(null, SAC_HAIR, (COLOUR), FALSE, TRUE, BP_HEAD, SKIP_UPDATE))
#define GET_HAIR_COLOUR(TARGET)                             (TARGET.get_organ_sprite_accessory(GET_HAIR_STYLE(TARGET), BP_HEAD))

#define SET_FACIAL_HAIR_STYLE(TARGET, STYLE, SKIP_UPDATE)   (TARGET.set_organ_sprite_accessory_by_category((STYLE), SAC_FACIAL_HAIR, null, TRUE, FALSE, BP_HEAD, SKIP_UPDATE))
#define GET_FACIAL_HAIR_STYLE(TARGET)                       (TARGET.get_organ_sprite_accessory_by_category(SAC_FACIAL_HAIR, BP_HEAD))
#define SET_FACIAL_HAIR_COLOUR(TARGET, COLOUR, SKIP_UPDATE) (TARGET.set_organ_sprite_accessory_by_category(null, SAC_FACIAL_HAIR, (COLOUR), FALSE, TRUE, BP_HEAD, SKIP_UPDATE))
#define GET_FACIAL_HAIR_COLOUR(TARGET)                      (TARGET.get_organ_sprite_accessory(GET_FACIAL_HAIR_STYLE(TARGET), BP_HEAD))

// Used in death() to skip message broadcast.
#define SKIP_DEATH_MESSAGE "no message"

