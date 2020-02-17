#if !defined(using_map_DATUM)

	#define SPECIES_BAXXID           "Baxxid"
	#define SPECIES_YINGLET          "Yinglet"
	#define SPECIES_YINGLET_SOUTHERN "Southern Yinglet"

	#define DEPT_ENCLAVE "enclave"

	#define IS_YINGLET               "yinglet"

	#define CULTURE_SCAV_ENCLAVE   "Enclave Yinglet"
	#define CULTURE_SCAV_TRIBE     "Tribal Yinglet"
	#define FACTION_SCAV           "Scav"

	#include "items/airlocks.dm"
	#include "items/documents.dm"
	#include "items/chemistry.dm"
	#include "items/clothing.dm"
	#include "items/clothing_baxxid.dm"
	#include "items/clothing_yinglet.dm"
	#include "items/javelin.dm"
	#include "items/mollusc.dm"
	#include "items/prosthetics.dm"
	#include "items/seed_storage.dm"
	#include "items/suit_cycler.dm"
	#include "items/turfs.dm"
	#include "map/culture.dm"
	#include "map/overrides.dm"
	#include "lobby/music.dm"
	#include "species/baxxid.dm"
	#include "species/yinglet.dm"
	#include "species/yinglet_organs.dm"
	#include "species/yinglet_accessories.dm"
	#include "tradeship_antagonists.dm"
	#include "tradeship_areas.dm"
	#include "tradeship_chems.dm"
	#include "tradeship_departments.dm"
	#include "tradeship_jobs.dm"
	#include "tradeship_loadouts.dm"
	#include "tradeship_overmap.dm"
	#include "tradeship_shuttles.dm"
	#include "tradeship_spawnpoints.dm"
	#include "tradeship_unit_testing.dm"
	#include "tradeship-0.dmm"
	#include "tradeship-1.dmm"
	#include "tradeship-2.dmm"
	#include "tradeship-3.dmm"

	#define using_map_DATUM /datum/map/tradeship

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Tradeship

#endif
