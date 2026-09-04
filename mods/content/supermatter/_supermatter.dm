// These are used by supermatter and supermatter monitor program, mostly for UI updating purposes. Higher should always be worse!
#define SUPERMATTER_ERROR -1		// Unknown status, shouldn't happen but just in case.
#define SUPERMATTER_INACTIVE 0		// No or minimal energy
#define SUPERMATTER_NORMAL 1		// Normal operation
#define SUPERMATTER_NOTIFY 2		// Ambient temp > 80% of CRITICAL_TEMPERATURE
#define SUPERMATTER_WARNING 3		// Ambient temp > CRITICAL_TEMPERATURE OR integrity damaged
#define SUPERMATTER_DANGER 4		// Integrity < 50%
#define SUPERMATTER_EMERGENCY 5		// Integrity < 25%
#define SUPERMATTER_DELAMINATING 6	// Pretty obvious.

#define SUPERMATTER_DATA_EER         "Relative EER"
#define SUPERMATTER_DATA_TEMPERATURE "Temperature"
#define SUPERMATTER_DATA_PRESSURE    "Pressure"
#define SUPERMATTER_DATA_EPR         "Chamber EPR"

/decl/modpack/supermatter
	name = "Supermatter Content"
	desc = "This modpack includes the supermatter engine and related content."
	nanoui_directory = "mods/content/supermatter/nano_templates/"

/decl/modpack/supermatter/pre_initialize()
	. = ..()
	global.debug_verbs |= /datum/admins/proc/setup_supermatter