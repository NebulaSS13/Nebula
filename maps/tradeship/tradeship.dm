#if !defined(USING_MAP_DATUM)


	#include "../random_ruins/exoplanet_ruins/playablecolony/playablecolony.dm"

	#include "../../mods/content/government/away_sites/icarus/icarus.dm"
	#include "../../mods/content/government/ruins/ec_old_crash/ec_old_crash.dm"
	#include "../../mods/content/corporate/_corporate.dme"
	#include "../../mods/content/corporate/away_sites/lar_maria/lar_maria.dm"
	#include "../../mods/species/utility_frames/_utility_frames.dme"
	#include "../../mods/species/ascent/away_sites/ascent/ascent.dm"

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

	#include "tradeship_antagonists.dm"
	#include "tradeship_areas.dm"
	#include "tradeship_documents.dm"
	#include "tradeship_jobs.dm"
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

	#include "jobs/_jobs.dm"
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
