#if !defined(using_map_DATUM)

	#include "../../mods/misc/mundane.dm"
	#include "../../mods/corporate/_corporate.dme"
	#include "../../mods/ascent/_ascent.dme"
	#include "../../mods/psionics/_psionics.dme"

	#include "jobs/captain.dm"
	#include "jobs/civilian.dm"
	#include "jobs/engineering.dm"
	#include "jobs/medical.dm"
	#include "jobs/science.dm"
	#include "jobs/security.dm"

	#include "outfits/cargo.dm"
	#include "outfits/civilian.dm"
	#include "outfits/command.dm"
	#include "outfits/engineering.dm"
	#include "outfits/medical.dm"
	#include "outfits/science.dm"
	#include "outfits/security.dm"

	#include "exodus_announcements.dm"
	#include "exodus_antagonism.dm"
	#include "exodus_areas.dm"
	#include "exodus_elevator.dm"
	#include "exodus_jobs.dm"
	#include "exodus_loadout.dm"
	#include "exodus_overmap.dm"
	#include "exodus_shuttles.dm"
	#include "exodus_unit_testing.dm"
	#include "exodus-1.dmm"
	#include "exodus-2.dmm"
	#include "exodus-transit.dmm"

	#define using_map_DATUM /datum/map/exodus

#elif !defined(MAP_OVERRIDE)
	#warn A map has already been included, ignoring Exodus
#endif
