#define FLUID_EVAPORATION_POINT 5          // Depth a fluid begins self-deleting
#define FLUID_PUDDLE 25
#define FLUID_SHALLOW 200                  // Depth shallow icon is used
#define FLUID_OVER_MOB_HEAD 300
#define FLUID_DEEP 800                     // Depth deep icon is used
#define FLUID_MAX_DEPTH FLUID_DEEP*4       // Arbitrary max value for flooding.
#define FLUID_PUSH_THRESHOLD 20            // Amount of water flow needed to push items.

// Expects /turf for T.
#define ADD_ACTIVE_FLUID_SOURCE(T)    SSfluids.water_sources[T] = TRUE
#define REMOVE_ACTIVE_FLUID_SOURCE(T) SSfluids.water_sources -= T

// Expects /obj/effect/fluid for F.
#define ADD_ACTIVE_FLUID(F)           SSfluids.active_fluids[F] = TRUE
#define REMOVE_ACTIVE_FLUID(F)        SSfluids.active_fluids -= F

// Expects turf for T,
#define UPDATE_FLUID_BLOCKED_DIRS(T) \
	if(isnull(T.fluid_blocked_dirs)) {\
		T.fluid_blocked_dirs = 0; \
		for(var/obj/structure/window/W in T) { \
			if(W.density) T.fluid_blocked_dirs |= W.dir; \
		} \
		for(var/obj/machinery/door/window/D in T) {\
			if(D.density) T.fluid_blocked_dirs |= D.dir; \
		} \
	}

// We share overlays for all fluid turfs to sync icon animation.
#define APPLY_FLUID_OVERLAY(img_state) \
	if(!SSfluids.fluid_images[img_state]) SSfluids.fluid_images[img_state] = image('icons/effects/liquids.dmi',img_state); \
	add_overlay(SSfluids.fluid_images[img_state]);

#define FLUID_MAX_ALPHA 240
#define FLUID_MIN_ALPHA 45
#define TANK_WATER_MULTIPLIER 5