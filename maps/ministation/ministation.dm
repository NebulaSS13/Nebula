/*
Ministation "Zebra"
A butchered variant on Giacom's Ministation designed for 5 to 10 players.
Now poorly imported for Nebula!
And then imported back to ScavStation!
And then copied back upstream to Neb...
Twice...
*/

#if !defined(USING_MAP_DATUM)

	#define USING_MAP_DATUM /datum/map/ministation

	#ifdef UNIT_TEST
		#include "../../code/unit_tests/offset_tests.dm"
	#endif

	#include "../../mods/gamemodes/cult/_cult.dme"
	#include "../../mods/gamemodes/heist/_heist.dme"
	#include "../../mods/gamemodes/ninja/_ninja.dme"
	#include "../../mods/gamemodes/revolution/_revolution.dme"
	#include "../../mods/gamemodes/traitor/_traitor.dme"
	#include "../../mods/gamemodes/spyvspy/_spyvspy.dme"
	#include "../../mods/gamemodes/mixed/_mixed.dme"

	#include "../random_ruins/exoplanet_ruins/playablecolony/playablecolony.dm"

	#include "../../mods/content/xenobiology/_xenobiology.dme"
	#include "../../mods/content/corporate/_corporate.dme"
	#include "../../mods/content/matchmaking/_matchmaking.dme"
	#include "../../mods/species/ascent/_ascent.dme"
	#include "../../mods/species/neoavians/_neoavians.dme"
	#include "../../mods/content/pheromones/_pheromones.dme"
	#include "../../mods/species/serpentid/_serpentid.dme"
	#include "../../mods/species/bayliens/_bayliens.dme"
	#include "../../mods/content/mundane.dm"
	#include "../../mods/content/bigpharma/_bigpharma.dme"
	#include "../../mods/content/government/_government.dme"
	#include "../../mods/content/modern_earth/_modern_earth.dme"
	#include "../../mods/content/mouse_highlights/_mouse_highlight.dme"
	#include "../../mods/content/scaling_descriptors.dm"

	#include "ministation_antagonists.dm"
	#include "ministation_areas.dm"
	#include "ministation_departments.dm"
	#include "ministation_documents.dm"
	#include "ministation_jobs.dm"
	#include "ministation_shuttles.dm"
	#include "ministation_objects.dm"
	#include "ministation_unit_testing.dm"
	#include "ministation_overrides.dm"

	#include "ministation-0.dmm"
	#include "ministation-1.dmm"
	#include "ministation-2.dmm"
	#include "ministation-3.dmm"
	#include "space.dmm"

	#include "../away/bearcat/bearcat.dm"
	#include "../away/casino/casino.dm"
	#include "../away/derelict/derelict.dm"
	#include "../away/errant_pisces/errant_pisces.dm"
	#include "../away/lost_supply_base/lost_supply_base.dm"
	#include "../away/magshield/magshield.dm"
	#include "../away/mining/mining.dm"
	#include "../away/mobius_rift/mobius_rift.dm"
	#include "../away/smugglers/smugglers.dm"
	#include "../away/slavers/slavers_base.dm"
	#include "../away/unishi/unishi.dm"
	#include "../away/yacht/yacht.dm"
	#include "../away/liberia/liberia.dm"

	#include "../../mods/mobs/dionaea/_dionaea.dme"
	#include "../../mods/mobs/borers/_borers.dme"

	// Must come after borers for compatibility.
	#include "../../mods/content/psionics/_psionics.dme"

	#include "ministation_overmap.dm"

	#include "jobs/command.dm"
	#include "jobs/civilian.dm"
	#include "jobs/engineering.dm"
	#include "jobs/medical.dm"
	#include "jobs/security.dm"
	#include "jobs/science.dm"
	#include "jobs/tradehouse.dm"
	#include "jobs/synthetics.dm"

	#include "outfits/_outfits.dm"
	#include "outfits/command.dm"
	#include "outfits/civilian.dm"
	#include "outfits/engineering.dm"
	#include "outfits/medical.dm"
	#include "outfits/science.dm"
	#include "outfits/security.dm"
	#include "outfits/tradehouse.dm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring ministation.

#endif