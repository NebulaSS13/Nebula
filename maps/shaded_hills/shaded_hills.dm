#if !defined(USING_MAP_DATUM)

	#include "../../mods/content/matchmaking/_matchmaking.dme"
	#include "../../mods/content/mouse_highlights/_mouse_highlight.dme"
	#include "../../mods/content/scaling_descriptors.dm"
	#include "../../mods/species/drakes/_drakes.dme" // include before _fantasy.dme so overrides work
	#include "../../mods/content/fantasy/_fantasy.dme"

	#include "_shaded_hills_defines.dm"

	#include "areas/_areas.dm"
	#include "areas/downlands.dm"
	#include "areas/grassland.dm"
	#include "areas/swamp.dm"
	#include "areas/woods.dm"

	#include "jobs/_jobs.dm"
	#include "jobs/caves.dm"
	#include "jobs/inn.dm"
	#include "jobs/shrine.dm"
	#include "jobs/visitors.dm"
	#include "jobs/wilderness.dm"

	#include "submaps/_submaps.dm"
	#include "submaps/downlands/_downlands.dm"
	#include "submaps/grassland/_grassland.dm"
	#include "submaps/swamp/_swamp.dm"
	#include "submaps/woods/_woods.dm"
	#include "submaps/woods/bear_den/bear_den.dm"
	#include "submaps/woods/fairy_rings/fairy_rings.dm"
	#include "submaps/woods/fox_den/fox_den.dm"
	#include "submaps/woods/hunter_camp/hunter_camp.dm"
	#include "submaps/woods/old_cabin/old_cabin.dm"

	#include "levels/_levels.dm"
	#include "levels/random_map.dm"
	#include "levels/strata.dm"

	#include "outfits/_outfits.dm"
	#include "outfits/caves.dm"
	#include "outfits/inn.dm"
	#include "outfits/shrine.dm"
	#include "outfits/visitors.dm"
	#include "outfits/wilderness.dm"

	#include "shaded_hills_currency.dm"
	#include "shaded_hills_events.dm"
	#include "shaded_hills_locks.dm"
	#include "shaded_hills_map.dm"
	#include "shaded_hills_names.dm"
	#include "shaded_hills_skills.dm"
	#include "shaded_hills_testing.dm"
	#include "shaded_hills_turfs.dm"

	// Caverns are below grassland and must be compiled in that order for multiz.
	#include "shaded_hills-caverns.dmm"
	#include "shaded_hills-grassland.dmm"
	// Dungeon is under inn and must be compiled in that order for multiz.
	#include "shaded_hills-dungeon.dmm"
	#include "shaded_hills-inn.dmm"
	// Other levels are lateral and compile order doesn't matter.
	#include "shaded_hills-swamp.dmm"
	#include "shaded_hills-woods.dmm"

	#define USING_MAP_DATUM /datum/map/shaded_hills

#elif !defined(MAP_OVERRIDE)
	#warn A map has already been included, ignoring Shaded Hills
#endif
