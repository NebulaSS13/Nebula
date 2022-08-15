#define SPECIES_HUMAN  "Human"
// Species names/keys
#define SPECIES_MONKEY "Monkey"
#define SPECIES_ALIEN  "Humanoid"
#define SPECIES_GOLEM  "Golem"

// Species flags.
#define SPECIES_FLAG_NO_MINOR_CUT       BITFLAG(0)  // Can step on broken glass with no ill-effects. Either thick skin, cut resistant (slimes) or incorporeal (shadows)
#define SPECIES_FLAG_IS_PLANT           BITFLAG(1)  // Is a treeperson.
#define SPECIES_FLAG_NO_SCAN            BITFLAG(2)  // Cannot be scanned in a DNA machine/genome-stolen.
#define SPECIES_FLAG_NO_SLIP            BITFLAG(3)  // Cannot fall over.
#define SPECIES_FLAG_NO_POISON          BITFLAG(4)  // Cannot not suffer toxloss.
#define SPECIES_FLAG_NO_EMBED           BITFLAG(5)  // Can step on broken glass with no ill-effects and cannot have shrapnel embedded in it.
#define SPECIES_FLAG_NO_TANGLE          BITFLAG(6)  // This species wont get tangled up in weeds
#define SPECIES_FLAG_NO_BLOCK           BITFLAG(7)  // Unable to block or defend itself from attackers.
#define SPECIES_FLAG_NEED_DIRECT_ABSORB BITFLAG(8)  // This species can only have their DNA taken by direct absorption.
#define SPECIES_FLAG_LOW_GRAV_ADAPTED   BITFLAG(9)  // This species is used to lower than standard gravity, affecting stamina in high-grav
#define SPECIES_FLAG_CRYSTALLINE        BITFLAG(10) // This species is made of crystalline material. Replaces var/is_crystalline.
#define SPECIES_FLAG_SYNTHETIC          BITFLAG(11) // This species is synthetic/robotic and spawns with prosthetic limbs.

// Body flags
#define BODYTYPE_EQUIP_FLAG_EXCLUDE  BITFLAG(0)
#define BODYTYPE_EQUIP_FLAG_HUMANOID BITFLAG(1)
#define BODYTYPE_EQUIP_FLAG_MONKEY   BITFLAG(2)

#define BODYTYPE_HUMANOID "humanoid body"
#define BODYTYPE_OTHER    "alien body"
#define BODYTYPE_MONKEY   "small humanoid body"

#define BODY_FLAG_NO_PAIN             BITFLAG(1) // Cannot suffer halloss/recieves deceptive health indicator.
#define BODY_FLAG_CAN_INGEST_REAGENTS BITFLAG(2) // Can eat food/drink drinks

// Species spawn flags
#define SPECIES_IS_WHITELISTED             BITFLAG(0) // Must be whitelisted to play.
#define SPECIES_IS_RESTRICTED              BITFLAG(1) // Is not a core/normally playable species. (castes, mutantraces)
#define SPECIES_CAN_JOIN                   BITFLAG(2) // Species is selectable in chargen.
#define SPECIES_NO_ROBOTIC_INTERNAL_ORGANS BITFLAG(3) // Species cannot start with robotic organs or have them attached.

// Species appearance flags
#define HAS_SKIN_TONE         BITFLAG(0) // Species has a numeric skintone
#define HAS_SKIN_COLOR        BITFLAG(1) // Skin colour selectable in chargen. (RGB)
#define HAS_LIPS              BITFLAG(2) // Lips are drawn onto the mob icon. (lipstick)
#define HAS_UNDERWEAR         BITFLAG(3) // Underwear is drawn onto the mob icon.
#define HAS_EYE_COLOR         BITFLAG(4) // Eye colour selectable in chargen. (RGB)
#define HAS_HAIR_COLOR        BITFLAG(5) // Hair colour selectable in chargen. (RGB)
#define RADIATION_GLOWS       BITFLAG(6) // Radiation causes this character to glow.

// Skin Defines
#define SKIN_NORMAL 0
#define SKIN_THREAT 1
