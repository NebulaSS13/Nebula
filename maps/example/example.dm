#if !defined(USING_MAP_DATUM)

	#ifdef UNIT_TEST
		#include "../../code/unit_tests/offset_tests.dm"
	#endif

	#include "example_areas.dm"
	#include "example_shuttles.dm"
	#include "example_departments.dm"
	#include "example_jobs.dm"
	#include "example_unit_testing.dm"

	#include "example-1.dmm"
	#include "example-2.dmm"
	#include "example-3.dmm"

	#define USING_MAP_DATUM /datum/map/example

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Testing Site

#endif
