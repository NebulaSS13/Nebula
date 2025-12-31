#if !defined(USING_MAP_DATUM)

	#ifdef UNIT_TEST
		#include "../../code/unit_tests/offset_tests.dm"
	#endif

	#include "../../mods/content/tabloids/_tabloids.dme"

	#include "../random_ruins/exoplanet_ruins/playablecolony/playablecolony.dm"

	#include "../../mods/content/government/away_sites/icarus/icarus.dm"
	#include "../../mods/content/corporate/away_sites/lar_maria/lar_maria.dm"

	#include "../../mods/content/mundane.dm"
	#include "../../mods/content/scaling_descriptors.dm"

	#include "../../mods/content/plant_dissection/_plant_dissection.dme"

	#include "../../mods/content/augments/_augments.dme"
	#include "../../mods/content/beekeeping/_beekeeping.dme"
	#include "../../mods/content/bigpharma/_bigpharma.dme"
	#include "../../mods/content/blob/_blob.dme"
	#include "../../mods/content/breath_holding/_breath_holding.dme"
	#include "../../mods/content/corporate/_corporate.dme"
	#include "../../mods/content/dungeon_loot/_dungeon_loot.dme"
	#include "../../mods/content/government/_government.dme"
	#include "../../mods/content/integrated_electronics/_integrated_electronics.dme"
	#include "../../mods/content/matchmaking/_matchmaking.dme"
	#include "../../mods/content/modern_earth/_modern_earth.dme"
	#include "../../mods/content/mouse_highlights/_mouse_highlight.dme"
	#include "../../mods/content/pheromones/_pheromones.dme"
	#include "../../mods/content/psionics/_psionics.dme"
	#include "../../mods/content/sealant_gun/_sealant_gun.dme"
	#include "../../mods/content/standard_jobs/_standard_jobs.dme"
	#include "../../mods/content/supermatter/_supermatter.dme"
	#include "../../mods/content/ventcrawl/_ventcrawl.dme"
	#include "../../mods/content/xenobiology/_xenobiology.dme"
	#include "../../mods/content/exploration/_exploration.dme"

	#include "../../mods/gamemodes/cult/_cult.dme"
	#include "../../mods/gamemodes/heist/_heist.dme"
	#include "../../mods/gamemodes/mercenary/_mercenary.dme"
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
	#include "../../mods/species/drakes/_drakes.dme"
	#include "../../mods/species/neoavians/_neoavians.dme"
	#include "../../mods/species/serpentid/_serpentid.dme"
	#include "../../mods/species/utility_frames/_utility_frames.dme"
	#include "../../mods/species/vox/_vox.dme"

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
	#include "../away/liberia/liberia.dm"

	#include "tradeship_antagonists.dm"
	#include "tradeship_areas.dm"
	#include "tradeship_documents.dm"
	#include "tradeship_jobs.dm"
	#include "tradeship_levels.dm"
	#include "tradeship_loadouts.dm"
	#include "tradeship_overmap.dm"
	#include "tradeship_overrides.dm"
	#include "tradeship_shuttles.dm"
	#include "tradeship_spawnpoints.dm"
	#include "tradeship_unit_testing.dm"
	#include "tradeship-0.dmm"
	#include "tradeship-1.dmm"
	#include "tradeship-2.dmm"
	#include "tradeship-3.dmm"

	#include "jobs/_goals.dm"
	#include "jobs/civilian.dm"
	#include "jobs/command.dm"
	#include "jobs/engineering.dm"
	#include "jobs/medical.dm"
	#include "jobs/science.dm"

	#include "outfits/_outfits.dm"
	#include "outfits/command.dm"
	#include "outfits/engineering.dm"
	#include "outfits/medical.dm"
	#include "outfits/science.dm"

	#define USING_MAP_DATUM /datum/map/tradeship

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Tradeship

#endif
