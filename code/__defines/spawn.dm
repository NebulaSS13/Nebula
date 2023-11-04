/// Allows the spawn point to be used for observers spawning.
#define SPAWN_FLAG_GHOSTS_CAN_SPAWN      BITFLAG(0)
/// Allows admin prison releases to use this spawn point.
#define SPAWN_FLAG_PRISONERS_CAN_SPAWN   BITFLAG(1)
/// Allows general job latejoining to use this spawn point.
#define SPAWN_FLAG_JOBS_CAN_SPAWN        BITFLAG(2)
/// Allows persistence decls (currently just bookcases) to use this spawn point.
#define SPAWN_FLAG_PERSISTENCE_CAN_SPAWN BITFLAG(3)