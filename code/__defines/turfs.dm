#define TURF_REMOVE_CROWBAR     BITFLAG(0)
#define TURF_REMOVE_SCREWDRIVER BITFLAG(1)
#define TURF_REMOVE_SHOVEL      BITFLAG(2)
#define TURF_REMOVE_WRENCH      BITFLAG(3)
#define TURF_CAN_BREAK          BITFLAG(4)
#define TURF_CAN_BURN           BITFLAG(5)
#define TURF_IS_FRAGILE         BITFLAG(6)
#define TURF_ACID_IMMUNE        BITFLAG(7)
#define TURF_IS_WET             BITFLAG(8)
#define TURF_HAS_RANDOM_BORDER  BITFLAG(9)

//Used for floor/wall smoothing
#define SMOOTH_NONE 0	//Smooth only with itself
#define SMOOTH_ALL 1	//Smooth with all of type
#define SMOOTH_WHITELIST 2	//Smooth with a whitelist of subtypes
#define SMOOTH_BLACKLIST 3 //Smooth with all but a blacklist of subtypes

#define RANGE_TURFS(CENTER, RADIUS) block(max(CENTER.x-(RADIUS), 1), max(CENTER.y-(RADIUS),1), CENTER.z, min(CENTER.x+(RADIUS), world.maxx), min(CENTER.y+(RADIUS), world.maxy), CENTER.z)
#define Z_ALL_TURFS(Z) block(1, 1, Z, world.maxx, world.maxy)

//Here are a few macros to help with people always forgetting to round the coordinates somewhere, and forgetting that not everything automatically rounds decimals.
///Helper macro for the x coordinate of the turf at the center of the world. Handles rounding.
#define WORLD_CENTER_X ceil((1 + world.maxx) / 2)
///Helper macro for the y coordinate of the turf at the center of the world. Handles rounding.
#define WORLD_CENTER_Y ceil((1 + world.maxy) / 2)
///Helper macro for getting the center turf on a given z-level. Handles rounding.
#define WORLD_CENTER_TURF(Z) locate(WORLD_CENTER_X, WORLD_CENTER_Y, Z)
///Helper macro to check if a position is within the world's bounds.
#define IS_WITHIN_WORLD(X, Y) ((X > 0) && (Y > 0) && (X <= world.maxx) && (Y <= world.maxy))
///Helper macro for printing to text the world's x,y,z size to a string.
#define WORLD_SIZE_TO_STRING "[world.maxx]x[world.maxy]x[world.maxz]"

#define FLOOR_EDGE_NONE -1
#define FLOOR_LAYER_CONSTANT     0.001
#define FLOOR_LAYER_OCEAN        (10 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_SEAFLOOR      (11 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_VOLCANIC      (12 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_DIRT          (20 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_BARREN        (21 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_CLAY          (21 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_MUD           (22 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_SAND          (30 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_CHLORINE_SAND (50 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_WATER         (50 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_GRASS         (55 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_PATH          (60 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_GRASS_WILD    (65 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_SNOW          (70 * FLOOR_LAYER_CONSTANT)
#define FLOOR_EDGE_CARPET        (75 * FLOOR_LAYER_CONSTANT)
