#if !defined(USING_MAP_DATUM)

	#include "modpack_testing_lobby.dm"
	#include "blank.dmm"

	#include "../../mods/content/mundane.dm"
	#include "../../mods/content/scaling_descriptors.dm"

	#include "../../mods/content/beekeeping/_beekeeping.dme"
	#include "../../mods/content/bigpharma/_bigpharma.dme"
	#include "../../mods/content/biomods/_biomods.dme"
	#include "../../mods/content/blacksmithy/_blacksmithy.dme"
	#include "../../mods/content/blob/_blob.dme"
	#include "../../mods/content/breath_holding/_breath_holding.dme"
	#include "../../mods/content/byond_membership/_byond_membership.dm"
	#include "../../mods/content/corporate/_corporate.dme"
	#include "../../mods/content/dungeon_loot/_dungeon_loot.dme"
	#include "../../mods/content/fantasy/_fantasy.dme"
	#include "../../mods/content/generic_shuttles/_generic_shuttles.dme"
	#include "../../mods/content/government/_government.dme"
	#include "../../mods/content/inertia/_inertia.dme"
	#include "../../mods/content/integrated_electronics/_integrated_electronics.dme"
	#include "../../mods/content/item_sharpening/_item_sharpening.dme"
	#include "../../mods/content/matchmaking/_matchmaking.dme"
	#include "../../mods/content/modern_earth/_modern_earth.dme"
	#include "../../mods/content/mouse_highlights/_mouse_highlight.dme"
	#include "../../mods/content/pheromones/_pheromones.dme"
	#include "../../mods/content/psionics/_psionics.dme"
	#include "../../mods/content/shackles/_shackles.dme"
	#include "../../mods/content/standard_jobs/_standard_jobs.dme"
	#include "../../mods/content/supermatter/_supermatter.dme"
	#include "../../mods/content/tabloids/_tabloids.dme"
	#include "../../mods/content/undead/_undead.dme"
	#include "../../mods/content/xenobiology/_xenobiology.dme"

	#include "../../mods/gamemodes/cult/_cult.dme"
	#include "../../mods/gamemodes/heist/_heist.dme"
	#include "../../mods/gamemodes/meteor/_meteor.dme"
	#include "../../mods/gamemodes/mercenary/_mercenary.dme"
	#include "../../mods/gamemodes/ninja/_ninja.dme"
	#include "../../mods/gamemodes/revolution/_revolution.dme"
	#include "../../mods/gamemodes/spyvspy/_spyvspy.dme"
	#include "../../mods/gamemodes/traitor/_traitor.dme"
	#include "../../mods/gamemodes/mixed.dm"

	#include "../../mods/mobs/borers/_borers.dme"
	#include "../../mods/mobs/dionaea/_dionaea.dme"

	#include "../../mods/species/adherent/_adherent.dme"
	#include "../../mods/species/ascent/_ascent.dme"
	#include "../../mods/species/drakes/_drakes.dme"
	#include "../../mods/species/neoavians/_neoavians.dme"
	#include "../../mods/species/random_species/_random_species.dme"
	#include "../../mods/species/serpentid/_serpentid.dme"
	#include "../../mods/species/skrell/_skrell.dme"
	#include "../../mods/species/tajaran/_tajaran.dme"
	#include "../../mods/species/tritonian/_tritonian.dme"
	#include "../../mods/species/unathi/_unathi.dme"
	#include "../../mods/species/utility_frames/_utility_frames.dme"
	#include "../../mods/species/vox/_vox.dme"

	#define USING_MAP_DATUM /datum/map/modpack_testing

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Modpack Testing

#endif
