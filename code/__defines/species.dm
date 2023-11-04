// Species flags.
#define SPECIES_FLAG_NO_MINOR_CUT       BITFLAG(0) // Can step on broken glass with no ill-effects. Either thick skin, cut resistant (slimes) or incorporeal (shadows)
#define SPECIES_FLAG_IS_PLANT           BITFLAG(1) // Is a treeperson.
#define SPECIES_FLAG_NO_SLIP            BITFLAG(2) // Cannot fall over.
#define SPECIES_FLAG_NO_POISON          BITFLAG(3) // Cannot not suffer toxloss.
#define SPECIES_FLAG_NO_EMBED           BITFLAG(4) // Can step on broken glass with no ill-effects and cannot have shrapnel embedded in it.
#define SPECIES_FLAG_NO_TANGLE          BITFLAG(5) // This species wont get tangled up in weeds
#define SPECIES_FLAG_NO_BLOCK           BITFLAG(6) // Unable to block or defend itself from attackers.
#define SPECIES_FLAG_NEED_DIRECT_ABSORB BITFLAG(7) // This species can only have their DNA taken by direct absorption.
#define SPECIES_FLAG_LOW_GRAV_ADAPTED   BITFLAG(8) // This species is used to lower than standard gravity, affecting stamina in high-grav

// Species spawn flags
#define SPECIES_IS_WHITELISTED             BITFLAG(0) // Must be whitelisted to play.
#define SPECIES_IS_RESTRICTED              BITFLAG(1) // Is not a core/normally playable species. (castes, mutantraces)
#define SPECIES_CAN_JOIN                   BITFLAG(2) // Species is selectable in chargen.
#define SPECIES_NO_ROBOTIC_INTERNAL_ORGANS BITFLAG(3) // Species cannot start with robotic organs or have them attached.

// Skin Defines
#define SKIN_NORMAL 0
#define SKIN_THREAT 1
