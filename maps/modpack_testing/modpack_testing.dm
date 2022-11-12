#if !defined(USING_MAP_DATUM)

	#include "modpack_testing_lobby.dm"
	#include "blank.dmm"

	#include "../../mods/content/mundane.dm"
	#include "../../mods/content/scaling_descriptors.dm"
	#include "../../mods/content/bigpharma/_bigpharma.dme"
	#include "../../mods/content/byond_membership/_byond_membership.dm"
	#include "../../mods/content/corporate/_corporate.dme"
	#include "../../mods/content/generic_shuttles/_generic_shuttles.dme"
	#include "../../mods/content/government/_government.dme"
	#include "../../mods/content/matchmaking/_matchmaking.dme"
	#include "../../mods/content/modern_earth/_modern_earth.dme"
	#include "../../mods/content/mouse_highlights/_mouse_highlight.dme"
	#include "../../mods/content/psionics/_psionics.dme"
	#include "../../mods/content/shackles/_shackles.dme"
	#include "../../mods/content/xenobiology/_xenobiology.dme"

	#include "../../mods/mobs/dionaea/_dionaea.dme"
	#include "../../mods/mobs/borers/_borers.dme"

	#include "../../mods/species/ascent/_ascent.dme"
	#include "../../mods/species/neoavians/_neoavians.dme"
	#include "../../mods/species/utility_frames/_utility_frames.dme"
	#include "../../mods/species/bayliens/_bayliens.dme"
	#include "../../mods/species/vox/_vox.dme"

	#define USING_MAP_DATUM /datum/map/modpack_testing

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Modpack Testing

#endif
