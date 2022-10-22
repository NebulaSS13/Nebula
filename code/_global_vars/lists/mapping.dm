var/global/list/cardinal =    list(NORTH, SOUTH, EAST, WEST)
var/global/list/cardinalz =   list(NORTH, SOUTH, EAST, WEST, UP, DOWN)
var/global/list/cornerdirs =  list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/global/list/cornerdirsz = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST, NORTH|UP, EAST|UP, WEST|UP, SOUTH|UP, NORTH|DOWN, EAST|DOWN, WEST|DOWN, SOUTH|DOWN)
var/global/list/alldirs =     list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/global/list/cabledirs =   list(0, NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST, UP, DOWN)
var/global/list/reverse_dir = list( // reverse_dir[dir] = reverse of dir
	     2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15,
	32, 34, 33, 35, 40, 42,	41, 43, 36, 38, 37, 39, 44, 46, 45, 47,
	16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21,	23, 28, 30, 29, 31,
	48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63
)

var/global/list/adjacentdirs = list( // adjacentdirs[dir] = list of directions adjacent to that direction
	    12, 12, 12,  3, 15, 15, 15,  3, 15, 15, 15,  3, 15, 15, 15,
	16,	28, 28, 28, 19, 31, 31, 31, 19, 31, 31, 31, 31, 31, 31, 31, // UP - Same as first line but +16
	32,	44,	44, 44, 35, 47, 47, 47, 35, 47, 47, 47, 35, 47, 47, 47, // DOWN - Same as first line but +32
	48,	60, 60,	60, 51, 63, 63, 63, 51, 63, 63, 63, 51, 63, 63, 63  // UP+DOWN - Same as first line but +48
)

// global.flip_dir[dir] = 180 degree rotation of dir. Unlike reverse_dir, UP remains UP & DOWN remains DOWN.
var/global/list/flip_dir = list(
	     2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15,
	16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21, 23, 28, 30, 29, 31, // UP - Same as first line but +16
	32, 34, 33, 35, 40, 42, 41, 43, 36, 38, 37, 39, 44, 46, 45, 47, // DOWN - Same as first line but +32
	48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63  // UP+DOWN - Same as first line but +48
)

// global.cw_dir[dir] = clockwise rotation of dir. Unlike reverse_dir, UP remains UP & DOWN remains DOWN.
var/global/list/cw_dir = list(
	     4,  8, 12,  2,  6, 10, 14,  1,  5,  9, 13,  3,  7, 11, 15,
	16, 20, 24, 28, 18, 22, 26, 30, 17, 21, 25, 19, 29, 23, 27, 31, // UP - Same as first line but +16
	32, 36, 40, 44, 34, 38, 42, 46, 33, 37, 41, 45, 35, 39, 43, 47, // DOWN - Same as first line but +32
	48, 52, 56, 40, 50, 54, 58, 62, 49, 53, 57, 61, 51, 55, 59, 63  // UP+DOWN - Same as first line but +48
)

// global.ccw_dir[dir] = counter-clockwise rotation of dir. Unlike reverse_dir, UP remains UP & DOWN remains DOWN.
var/global/list/ccw_dir = list(
	     8,  4, 12,  1,  9,  5, 13,  2, 10,  6, 14,  3, 11,  7, 15,
	16, 24, 20, 28, 17, 25, 21, 29, 18, 26, 22, 30, 19, 27, 23, 31, // UP - Same as first line but +16
	32, 40, 36, 44, 33, 41, 37, 45, 34, 42, 38, 46, 35, 43, 39, 47, // DOWN - Same as first line but +32
	48, 56, 52, 60, 49, 57, 53, 61, 50, 58, 54, 62, 51, 59, 55, 63  // UP+DOWN - Same as first line but +48
)
