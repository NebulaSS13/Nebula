#if !defined(using_map_DATUM)
	#include "tradeship_unit_testing.dm"

	#include "../../code/datums/music_tracks/businessend.dm"
	#include "../../code/datums/music_tracks/salutjohn.dm"

	#include "tradeship_items.dm"
	#include "tradeship_areas.dm"
	#include "tradeship_jobs.dm"
	#include "tradeship_lobby.dm"
	#include "tradeship_spawnpoints.dm"
	#include "tradeship_shuttles.dm"
	#include "tradeship_overmap.dm"
	#include "tradeship_overrides.dm"
	#include "tradeship_loadouts.dm"
	#include "tradeship-1.dmm"
	#include "tradeship-2.dmm"
	#include "tradeship-3.dmm"

	#define using_map_DATUM /datum/map/tradeship

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Tradeship

#endif
