#define TURF_REMOVE_CROWBAR     1
#define TURF_REMOVE_SCREWDRIVER 2
#define TURF_REMOVE_SHOVEL      4
#define TURF_REMOVE_WRENCH      8
#define TURF_CAN_BREAK          16
#define TURF_CAN_BURN           32
#define TURF_HAS_EDGES  		64
#define TURF_HAS_CORNERS		128
#define TURF_HAS_INNER_CORNERS	256
#define TURF_IS_FRAGILE         512
#define TURF_ACID_IMMUNE        1024
#define TURF_IS_WET             2048
#define TURF_HAS_RANDOM_BORDER	4096

//Used for floor/wall smoothing
#define SMOOTH_NONE 0	//Smooth only with itself
#define SMOOTH_ALL 1	//Smooth with all of type
#define SMOOTH_WHITELIST 2	//Smooth with a whitelist of subtypes
#define SMOOTH_BLACKLIST 3 //Smooth with all but a blacklist of subtypes

#define RANGE_TURFS(CENTER, RADIUS) block(locate(max(CENTER.x-(RADIUS), 1), max(CENTER.y-(RADIUS),1), CENTER.z), locate(min(CENTER.x+(RADIUS), world.maxx), min(CENTER.y+(RADIUS), world.maxy), CENTER.z))
#define BLOCK_TURFS(X1, Y1, X2, Y2, Z) block(locate(X1, Y1, Z), locate(X2, Y2, Z))

//Here are a few macros to help with people always forgetting to round the coordinates somewhere, and forgetting that not everything automatically rounds decimals.
///Helper macro for the x coordinate of the turf at the center of the world. Handles rounding.
#define WORLD_CENTER_X round(world.maxx / 2)
///Helper macro for the y coordinate of the turf at the center of the world. Handles rounding.
#define WORLD_CENTER_Y round(world.maxy / 2)
///Helper macro for getting the center turf on a given z-level. Handles rounding.
#define WORLD_CENTER_TURF(Z) locate(WORLD_CENTER_X, WORLD_CENTER_Y, Z)
///Helper macro to check if a position is within the world's bounds.
#define IS_WITHIN_WORLD(X, Y) ((X > 0) && (Y > 0) && (X <= world.maxx) && (Y <= world.maxy))
///Helper macro for printing to text the world's x,y,z size to a string.
#define WORLD_SIZE_TO_STRING "[world.maxx]x[world.maxy]x[world.maxz]"

#define EXT_LAYER_CONSTANT     0.001
#define EXT_EDGE_OCEAN         (10 * EXT_LAYER_CONSTANT)
#define EXT_EDGE_SEAFLOOR      (11 * EXT_LAYER_CONSTANT)
#define EXT_EDGE_VOLCANIC      (12 * EXT_LAYER_CONSTANT)
#define EXT_EDGE_DIRT          (20 * EXT_LAYER_CONSTANT)
#define EXT_EDGE_BARREN        (21 * EXT_LAYER_CONSTANT)
#define EXT_EDGE_MUD           (21 * EXT_LAYER_CONSTANT)
#define EXT_EDGE_MUD_DARK      (22 * EXT_LAYER_CONSTANT)
#define EXT_EDGE_SAND          (30 * EXT_LAYER_CONSTANT)
#define EXT_EDGE_CHLORINE_SAND (31 * EXT_LAYER_CONSTANT)
#define EXT_EDGE_WATER         (40 * EXT_LAYER_CONSTANT)
#define EXT_EDGE_GRASS         (51 * EXT_LAYER_CONSTANT)
#define EXT_EDGE_GRASS_WILD    (52 * EXT_LAYER_CONSTANT)
#define EXT_EDGE_SNOW          (60 * EXT_LAYER_CONSTANT)
