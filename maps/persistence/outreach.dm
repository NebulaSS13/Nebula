#if !defined(USING_MAP_DATUM)
	// Mods
	#include "../../mods/persistence/_persistence.dme"
	#include "../../mods/ascent/_ascent.dme"

	// Lobby stuff
	#include "../../code/datums/music_tracks/dirtyoldfrogg.dm"

	#include "persistence_defines.dm"

	#include "outreach_areas.dm"
	#include "outreach_jobs.dm"
	#include "outreach_exoplanet.dm"
	// #include "example_unit_testing.dm"

	#define USING_MAP_DATUM /datum/map/persistence
#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Outreach

#endif
