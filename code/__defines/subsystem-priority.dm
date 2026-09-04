// Something to remember when setting priorities: SS_TICKER runs before Normal, which runs before SS_BACKGROUND.
// Each group has its own priority bracket.
// SS_BACKGROUND handles high server load differently than Normal and SS_TICKER do.
// Higher priority also means a larger share of a given tick before sleep checks.

#define SS_PRIORITY_DEFAULT       50  // Default priority for all processes levels

// SS_TICKER
#define SS_PRIORITY_OVERLAY      100  // Applies overlays. May cause overlay pop-in if it gets behind.
#define SS_PRIORITY_TIMER         20
#define SS_PRIORITY_DPC           19

// Normal
#define SS_PRIORITY_TICKER       100  // Gameticker.
#define SS_PRIORITY_MOB           95  // Mob Life().
#define SS_PRIORITY_MACHINERY     95  // Machinery + powernet ticks.
#define SS_PRIORITY_AIR           80  // ZAS processing.
#define SS_PRIORITY_THROWING      75  // Throwing calculation and constant checks
#define SS_PRIORITY_MATERIALS     60  // Multi-tick chemical reactions.
#define SS_PRIORITY_LIGHTING      50  // Queued lighting engine updates.
#define SS_PRIORITY_SPACEDRIFT    40  // Drifting things.
#define SS_PRIORITY_INPUT         20  // Input things.
#define SS_PRIORITY_ICON_UPDATE   20  // Queued icon updates. Mostly used by APCs and tables.
#define SS_PRIORITY_VIS_CONTENTS  20  // Queued vis_contents updates.
#define SS_PRIORITY_AMBIENCE      20  // Queued ambient lighting updates.
#define SS_PRIORITY_ALARM         20  // Alarm processing.
#define SS_PRIORITY_EVENT         20  // Event processing and queue handling.
#define SS_PRIORITY_SHUTTLE       20  // Shuttle movement.
#define SS_PRIORITY_CIRCUIT_COMP  20  // Processing circuit component do_work.
#define SS_PRIORITY_TEMPERATURE   20  // Cooling and heating of atoms.
#define SS_PRIORITY_RADIATION     20  // Radiation processing and cache updates.
#define SS_PRIORITY_OPEN_SPACE    20  // Open turf updates.
#define SS_PRIORITY_AIRFLOW       15  // Object movement from ZAS airflow.
#define SS_PRIORITY_FLUIDS        11  // Liquid flows.
#define SS_PRIORITY_VOTE          10  // Vote management.
#define SS_PRIORITY_INACTIVITY    10  // Idle kicking.
#define SS_PRIORITY_SUPPLY        10  // Supply point accumulation.
#define SS_PRIORITY_TRADE         10  // Adds/removes traders.
#define SS_PRIORITY_GHOST_IMAGES  10  // Updates ghost client images.
#define SS_PRIORITY_ZCOPY         10  // Builds appearances for Z-Mimic.
#define SS_PRIORITY_PROJECTILES   10  // Projectile processing!
#define SS_PRIORITY_PATHFINDING   10  // Processing pathfinding requests

// SS_BACKGROUND
#define SS_PRIORITY_OBJECTS      100  // processing_objects processing.
#define SS_PRIORITY_OVERMAP       95  // Moving objects on the overmap.
#define SS_PRIORITY_PROCESSING    95  // Generic datum processor. Replaces objects processor.
#define SS_PRIORITY_PLANTS        90  // Plant processing, slow ticks.
#define SS_PRIORITY_VINES         50  // Spreading vine effects.
#define SS_PRIORITY_MOB_AI        45  // Mob AI logic; finding targets, attacking, etc.
#define SS_PRIORITY_AUTO_MOVE     42  // Automated atom movement, fires much more frequently than MOB_AI.
#define SS_PRIORITY_NANO          40  // Updates to nanoui uis.
#define SS_PRIORITY_TURF          30  // Radioactive walls/blob.
#define SS_PRIORITY_EVAC          30  // Processes the evac controller.
#define SS_PRIORITY_CIRCUIT       30  // Processing Circuit's ticks and all that
#define SS_PRIORITY_GRAPH         30  // Merging and splitting of graphs
#define SS_PRIORITY_CHAR_SETUP    25  // Writes player preferences to savefiles.
#define SS_PRIORITY_COMPUTER_NETS 25  // Handles computer network devices hookups
#define SS_PRIORITY_GARBAGE       20  // Garbage collection.
#define SS_PRIORITY_WEATHER       10  // Weather processing.
#define SS_PRIORITY_DAYCYCLE      10  // Day cycle processing on planetoids
#define SS_PRIORITY_BLOB           0  // Blob processing.
#define SS_PRIORITY_ITEM_EFFECTS   0  // Weapon effect processing.

// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)
