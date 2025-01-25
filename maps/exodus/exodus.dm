#if !defined(USING_MAP_DATUM)

	#include "../../mods/content/mundane.dm"
	#include "../../mods/content/scaling_descriptors.dm"

	#include "../../mods/content/bigpharma/_bigpharma.dme"
	#include "../../mods/content/corporate/_corporate.dme"
	#include "../../mods/content/government/_government.dme"
	#include "../../mods/content/matchmaking/_matchmaking.dme"
	#include "../../mods/content/modern_earth/_modern_earth.dme"
	#include "../../mods/content/mouse_highlights/_mouse_highlight.dme"
	#include "../../mods/content/pheromones/_pheromones.dme"
	#include "../../mods/content/psionics/_psionics.dme"
	#include "../../mods/content/standard_jobs/_standard_jobs.dme"
	#include "../../mods/content/supermatter/_supermatter.dme"
	#include "../../mods/content/xenobiology/_xenobiology.dme"
	#include "../../mods/content/tabloids/_tabloids.dme"

	#include "../../mods/gamemodes/cult/_cult.dme"
	#include "../../mods/gamemodes/heist/_heist.dme"
	#include "../../mods/gamemodes/meteor/_meteor.dme"
	#include "../../mods/gamemodes/ninja/_ninja.dme"
	#include "../../mods/gamemodes/revolution/_revolution.dme"
	#include "../../mods/gamemodes/spyvspy/_spyvspy.dme"
	#include "../../mods/gamemodes/traitor/_traitor.dme"
	#include "../../mods/gamemodes/mixed.dm"

	#include "../../mods/mobs/borers/_borers.dme"
	#include "../../mods/mobs/dionaea/_dionaea.dme"

	#include "../../mods/species/ascent/_ascent.dme"
	#include "../../mods/species/tajaran/_tajaran.dme"
	#include "../../mods/species/unathi/_unathi.dme"
	#include "../../mods/species/skrell/_skrell.dme"
	#include "../../mods/species/adherent/_adherent.dme"
	#include "../../mods/species/tritonian/_tritonian.dme"
	#include "../../mods/species/serpentid/_serpentid.dme"
	#include "../../mods/species/utility_frames/_utility_frames.dme"

	#include "../random_ruins/exoplanet_ruins/playablecolony/playablecolony.dm"
	#include "../random_ruins/exoplanet_ruins/crashed_pod/crashed_pod.dm"

	#include "../../mods/content/government/away_sites/icarus/icarus.dm"
	#include "../../mods/content/corporate/away_sites/lar_maria/lar_maria.dm"

	#include "../away/liberia/liberia.dm"
	#include "../away/bearcat/bearcat.dm"
	#include "../away/casino/casino.dm"
	#include "../away/derelict/derelict.dm"
	#include "../away/errant_pisces/errant_pisces.dm"
	#include "../away/lost_supply_base/lost_supply_base.dm"
	#include "../away/magshield/magshield.dm"
	#include "../away/mining/mining.dm"
	#include "../away/mobius_rift/mobius_rift.dm"
	#include "../away/smugglers/smugglers.dm"
	#include "../away/unishi/unishi.dm"
	#include "../away/yacht/yacht.dm"

	#include "exodus_goals.dm"

	#include "exodus_announcements.dm"
	#include "exodus_antagonism.dm"
	#include "exodus_cameras.dm"
	#include "exodus_areas.dm"
	#include "exodus_elevator.dm"
	#include "exodus_jobs.dm"
	#include "exodus_loadout.dm"
	#include "exodus_overmap.dm"
	#include "exodus_setup.dm"
	#include "exodus_shuttles.dm"
	#include "exodus_unit_testing.dm"

	#include "exodus-1.dmm"
	#include "exodus-2.dmm"
	#include "exodus-admin.dmm"
	#include "exodus-transit.dmm"

	#define USING_MAP_DATUM /datum/map/exodus

#elif !defined(MAP_OVERRIDE)
	#warn A map has already been included, ignoring Exodus
#endif
