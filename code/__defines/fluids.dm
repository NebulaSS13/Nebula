#define FLUID_QDEL_POINT 1           // Depth a fluid begins self-deleting
#define FLUID_MINIMUM_TRANSFER 5     // Minimum amount that a flowing fluid will transfer from one turf to another.
#define FLUID_PUDDLE 25              // Minimum total depth that a fluid needs before it will start spreading.
#define FLUID_SLURRY 50              // Mimimum depth before fluids will move solids as reagents.
#define FLUID_SHALLOW 200            // Depth shallow icon is used
#define FLUID_OVER_MOB_HEAD 300      // Depth icon layers over mobs.
#define FLUID_DEEP 800               // Depth deep icon is used
#define FLUID_VERY_DEEP FLUID_DEEP*2 // Solid fill icon is used
#define FLUID_MAX_DEPTH FLUID_DEEP*4 // Arbitrary max value for flooding.
#define FLUID_PUSH_THRESHOLD 20      // Amount of flow needed to push items.
/turf
	var/_fluid_source_is_active = FALSE
	var/_fluid_turf_is_active = FALSE

// Expects /turf for TURF.
#define ADD_ACTIVE_FLUID_SOURCE(TURF)                                         \
if(!QDELETED(TURF) && !TURF.changing_turf && !TURF._fluid_source_is_active) { \
	TURF._fluid_source_is_active = TRUE;                                      \
	SSfluids.water_sources += TURF;                                           \
}

#define REMOVE_ACTIVE_FLUID_SOURCE(TURF)                                      \
if(!QDELETED(TURF) && TURF._fluid_source_is_active) {                         \
	TURF._fluid_source_is_active = FALSE;                                     \
	SSfluids.water_sources -= TURF;                                           \
}

#define ADD_ACTIVE_FLUID(TURF)                                                \
if(!QDELETED(TURF) && !TURF._fluid_turf_is_active) {                          \
	TURF._fluid_turf_is_active = TRUE;                                        \
	SSfluids.active_fluids += TURF;                                           \
}

#define REMOVE_ACTIVE_FLUID(TURF)                                             \
if(!QDELETED(TURF) && TURF._fluid_turf_is_active) {                           \
	TURF._fluid_turf_is_active = FALSE;                                       \
	SSfluids.active_fluids -= TURF;                                           \
}

#define UPDATE_FLUID_BLOCKED_DIRS(TURF)                                       \
if(isnull(TURF.fluid_blocked_dirs)) {                                         \
	TURF.fluid_blocked_dirs = 0;                                              \
	for(var/obj/structure/window/W in TURF) {                                 \
		if(W.density) TURF.fluid_blocked_dirs |= W.dir;                       \
	}                                                                         \
	for(var/obj/machinery/door/window/D in TURF) {                            \
		if(D.density) TURF.fluid_blocked_dirs |= D.dir;                       \
	}                                                                         \
}

#define FLUID_MAX_ALPHA 200
#define FLUID_MIN_ALPHA 96
#define TANK_WATER_MULTIPLIER 5