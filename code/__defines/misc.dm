#define DEBUG
// Turf-only flags.
#define TURF_FLAG_NOJAUNT 1 // This is used in literally one place, turf.dm, to block ethereal jaunt.
#define TURF_FLAG_NORUINS 2

#define TRANSITIONEDGE 7 // Distance from edge to move to another z-level.
#define RUIN_MAP_EDGE_PAD 15

// Invisibility constants.
#define INVISIBILITY_LIGHTING    20
#define INVISIBILITY_LEVEL_ONE   35
#define INVISIBILITY_LEVEL_TWO   45
#define INVISIBILITY_OBSERVER    60
#define INVISIBILITY_EYE         61
#define INVISIBILITY_SYSTEM      99
#define INVISIBILITY_ABSTRACT   101	// special: this can never be seen, regardless of see_invisible

#define SEE_INVISIBLE_LIVING     25
#define SEE_INVISIBLE_NOLIGHTING 15
#define SEE_INVISIBLE_LEVEL_ONE  INVISIBILITY_LEVEL_ONE
#define SEE_INVISIBLE_LEVEL_TWO  INVISIBILITY_LEVEL_TWO
#define SEE_INVISIBLE_CULT       INVISIBILITY_OBSERVER
#define SEE_INVISIBLE_OBSERVER   INVISIBILITY_EYE
#define SEE_INVISIBLE_SYSTEM     INVISIBILITY_SYSTEM

#define SEE_IN_DARK_DEFAULT 2

#define SEE_INVISIBLE_MINIMUM 5
#define INVISIBILITY_MAXIMUM 100

// Some arbitrary defines to be used by self-pruning global lists. (see master_controller)
#define PROCESS_KILL 26 // Used to trigger removal from a processing list.

// For secHUDs and medHUDs and variants. The number is the location of the image on the list hud_list of humans.
#define      HEALTH_HUD 1 // A simple line rounding the mob's number health.
#define      STATUS_HUD 2 // Alive, dead, diseased, etc.
#define          ID_HUD 3 // The job asigned to your ID.
#define      WANTED_HUD 4 // Wanted, released, paroled, security status.
#define    IMPLOYAL_HUD 5 // Loyality implant.
#define     IMPCHEM_HUD 6 // Chemical implant.
#define    IMPTRACK_HUD 7 // Tracking implant.
#define SPECIALROLE_HUD 8 // AntagHUD image.
#define  STATUS_HUD_OOC 9 // STATUS_HUD without check for someone being ill.
#define 	  LIFE_HUD 10 // STATUS_HUD that only reports dead or alive

// Shuttle moving status.
#define SHUTTLE_IDLE      0
#define SHUTTLE_WARMUP    1
#define SHUTTLE_INTRANSIT 2

// Autodock shuttle processing status.
#define IDLE_STATE   0
#define WAIT_LAUNCH  1
#define FORCE_LAUNCH 2
#define WAIT_ARRIVE  3
#define WAIT_FINISH  4

// Setting this much higher than 1024 could allow spammers to DOS the server easily.
#define MAX_MESSAGE_LEN       1024
#define MAX_PAPER_MESSAGE_LEN 6144
#define MAX_BOOK_MESSAGE_LEN  18432
#define MAX_LNAME_LEN         64
#define MAX_NAME_LEN          26
#define MAX_DESC_LEN          128
#define MAX_TEXTFILE_LENGTH 128000		// 512GQ file

// Event defines.
#define EVENT_LEVEL_MUNDANE  1
#define EVENT_LEVEL_MODERATE 2
#define EVENT_LEVEL_MAJOR    3

//General-purpose life speed define for plants.
#define HYDRO_SPEED_MULTIPLIER 1

#define DEFAULT_JOB_TYPE /datum/job/assistant

//Area flags, possibly more to come
#define AREA_FLAG_RAD_SHIELDED      1 // shielded from radiation, clearly
#define AREA_FLAG_EXTERNAL          2 // External as in exposed to space, not outside in a nice, green, forest
#define AREA_FLAG_ION_SHIELDED      4 // shielded from ionospheric anomalies
#define AREA_FLAG_IS_NOT_PERSISTENT 8 // SSpersistence will not track values from this area.

//Map template flags
#define TEMPLATE_FLAG_ALLOW_DUPLICATES 1 // Lets multiple copies of the template to be spawned
#define TEMPLATE_FLAG_SPAWN_GUARANTEED 2 // Makes it ignore away site budget and just spawn (only for away sites)
#define TEMPLATE_FLAG_CLEAR_CONTENTS   4 // if it should destroy objects it spawns on top of
#define TEMPLATE_FLAG_NO_RUINS         8 // if it should forbid ruins from spawning on top of it
#define TEMPLATE_FLAG_NO_RADS          16// Removes all radiation from the template after spawning.

