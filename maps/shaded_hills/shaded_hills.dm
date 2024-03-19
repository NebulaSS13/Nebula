#if !defined(USING_MAP_DATUM)

	#include "../../mods/content/matchmaking/_matchmaking.dme"
	#include "../../mods/content/mouse_highlights/_mouse_highlight.dme"
	#include "../../mods/content/scaling_descriptors.dm"
	#include "../../mods/species/fantasy/_fantasy.dme"

	#include "areas/_areas.dm"
	#include "jobs/_jobs.dm"
	#include "levels/_levels.dm"
	#include "outfits/_outfits.dm"

	#include "shaded_hills_currency.dm"
	#include "shaded_hills_skills.dm"
	#include "shaded_hills_turfs.dm"

	#include "shaded_hills-1.dmm"

	#define USING_MAP_DATUM /datum/map/shaded_hills

#elif !defined(MAP_OVERRIDE)
	#warn A map has already been included, ignoring Shaded Hills
#endif
