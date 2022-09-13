#define FLUID_QDEL_POINT 1           // Depth a fluid begins self-deleting
#define FLUID_MINIMUM_TRANSFER 10    // Minimum amount that a flowing fluid will transfer from one turf to another.
#define FLUID_PUDDLE 25              // Minimum total depth that a fluid needs before it will start spreading.
#define FLUID_SHALLOW 200            // Depth shallow icon is used
#define FLUID_OVER_MOB_HEAD 300      // Depth icon layers over mobs.
#define FLUID_DEEP 800               // Depth deep icon is used
#define FLUID_MAX_DEPTH FLUID_DEEP*4 // Arbitrary max value for flooding.
#define FLUID_PUSH_THRESHOLD 20      // Amount of flow needed to push items.

// Expects /turf for T.
#define ADD_ACTIVE_FLUID_SOURCE(T)    SSflooding.water_sources[T] = TRUE;
#define REMOVE_ACTIVE_FLUID_SOURCE(T) SSflooding.water_sources -= T;
#define ADD_ACTIVE_FLUID(T)           SSfluids.active_fluids[T] = TRUE;
#define REMOVE_ACTIVE_FLUID(T)        SSfluids.active_fluids -= T;
#define UPDATE_FLUID_BLOCKED_DIRS(T)                                      \
	if(isnull(T.fluid_blocked_dirs)) {                                    \
		T.fluid_blocked_dirs = 0;                                         \
		for(var/atom/movable/AM as anything in T) {                       \
			if(AM.density && (AM.atom_flags & ATOM_FLAG_CHECKS_BORDER)) { \
				T.fluid_blocked_dirs |= AM.dir;                           \
			}                                                             \
		}                                                                 \
	}

#define FLUID_MAX_ALPHA 200
#define FLUID_MIN_ALPHA 45
#define TANK_WATER_MULTIPLIER 5