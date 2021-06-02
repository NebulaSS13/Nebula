#if !defined(USING_MAP_DATUM)

	//Content & etc

	#include "../../mods/content/bigpharma/_bigpharma.dme"
	#include "../../mods/content/scaling_descriptors.dm"

	//Species

	#include "../../mods/species/utility_frames/_utility_frames.dme"
	#include "../../mods/species/tajaran/_tajaran.dme"
	#include "../../mods/species/neoavians/_neoavians.dme"

	#include "core_areas.dm"
	#include "core_overmap.dm"
	#include "core-0.dmm"
	#include "core-1.dmm"

	#define USING_MAP_DATUM /datum/map/core

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Core

#endif
