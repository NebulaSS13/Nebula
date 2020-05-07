/**
 * Turret modes as defined by users in-game. These represents the turrets on/off setting, or malfunctioning state.
 */
#define TURR_MODE_OFF "OFF" // Turret is turned off
#define TURR_MODE_ON "ON" // Turret is turned on


/**
 * Turret state defines. These control the icon state as well as what functionality is enabled/disabled for the turret.
 */
#define TURR_STATE_OFF "OFF" // Turret is off but otherwise functional
#define TURR_STATE_IDLE "IDLE" // Turret is on but idle
#define TURR_STATE_ENGAGED "ENGAGED" // Turret is on and actively engaging someone
#define TURR_STATE_DISABLED "DISABLED" // Turret is disabled
#define TURR_STATE_BROKEN "BROKEN" // Turret is broken
#define TURR_STATE_UNARMED "UNARMED" // Turret has no gun installed


/**
 * Turret targeting parameter bitflags. Represents different categories of targets a turret can be configured to shoot.
 */
#define TURR_TGT_PEOPLE 1 // Turret will target people with IDs (With respect to the access list)
#define TURR_TGT_UNKNOWNS 2 // Turret will target people without IDs
#define TURR_TGT_CREATURES 4 // Turret will target creatures. Includes mice, carp, spiders, etc
#define TURR_TGT_SYNTHS 8 // Turret will target law-bound synthetics
#define TURR_TGT_DOWNED 16 // Turret will continue firing even if the target is 'downed'
#define TURR_TGT_IGNORE_ACCESS 32 // Turret will ignore access when selecting targets based on other criteria


/**
 * Turret wire datum bitflags
 */
#define TURRET_WIRE_POWER 1 // Powered/unpowered state
#define TURRET_WIRE_HAYWIRE 2 // Haywire state
#define TURRET_WIRE_ACCESS 4 // Access bypass
#define TURRET_WIRE_AI_CONTROL 8 // AI control allowed/blocked
#define TURRET_WIRE_REMOTE_CONTROL 16 // Remote controller control allowed/blocked
