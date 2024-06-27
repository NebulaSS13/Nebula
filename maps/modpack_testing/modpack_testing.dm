#if !defined(USING_MAP_DATUM)

	#include "modpack_testing_lobby.dm"
	#include "blank.dmm"

	#include "../../mods/gamemodes/cult/_cult.dme"
	#include "../../mods/gamemodes/deity/_deity.dme"
	#include "../../mods/gamemodes/heist/_heist.dme"
	#include "../../mods/gamemodes/meteor/_meteor.dme"
	#include "../../mods/gamemodes/ninja/_ninja.dme"
	#include "../../mods/gamemodes/revolution/_revolution.dme"
	#include "../../mods/gamemodes/traitor/_traitor.dme"
	#include "../../mods/gamemodes/spyvspy/_spyvspy.dme"
	#include "../../mods/gamemodes/mixed/_mixed.dme"

	#include "../../mods/content/mundane.dm"
	#include "../../mods/content/scaling_descriptors.dm"

	#include "../../mods/content/dungeon_loot/_dungeon_loot.dme"
	#include "../../mods/content/bigpharma/_bigpharma.dme"
	#include "../../mods/content/byond_membership/_byond_membership.dm"
	#include "../../mods/content/corporate/_corporate.dme"
	#include "../../mods/content/generic_shuttles/_generic_shuttles.dme"
	#include "../../mods/content/government/_government.dme"
	#include "../../mods/content/matchmaking/_matchmaking.dme"
	#include "../../mods/content/modern_earth/_modern_earth.dme"
	#include "../../mods/content/mouse_highlights/_mouse_highlight.dme"
	#include "../../mods/content/shackles/_shackles.dme"
	#include "../../mods/content/xenobiology/_xenobiology.dme"
	#include "../../mods/content/pheromones/_pheromones.dme"
	#include "../../mods/species/drakes/_drakes.dme" // include before _fantasy.dme so overrides work
	#include "../../mods/content/fantasy/_fantasy.dme"

	#include "../../mods/mobs/dionaea/_dionaea.dme"
	#include "../../mods/mobs/borers/_borers.dme"

	// Must come after borers for compatibility.
	#include "../../mods/content/psionics/_psionics.dme"

	#include "../../mods/species/serpentid/_serpentid.dme"
	#include "../../mods/species/ascent/_ascent.dme"
	#include "../../mods/species/neoavians/_neoavians.dme"
	#include "../../mods/species/utility_frames/_utility_frames.dme"
	#include "../../mods/species/bayliens/_bayliens.dme"
	#include "../../mods/species/vox/_vox.dme"

	#define USING_MAP_DATUM /datum/map/modpack_testing

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Modpack Testing

#endif
