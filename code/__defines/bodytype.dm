#define BODY_FLAG_EXCLUDE        BITFLAG(0)
#define BODY_FLAG_HUMANOID       BITFLAG(1)
#define BODY_FLAG_MONKEY         BITFLAG(2)
#define BODY_FLAG_QUADRUPED      BITFLAG(3)

#define BODYTYPE_HUMANOID        "humanoid body"
#define BODYTYPE_QUADRUPED       "quadruped body"
#define BODYTYPE_OTHER           "alien body"
#define BODYTYPE_MONKEY          "small humanoid body"

// Bodytype appearance flags
#define HAS_SKIN_TONE_NORMAL  BITFLAG(0)  // Skin tone selectable in chargen for baseline humans (0-220)
#define HAS_SKIN_COLOR        BITFLAG(1)  // Skin color selectable in chargen. (RGB)
#define HAS_UNDERWEAR         BITFLAG(3)  // Underwear is drawn onto the mob icon.
#define HAS_EYE_COLOR         BITFLAG(4)  // Eye color selectable in chargen. (RGB)
#define RADIATION_GLOWS       BITFLAG(6)  // Radiation causes this character to glow.
#define HAS_SKIN_TONE_GRAV    BITFLAG(7)  // Skin tone selectable in chargen for grav-adapted humans (0-100)
#define HAS_SKIN_TONE_SPCR    BITFLAG(8)  // Skin tone selectable in chargen for spacer humans (0-165)
#define HAS_SKIN_TONE_TRITON  BITFLAG(9)
#define HAS_A_SKIN_TONE (HAS_SKIN_TONE_NORMAL | HAS_SKIN_TONE_GRAV | HAS_SKIN_TONE_SPCR | HAS_SKIN_TONE_TRITON) // Bodytype has a numeric skintone

// Bodytype feature flags
#define BODY_FLAG_NO_DNA              BITFLAG(0) // Does not create DNA. Replaces SPECIES_FLAG_NO_SCAN.
#define BODY_FLAG_NO_PAIN             BITFLAG(1) // Cannot suffer halloss/recieves deceptive health indicator.
#define BODY_FLAG_NO_EAT              BITFLAG(2) // Cannot eat food/drink drinks even if a stomach organ is present.
#define BODY_FLAG_CRYSTAL_REFORM      BITFLAG(3) // Can regenerate missing limbs from mineral baths.
#define BODY_FLAG_NO_STASIS           BITFLAG(4) // Does not experience stasis effects (sleeper, cryo)
#define BODY_FLAG_NO_DEFIB            BITFLAG(5) // Cannot be revived with a defibrilator.
