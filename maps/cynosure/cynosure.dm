#if !defined(USING_MAP_DATUM)

	#include "../../mods/gamemodes/cult/_cult.dme"
	#include "../../mods/gamemodes/heist/_heist.dme"
	#include "../../mods/gamemodes/meteor/_meteor.dme"
	#include "../../mods/gamemodes/ninja/_ninja.dme"
	#include "../../mods/gamemodes/revolution/_revolution.dme"
	#include "../../mods/gamemodes/traitor/_traitor.dme"
	#include "../../mods/gamemodes/spyvspy/_spyvspy.dme"
	#include "../../mods/gamemodes/mercenary/_mercenary.dme"

	#include "../../mods/content/response_team/_response_team.dme"
	#include "../../mods/content/dungeon_loot/_dungeon_loot.dme"
	#include "../../mods/content/mundane.dm"
	#include "../../mods/content/standard_jobs/_standard_jobs.dme"
	#include "../../mods/content/baychems/_baychems.dme"
	#include "../../mods/content/corporate/_corporate.dme"
	#include "../../mods/content/government/_government.dme"
	#include "../../mods/content/matchmaking/_matchmaking.dme"
	#include "../../mods/content/modern_earth/_modern_earth.dme"
	#include "../../mods/content/mouse_highlights/_mouse_highlight.dme"
	#include "../../mods/content/scaling_descriptors.dm"
	#include "../../mods/content/xenobiology/_xenobiology.dme"
	#include "../../mods/content/exploration/_exploration.dme"
	#include "../../mods/content/tabloids/_tabloids.dme"
	#include "../../mods/content/item_sharpening/_item_sharpening.dme"
	#include "../../mods/content/brain_interface/_brain_interface.dme"
	#include "../../mods/content/turbolift/_turbolift.dme"
	#include "../../mods/content/fishing/_fishing.dme"
	#include "../../mods/content/holodeck/_holodeck.dme"

	#include "../../mods/mobs/dionaea/_dionaea.dme"
	#include "../../mods/mobs/borers/_borers.dme"

	// Must come after borers for compatibility.
	#include "../../mods/content/psionics/_psionics.dme"

	#include "../../mods/content/pheromones/_pheromones.dme"
	#include "../../mods/species/serpentid/_serpentid.dme"
	#include "../../mods/species/utility_frames/_utility_frames.dme"

	#include "../random_ruins/exoplanet_ruins/playablecolony/playablecolony.dm"

	#include "../../mods/content/polaris/_polaris.dme"
	#include "../../mods/content/government/away_sites/icarus/icarus.dm"
	#include "../../mods/content/corporate/away_sites/lar_maria/lar_maria.dm"

	#include "../../mods/species/vox/_vox.dme"
	#include "../../mods/species/ascent/_ascent.dme"
	#include "../../mods/species/drakes/_drakes.dme"
	#include "../../mods/species/skrell/_skrell.dme"
	#include "../../mods/species/tajaran/_tajaran.dme"
	#include "../../mods/species/unathi/_unathi.dme"
	#include "../../mods/species/neoavians/_neoavians.dme"

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

	#include "cynosure_areas.dm"
	#include "cynosure_elevator.dm"
	#include "cynosure_levels.dm"
	#include "cynosure_presets.dm"
	#include "cynosure_shuttles.dm"
	#include "cynosure_overrides.dm"
	#include "cynosure_unit_testing.dm"

	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_head.dm"
	#include "loadout/loadout_suit.dm"
	#include "loadout/loadout_uniform.dm"

	#include "datums/spawn.dm"

	#include "items/random.dm"
	#include "items/suit.dm"

	#include "job/_jobs.dm"
	#include "job/job_overrides.dm"
	#include "job/outfits.dm"
	#include "job/paramedic.dm"

	#include "structures/signs/signs.dm"
	#include "structures/closets/misc.dm"
	#include "structures/closets/security.dm"

	#include "overmap/sectors.dm"

	#include "cynosure-1.dmm"
	#include "cynosure-2.dmm"
	#include "cynosure-3.dmm"
	#include "cynosure-4.dmm"

	#include "cynosure-centcomm.dmm"
	#include "cynosure-transit.dmm"

	#include "submaps/_cynosure_submaps.dm"
	#include "submaps/prop.dm"

	#include "submaps/poi/mountains/_mountains.dm"
	#include "submaps/poi/mountains/_mountains_areas.dm"
	#include "submaps/poi/plains/_plains.dm"
	#include "submaps/poi/plains/_plains_areas.dm"
	#include "submaps/poi/wilderness/_wilderness.dm"
	#include "submaps/poi/wilderness/_wilderness_areas.dm"

	#define USING_MAP_DATUM /datum/map/cynosure

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Cynosure

#endif
