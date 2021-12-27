#if !defined(USING_MAP_DATUM)

	#include "debug_areas.dm"
	#include "debug_shuttles.dm"
	#include "debug_departments.dm"
	#include "debug_jobs.dm"
	#include "debug_unit_testing.dm"

	#include "debug-1.dmm"
	#include "debug-2.dmm"
	#include "debug-3.dmm"

	#define USING_MAP_DATUM /datum/map/debug

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Testing Site

#endif
