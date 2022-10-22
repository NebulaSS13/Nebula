#if !defined(USING_MAP_DATUM)

	//Content & etc

	#include "../../mods/content/bigpharma/_bigpharma.dme"
	#include "../../mods/content/matchmaking/_matchmaking.dme"
	#include "../../mods/content/scaling_descriptors.dm"

	//Species

	#include "../../mods/species/utility_frames/_utility_frames.dme"
	#include "../../mods/species/tajaran/_tajaran.dme"
	#include "../../mods/species/neoavians/_neoavians.dme"

	#include "nexus_areas.dm"
	#include "nexus_departments.dm"
	#include "nexus_jobs.dm"
	#include "nexus_overmap.dm"
	#include "nexus_unit_testing.dm"
	#include "nexus-1.dmm"
	#include "nexus-2.dmm"

	#define USING_MAP_DATUM /datum/map/nexus

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Nexus

#endif
