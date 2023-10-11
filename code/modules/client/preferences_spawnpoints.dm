/proc/get_respawn_loc()
	var/list/spawn_locs = list()
	var/list/all_spawns = decls_repository.get_decls_of_subtype(/decl/spawnpoint)
	for(var/spawn_type in all_spawns)
		var/decl/spawnpoint/spawn_data = all_spawns[spawn_type]
		if(spawn_data.player_can_respawn && length(spawn_data.spawn_turfs))
			spawn_locs |= spawn_data.spawn_turfs
	if(length(spawn_locs))
		return pick(spawn_locs)
	return locate(1, 1, 1)

/decl/spawnpoint
	abstract_type = /decl/spawnpoint
	var/name                       // Name used in preference setup.
	var/spawn_announcement         // Message to display on the arrivals computer. If null, no message will be sent.
	var/ghost_can_spawn = TRUE     // Whether or not observers can randomly pick this spawnpoint to use.
	var/player_can_respawn = FALSE // Whether or not prisoners being released from admin jail, or players being respawned, can randomly pick this turf.
	var/list/spawn_turfs           // List of turfs to spawn on.
	var/list/restrict_job
	var/list/restrict_job_event_categories
	var/list/disallow_job
	var/list/disallow_job_event_categories

/decl/spawnpoint/proc/check_job_spawning(var/datum/job/job)

	if(restrict_job && !(job.type in restrict_job) && !(job.title in restrict_job))
		return FALSE

	if(restrict_job_event_categories)
		for(var/event_category in job.event_categories)
			if(!(event_category in restrict_job_event_categories))
				return FALSE

	if(disallow_job && ((job.type in disallow_job) || (job.title in disallow_job)))
		return FALSE

	if(disallow_job_event_categories)
		for(var/event_category in job.event_categories)
			if(event_category in disallow_job_event_categories)
				return FALSE

	return TRUE

//Called after mob is created, moved to a turf and equipped.
/decl/spawnpoint/proc/after_join(mob/victim)
	return

/decl/spawnpoint/arrivals
	name = "Arrivals"
	spawn_announcement = "has arrived on the station"
	player_can_respawn = TRUE

/decl/spawnpoint/gateway
	name = "Gateway"
	spawn_announcement = "has completed translation from offsite gateway"

/obj/abstract/landmark/latejoin/gateway
	spawn_decl = /decl/spawnpoint/gateway

/decl/spawnpoint/cryo
	name = "Cryogenic Storage"
	spawn_announcement = "has completed cryogenic revival"
	disallow_job_event_categories = list(ASSIGNMENT_ROBOT)

/obj/abstract/landmark/latejoin/cryo
	spawn_decl = /decl/spawnpoint/cryo

/decl/spawnpoint/cryo/after_join(mob/living/carbon/human/victim)
	if(!istype(victim) || victim.buckled) // They may have spawned with a wheelchair; don't move them into a pod in that case.
		return

	var/area/A = get_area(victim)
	for(var/obj/machinery/cryopod/C in A)
		if(!C.occupant)

			// Store any held or equipped items.
			var/obj/item/storage/backpack/pack = victim.get_equipped_item(slot_back_str)
			if(istype(pack))
				for(var/atom/movable/thing in victim.get_held_items())
					victim.drop_from_inventory(thing)
					pack.handle_item_insertion(thing)

			C.set_occupant(victim, 1)
			SET_STATUS_MAX(victim, STAT_ASLEEP, rand(1,3))
			C.on_mob_spawn()
			to_chat(victim,SPAN_NOTICE("You are slowly waking up from the cryostasis aboard [global.using_map.full_name]. It might take a few seconds."))
			return

/decl/spawnpoint/cyborg
	name = "Robot Storage"
	spawn_announcement = "has been activated from storage"
	restrict_job_event_categories = list(ASSIGNMENT_ROBOT)
	ghost_can_spawn = FALSE

/obj/abstract/landmark/latejoin/cyborg
	spawn_decl = /decl/spawnpoint/cyborg
