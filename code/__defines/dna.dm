// Bitflags for mutations.
#define STRUCDNASIZE 27
#define   UNIDNASIZE 13

// Generic mutations:
#define MUTATION_COLD_RESISTANCE 1
#define MUTATION_XRAY            2
#define MUTATION_CLUMSY          3
#define MUTATION_HUSK            4
#define MUTATION_SPACERES        5 // Can't be harmed via pressure damage.

// Other Mutations:
#define mNobreath      100 // No need to breathe.
#define mRemote        101 // Remote viewing.
#define mRegen         102 // Health regeneration.
#define mRun           103 // No slowdown.
#define mRemotetalk    104 // Remote talking.
#define mMorph         105 // Hanging appearance.
#define mBlend         106 // Nothing. (seriously nothing)
#define mHallucination 107 // Hallucinations.
#define mFingerprints  108 // No fingerprints.
#define mShock         109 // Insulated hands.

// disabilities
#define NEARSIGHTED BITFLAG(0)
#define EPILEPSY    BITFLAG(1)
#define COUGHING    BITFLAG(2)
#define TOURETTES   BITFLAG(3)
#define NERVOUS     BITFLAG(4)

// sdisabilities
#define BLINDED  BITFLAG(0)
#define MUTED    BITFLAG(1)
#define DEAFENED BITFLAG(2)

// The way blocks are handled badly needs a rewrite, this is horrible.
// Too much of a project to handle at the moment, TODO for later.
var/global/BLINDBLOCK =         0
var/global/DEAFBLOCK =          0
var/global/TELEBLOCK =          0
var/global/FIREBLOCK =          0
var/global/XRAYBLOCK =          0
var/global/CLUMSYBLOCK =        0
var/global/FAKEBLOCK =          0
var/global/COUGHBLOCK =         0
var/global/GLASSESBLOCK =       0
var/global/TWITCHBLOCK =        0
var/global/NERVOUSBLOCK =       0
var/global/MONKEYBLOCK =        STRUCDNASIZE

var/global/BLOCKADD =           0
var/global/DIFFMUT =            0

var/global/HEADACHEBLOCK =      0
var/global/NOBREATHBLOCK =      0
var/global/REMOTEVIEWBLOCK =    0
var/global/REGENERATEBLOCK =    0
var/global/INCREASERUNBLOCK =   0
var/global/REMOTETALKBLOCK =    0
var/global/MORPHBLOCK =         0
var/global/BLENDBLOCK =         0
var/global/HALLUCINATIONBLOCK = 0
var/global/NOPRINTSBLOCK =      0
var/global/SHOCKIMMUNITYBLOCK = 0
var/global/SMALLSIZEBLOCK =     0
