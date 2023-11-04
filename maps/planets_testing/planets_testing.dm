#if !defined(USING_MAP_DATUM)

	//Include Static Planet
	#include "../planets/test_planet/test_planet.dm"

	#define USING_MAP_DATUM /datum/map/planet_testing

	///Tells the base planet gen code to create planets even if UNIT_TEST is defined
	#define PLANET_UNIT_TEST 1

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Planet Testing

#endif
