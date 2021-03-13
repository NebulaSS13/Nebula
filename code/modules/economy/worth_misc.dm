/obj/item/disk/survey/get_base_value()
	. = holographic ? 0 : (sqrt(data) * 5)

/obj/machinery/power/supermatter/get_value_multiplier()
	. = 1

// Arbitrary values (TODO remove as many of these as possible)
#define ARBITRARY_WORTH(PATH, AMT)    \
PATH/get_value_multiplier() { . = 1 } \
PATH/get_base_value() { . = AMT }

ARBITRARY_WORTH(/obj/machinery/power/supermatter,    2000)
ARBITRARY_WORTH(/obj/machinery/power/emitter,        700)
ARBITRARY_WORTH(/obj/machinery/the_singularitygen,   700)
ARBITRARY_WORTH(/obj/structure/ship_munition,        500)
ARBITRARY_WORTH(/obj/machinery/power/rad_collector,  500)
ARBITRARY_WORTH(/obj/structure/particle_accelerator, 500) 