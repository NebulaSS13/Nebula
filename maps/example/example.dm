#if !defined(USING_MAP_DATUM)

	#include "..\..\mods\misc\mundane.dm"
	#include "..\..\mods\corporate\_corporate.dme"
	#include "..\..\mods\government\_government.dme"
	#include "..\..\mods\psionics\_psionics.dme"
	#include "..\..\mods\borers\_borers.dme"
	#include "..\..\mods\ascent\_ascent.dme"
	#include "..\..\mods\modern_earth\_modern_earth.dme"
	#include "..\..\mods\dionaea\_dionaea.dme"

	#include "example_areas.dm"
	#include "example_shuttles.dm"
	#include "example_unit_testing.dm"

	#include "example-1.dmm"
	#include "example-2.dmm"
	#include "example-3.dmm"

	#define USING_MAP_DATUM /datum/map/example

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Example

#endif