// Convoluted setup so defines can be supplied by Bay12 main server compile script.
// Should still work fine for people jamming the icons into their repo.
#ifndef CUSTOM_ITEM_CONFIG
#define CUSTOM_ITEM_CONFIG "config/custom_items/"
#endif
#ifndef CUSTOM_ITEM_SYNTH_CONFIG
#define CUSTOM_ITEM_SYNTH_CONFIG "config/custom_sprites.txt"
#endif
#ifndef CUSTOM_ITEM_OBJ
#define CUSTOM_ITEM_OBJ 'icons/obj/custom_items_obj.dmi'
#endif
#ifndef CUSTOM_ITEM_MOB
#define CUSTOM_ITEM_MOB 'icons/mob/custom_items_mob.dmi'
#endif
#ifndef CUSTOM_ITEM_SYNTH
#define CUSTOM_ITEM_SYNTH 'icons/mob/custom_synthetic.dmi'
#endif

#define WALL_CAN_OPEN 1
#define WALL_OPENING 2

#define BOMBCAP_DVSTN_RADIUS (GLOB.max_explosion_range/4)
#define BOMBCAP_HEAVY_RADIUS (GLOB.max_explosion_range/2)
#define BOMBCAP_LIGHT_RADIUS GLOB.max_explosion_range
#define BOMBCAP_FLASH_RADIUS (GLOB.max_explosion_range*1.5)


// Special return values from bullet_act(). Positive return values are already used to indicate the blocked level of the projectile.
#define PROJECTILE_CONTINUE   -1 //if the projectile should continue flying after calling bullet_act()
#define PROJECTILE_FORCE_MISS -2 //if the projectile should treat the attack as a miss (suppresses attack and admin logs) - only applies to mobs.

//Camera capture modes
#define CAPTURE_MODE_REGULAR 0 //Regular polaroid camera mode
#define CAPTURE_MODE_ALL 1 //Admin camera mode
#define CAPTURE_MODE_PARTIAL 3 //Simular to regular mode, but does not do dummy check

//objectives
#define CONFIG_OBJECTIVE_NONE 2
#define CONFIG_OBJECTIVE_VERB 1
#define CONFIG_OBJECTIVE_ALL  0

// How many times an AI tries to connect to APC before switching to low power mode.
#define AI_POWER_RESTORE_MAX_ATTEMPTS 3

// AI power restoration routine steps.
#define AI_RESTOREPOWER_FAILED -1
#define AI_RESTOREPOWER_IDLE 0
#define AI_RESTOREPOWER_STARTING 1
#define AI_RESTOREPOWER_DIAGNOSTICS 2
#define AI_RESTOREPOWER_CONNECTING 3
#define AI_RESTOREPOWER_CONNECTED 4
#define AI_RESTOREPOWER_COMPLETED 5

// AI button defines
#define AI_BUTTON_PROC_BELONGS_TO_CALLER 1
#define AI_BUTTON_INPUT_REQUIRES_SELECTION 2

// Values represented as Oxyloss. Can be tweaked, but make sure to use integers only.
#define AI_POWERUSAGE_LOWPOWER 1
#define AI_POWERUSAGE_RESTORATION 2
#define AI_POWERUSAGE_NORMAL 5
#define AI_POWERUSAGE_RECHARGING 7

// Above values get multiplied by this when converting AI oxyloss -> watts.
// For now, one oxyloss point equals 10kJ of energy, so normal AI uses 5 oxyloss per tick (50kW or 70kW if charging)
#define AI_POWERUSAGE_OXYLOSS_TO_WATTS_MULTIPLIER 10000

//Grid for Item Placement
#define CELLS 8								//Amount of cells per row/column in grid
#define CELLSIZE (world.icon_size/CELLS)	//Size of a cell in pixels

#define PIXEL_MULTIPLIER WORLD_ICON_SIZE/32

#define DEFAULT_SPAWNPOINT_ID "Default"

#define MIDNIGHT_ROLLOVER		864000	//number of deciseconds in a day

//Error handler defines
#define ERROR_USEFUL_LEN 2

#define RAD_LEVEL_LOW 1 // Around the level at which radiation starts to become harmful
#define RAD_LEVEL_MODERATE 25
#define RAD_LEVEL_HIGH 40
#define RAD_LEVEL_VERY_HIGH 100

#define RADIATION_THRESHOLD_CUTOFF 0.1	// Radiation will not affect a tile when below this value.

