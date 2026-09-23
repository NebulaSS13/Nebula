/datum/map/cynosure
	default_law_type = /datum/ai_laws/nanotrasen
	allowed_latejoin_spawns = list(
		/decl/spawnpoint/arrivals,
		/decl/spawnpoint/cryo,
		/decl/spawnpoint/cyborg,
		/decl/spawnpoint/checkpoint,
		/decl/spawnpoint/wilderness
	)

#define FACTION_CYNO_HOSTILES_SYNTHS "cynosure_hostiles_synths"
/mob/living/simple_animal/hostile/malf_drone
	faction = FACTION_CYNO_HOSTILES_SYNTHS
/mob/living/simple_animal/hostile/viscerator
	faction = FACTION_CYNO_HOSTILES_SYNTHS
/mob/living/simple_animal/mob_mimic/exosuit
	faction = FACTION_CYNO_HOSTILES_SYNTHS
/mob/living/simple_animal/mob_mimic/malf_frame
	faction = FACTION_CYNO_HOSTILES_SYNTHS
/mob/living/simple_animal/hostile/hivebot
	faction = FACTION_CYNO_HOSTILES_SYNTHS
#undef FACTION_CYNO_HOSTILES_SYNTHS

#define FACTION_CYNO_HOSTILES_SPIDERS "cynosure_hostiles_spiders"
/mob/living/simple_animal/hostile/giant_spider
	faction = FACTION_CYNO_HOSTILES_SPIDERS
#undef FACTION_CYNO_HOSTILES_SPIDERS
