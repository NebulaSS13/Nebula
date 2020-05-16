#if !defined(USING_MAP_DATUM)

	#define DISABLE_DEBUG_CRASH

	#include "../../mods/persistence/_persistence.dme"

	#include "../../code/datums/music_tracks/dirtyoldfrogg.dm"

	#include "persistence_defines.dm"

	#include "outreach_areas.dm"
	#include "outreach_jobs.dm"
	#include "outreach_exoplanet.dm"
	// #include "example_unit_testing.dm"

	#include "outreach_1_mine_2.dmm"
	#include "outreach_2_mine_1.dmm"
	#include "outreach_3_ground.dmm"
	#include "outreach_4_sky.dmm"

	#define USING_MAP_DATUM /datum/map/persistence
#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Outreach

#endif
