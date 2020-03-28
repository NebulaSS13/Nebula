#if !defined(using_map_DATUM)

	#include "..\..\code\content_packages\misc\mundane.dm"
	#include "..\..\code\content_packages\misc\spacemen.dm"
	#include "..\..\code\content_packages\corporate\_corporate.dme"
	#include "..\..\code\content_packages\government\_government.dme"
	#include "..\..\code\content_packages\psionics\_psionics.dme"
	#include "..\..\code\content_packages\ascent\_ascent.dme"
	#include "..\..\code\content_packages\modern_earth\_modern_earth.dme"
	#include "..\..\code\content_packages\dionaea\_dionaea.dme"

	#include "example_areas.dm"
	#include "example_shuttles.dm"
	#include "example_unit_testing.dm"

	#include "example-1.dmm"
	#include "example-2.dmm"
	#include "example-3.dmm"

	#define using_map_DATUM /datum/map/example

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Example

#endif
