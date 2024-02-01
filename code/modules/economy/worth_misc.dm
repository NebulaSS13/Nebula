// Arbitrary values (TODO remove as many of these as possible)
#define ARBITRARY_WORTH(PATH, AMT)    \
PATH/get_value_multiplier() { . = 1 } \
PATH/get_base_value() { . = AMT }

ARBITRARY_WORTH(/obj/machinery/emitter,        700)
ARBITRARY_WORTH(/obj/machinery/rad_collector,  500)
ARBITRARY_WORTH(/obj/structure/particle_accelerator, 500)
