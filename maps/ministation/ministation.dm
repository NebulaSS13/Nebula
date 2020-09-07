/*
Ministation "Zebra"
A butchered variant on Giacom's Ministation designed for 5 to 10 players.
Now poorly imported for Nebula!
*/

#if !defined(USING_MAP_DATUM)

	#include "../../mods/corporate/_corporate.dme"
	#include "../../mods/ascent/_ascent.dme"

	#define USING_MAP_DATUM /datum/map/ministation

	#include "ministation.dmm"
	#include "space.dmm"
	#include "ministation_unit_testing.dm"

	#include "ministation_antagonists.dm"
	#include "ministation_areas.dm"
	#include "ministation_telecomms.dm"
	#include "ministation_jobs.dm"
	#include "ministation_shuttles.dm"
	#include "ministation_objects.dm"

	#include "jobs/_jobs.dm"
	#include "jobs/command.dm"
	#include "jobs/civilian.dm"
	#include "jobs/engineering.dm"
	#include "jobs/medical.dm"
	#include "jobs/security.dm"
	#include "jobs/science.dm"

	#include "outfits/_outfits.dm"
	#include "outfits/command.dm"
	#include "outfits/civilian.dm"
	#include "outfits/engineering.dm"
	#include "outfits/medical.dm"
	#include "outfits/science.dm"
	#include "outfits/security.dm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring ministation.

#endif