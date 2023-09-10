#define SHUTTLE_FLAGS_NONE    0
#define SHUTTLE_FLAGS_PROCESS BITFLAG(0)
#define SHUTTLE_FLAGS_SUPPLY  BITFLAG(1)
#define SHUTTLE_FLAGS_ZERO_G  BITFLAG(2)
#define SHUTTLE_FLAGS_NO_CODE BITFLAG(3)  // Essentially bypasses docking codes by extracting them from the target docking controller. Only relevant on /autodock.
#define SHUTTLE_FLAGS_ALL (~SHUTTLE_FLAGS_NONE)

#define SLANDMARK_FLAG_AUTOSET      BITFLAG(0) // If set, will set base area and turf type to same as where it was spawned at.
#define SLANDMARK_FLAG_ZERO_G       BITFLAG(1) // Zero-G shuttles moved here will lose gravity unless the area has ambient gravity.
#define SLANDMARK_FLAG_DISCONNECTED BITFLAG(2) // Landable ships that land here will be forceably removed if the sector moves out of range.
#define SLANDMARK_FLAG_REORIENT     BITFLAG(3) // Shuttles that land here will be reoriented to face the correct dir for docking.

//Overmap landable shuttles
#define SHIP_STATUS_LANDED    BITFLAG(0)
#define SHIP_STATUS_TRANSIT   BITFLAG(1)
#define SHIP_STATUS_OVERMAP   BITFLAG(2)
#define SHIP_STATUS_ENCOUNTER BITFLAG(3)