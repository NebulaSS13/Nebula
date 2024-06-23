//Redefinitions of the diagonal directions so they can be stored in one var without conflicts
#define N_NORTH     2
#define N_SOUTH     4
#define N_EAST      16
#define N_WEST      256
#define N_NORTHEAST 32
#define N_NORTHWEST 512
#define N_SOUTHEAST 64
#define N_SOUTHWEST 1024

#define CORNER_NONE             0
#define CORNER_COUNTERCLOCKWISE 1
#define CORNER_DIAGONAL         2
#define CORNER_CLOCKWISE        4
// Aquarium-specific corners (due to ordering requirements)
#define CORNER_EASTWEST         CORNER_COUNTERCLOCKWISE
#define CORNER_NORTHSOUTH       CORNER_CLOCKWISE

#define FIRST_DIR(X) ((X) & -(X))

/*
	turn() is weird:
		turn(icon, angle) turns icon by angle degrees clockwise
		turn(matrix, angle) turns matrix by angle degrees clockwise
		turn(dir, angle) turns dir by angle degrees counter-clockwise
*/

/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs)) return

	var/list/ret = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)

	for(var/i = 1 to ret.len)
		var/dir = ret[i]
		. = CORNER_NONE
		if(dir in dirs)
			. |= CORNER_DIAGONAL
		if(turn(dir,45) in dirs)
			. |= CORNER_COUNTERCLOCKWISE
		if(turn(dir,-45) in dirs)
			. |= CORNER_CLOCKWISE
		ret[i] = "[.]"

	return ret

/proc/corner_states_to_dirs(list/corners)
	if(!istype(corners)) return

	var/list/ret = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)
	. = list()

	for(var/i = 1 to ret.len)
		var/dir = ret[i]
		var/corner = text2num(corners[i])
		if(corner & CORNER_DIAGONAL)
			. |= dir
		if(corner & CORNER_COUNTERCLOCKWISE)
			. |= turn(dir, 45)
		if(corner & CORNER_CLOCKWISE)
			. |= turn(dir, -45)

// Similar to dirs_to_corner_states(), but returns an *ordered* list, requiring (in order), dir=NORTH, SOUTH, EAST, WEST
// Note that this means this proc can be used as:

//	var/list/corner_states = dirs_to_unified_corner_states(directions)
//	for(var/index = 1 to 4)
//		var/image/I = image(icon, icon_state = corner_states[index], dir = BITFLAG(index - 1))
//		[...]

/proc/dirs_to_unified_corner_states(list/dirs)
	if(!istype(dirs)) return

	var/NE = CORNER_NONE
	var/NW = CORNER_NONE
	var/SE = CORNER_NONE
	var/SW = CORNER_NONE

	if(NORTH in dirs)
		NE |= CORNER_NORTHSOUTH
		NW |= CORNER_NORTHSOUTH
	if(SOUTH in dirs)
		SW |= CORNER_NORTHSOUTH
		SE |= CORNER_NORTHSOUTH
	if(EAST in dirs)
		SE |= CORNER_EASTWEST
		NE |= CORNER_EASTWEST
	if(WEST in dirs)
		NW |= CORNER_EASTWEST
		SW |= CORNER_EASTWEST
	if(NORTHWEST in dirs)
		NW |= CORNER_DIAGONAL
	if(NORTHEAST in dirs)
		NE |= CORNER_DIAGONAL
	if(SOUTHEAST in dirs)
		SE |= CORNER_DIAGONAL
	if(SOUTHWEST in dirs)
		SW |= CORNER_DIAGONAL

	return list("[NE]", "[NW]", "[SE]", "[SW]")

#undef CORNER_NONE

#undef CORNER_COUNTERCLOCKWISE
#undef CORNER_CLOCKWISE
#undef CORNER_EASTWEST
#undef CORNER_DIAGONAL
#undef CORNER_NORTHSOUTH
