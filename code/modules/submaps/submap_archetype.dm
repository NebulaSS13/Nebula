/decl/submap_archetype
	var/map
	var/descriptor = "generic ship archetype"
	var/list/whitelisted_species = list(SPECIES_HUMAN)
	var/list/blacklisted_species = list(SPECIES_ALIEN, SPECIES_GOLEM)
	var/call_webhook
	var/list/crew_jobs = list(
		/datum/job/submap
	)

/decl/submap_archetype/Destroy()
	if(SSmapping.submap_archetypes[descriptor] == src)
		SSmapping.submap_archetypes -= descriptor
	. = ..()

// Generic ships to populate the list.
/decl/submap_archetype/derelict
	descriptor = "drifting wreck"

/decl/submap_archetype/abandoned_ship
	descriptor = "abandoned ship"