#define LEGACY_RECORD_STRUCTURE(X, Y) GLOBAL_LIST_EMPTY(##X);/datum/computer_file/data/##Y/var/list/fields[0];/datum/computer_file/data/##Y/New(){..();GLOB.##X.Add(src);}/datum/computer_file/data/##Y/Destroy(){. = ..();GLOB.##X.Remove(src);}

#define SUPPLY_SECURITY_ELEVATED 1
#define SUPPLY_SECURITY_HIGH 2

// secure gun authorization settings
#define UNAUTHORIZED      0
#define AUTHORIZED        1
#define ALWAYS_AUTHORIZED 2

// wrinkle states for clothes
#define WRINKLES_DEFAULT	0
#define WRINKLES_WRINKLY	1
#define WRINKLES_NONE		2

//detergent states for clothes
#define SMELL_DEFAULT	0
#define SMELL_CLEAN		1
#define SMELL_STINKY	2

//Shuttle mission stages
#define SHUTTLE_MISSION_PLANNED  1
#define SHUTTLE_MISSION_STARTED  2
#define SHUTTLE_MISSION_FINISHED 3
#define SHUTTLE_MISSION_QUEUED   4

//Built-in email accounts
#define EMAIL_DOCUMENTS "document.server@internal-services.net"
#define EMAIL_SYSADMIN  "admin@internal-services.net"
#define EMAIL_BROADCAST "broadcast@internal-services.net"

//Stats for department goals etc
#define STAT_XENOPLANTS_SCANNED  "xenoplants_scanned"
#define STAT_XENOFAUNA_SCANNED  "xenofauna_scanned"
#define STAT_FLAGS_PLANTED  "planet_flags"

//Number of slots a modular computer has which can be tweaked via gear tweaks.
#define TWEAKABLE_COMPUTER_PART_SLOTS 7

//Lying animation
#define ANIM_LYING_TIME 2

//Planet habitability class
#define HABITABILITY_IDEAL  1
#define HABITABILITY_OKAY  2
#define HABITABILITY_BAD  3

#ifndef WINDOWS_HTTP_POST_DLL_LOCATION
#define WINDOWS_HTTP_POST_DLL_LOCATION "lib/byhttp.dll"
#endif

#ifndef UNIX_HTTP_POST_DLL_LOCATION
#define UNIX_HTTP_POST_DLL_LOCATION "lib/libbyhttp.so"
#endif

#ifndef HTTP_POST_DLL_LOCATION
#define HTTP_POST_DLL_LOCATION (world.system_type == MS_WINDOWS ? WINDOWS_HTTP_POST_DLL_LOCATION : UNIX_HTTP_POST_DLL_LOCATION)
#endif

// Surgery candidate flags.
#define SURGERY_NO_ROBOTIC        1
#define SURGERY_NO_CRYSTAL        2
#define SURGERY_NO_STUMP          4
#define SURGERY_NO_FLESH          8
#define SURGERY_NEEDS_INCISION   16
#define SURGERY_NEEDS_RETRACTED  32
#define SURGERY_NEEDS_ENCASEMENT 64

// Structure interaction flags
#define TOOL_INTERACTION_ANCHOR      1
#define TOOL_INTERACTION_DECONSTRUCT 2
#define TOOL_INTERACTION_WIRING      4
#define TOOL_INTERACTION_ALL         (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT | TOOL_INTERACTION_WIRING)

//Inserts 'a' or 'an' before X in ways \a doesn't allow
#define ADD_ARTICLE(X) "[(lowertext(copytext(X, 1, 2)) in list("a", "e", "i", "o", "u")) ? "an" : "a"] [X]"

#define SOULSTONE_CRACKED -1
#define SOULSTONE_EMPTY 0
#define SOULSTONE_ESSENCE 1

#define INCREMENT_WORLD_Z_SIZE world.maxz++; global.connected_z_cache.Cut(); if (SSzcopy.zstack_maximums.len) { SSzcopy.calculate_zstack_limits() }
#define ARE_Z_CONNECTED(ZA, ZB) (ZA > 0 && ZB > 0 && ZA <= world.maxz && ZB <= world.maxz && ((ZA == ZB) || ((global.connected_z_cache.len >= ZA && global.connected_z_cache[ZA]) ? global.connected_z_cache[ZA][ZB] : AreConnectedZLevels(ZA, ZB))))

//Request Console Department Types
#define RC_ASSIST 1		//Request Assistance
#define RC_SUPPLY 2		//Request Supplies
#define RC_INFO   4		//Relay Info

#define WORTH_TO_SUPPLY_POINTS_CONSTANT       0.0075
#define WORTH_TO_SUPPLY_POINTS_ROUND_CONSTANT 5