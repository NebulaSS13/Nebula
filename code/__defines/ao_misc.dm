/*
Define for getting a bitfield of adjacent turfs that meet a condition.
 ORIGIN is the object to step from, VAR is the var to write the bitfield to
 TVAR is the temporary turf variable to use, FUNC is the condition to check.
 FUNC generally should reference TVAR.
 example:
	var/turf/T
	var/result = 0
	CALCULATE_NEIGHBORS(src, result, T, isopenturf(T))
*/
#define CALCULATE_NEIGHBORS(ORIGIN, VAR, TVAR, FUNC)            \
	for (var/_tdir in global.cardinal) {                        \
		TVAR = get_step_resolving_mimic(ORIGIN, _tdir);         \
		if ((TVAR) && (FUNC)) {                                 \
			VAR |= BITFLAG(_tdir);                              \
		}                                                       \
	}                                                           \
	if (VAR & N_NORTH) {                                        \
		if (VAR & N_WEST) {                                     \
			TVAR = get_step_resolving_mimic(ORIGIN, NORTHWEST); \
			if (FUNC) {                                         \
				VAR |= N_NORTHWEST;                             \
			}                                                   \
		}                                                       \
		if (VAR & N_EAST) {                                     \
			TVAR = get_step_resolving_mimic(ORIGIN, NORTHEAST); \
			if (FUNC) {                                         \
				VAR |= N_NORTHEAST;                             \
			}                                                   \
		}                                                       \
	}                                                           \
	if (VAR & N_SOUTH) {                                        \
		if (VAR & N_WEST) {                                     \
			TVAR = get_step_resolving_mimic(ORIGIN, SOUTHWEST); \
			if (FUNC) {                                         \
				VAR |= N_SOUTHWEST;                             \
			}                                                   \
		}                                                       \
		if (VAR & N_EAST) {                                     \
			TVAR = get_step_resolving_mimic(ORIGIN, SOUTHEAST); \
			if (FUNC) {                                         \
				VAR |= N_SOUTHEAST;                             \
			}                                                   \
		}                                                       \
	}
