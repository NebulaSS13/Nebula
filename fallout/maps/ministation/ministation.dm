/*
Ministation "Zebra"
A butchered variant on Giacom's Ministation designed for 5 to 10 players.
Now poorly imported for Nebula!
*/

#if !defined(USING_MAP_DATUM)

/*
	#include "../../mods/content/xenobiology/_xenobiology.dme"
	#include "../../mods/content/corporate/_corporate.dme"
	#include "../../mods/content/matchmaking/_matchmaking.dme"
	#include "../../mods/species/serpentid/_serpentid.dme"*/
	#include "../../../mods/content/fallout/_aridhearts.dme"

	#define USING_MAP_DATUM /datum/map/ministation


	#include "ministation.dmm"
	#include "space.dmm"
	#include "ministation_unit_testing.dm"


	#include "ministation_areas.dm"
	#include "ministation_departments.dm"

	#include "ministation_jobs.dm"
	#include "ministation_shuttles.dm"



	//#include "fallout_areas.dm"
	//#include "fallout_turf.dm"



#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring ministation.

#endif