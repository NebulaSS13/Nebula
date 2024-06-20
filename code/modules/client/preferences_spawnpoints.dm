// This proc will return a random valid respawn location, defaulting to
// observer spawn points if nothing else is available. Flags can be used to
// filter the spawnpoints considered valid, see code/__defines/spawn.dm.
/proc/get_random_spawn_turf(var/mob/spawning, var/check_flags)
	var/list/spawn_locs = list()
	var/list/all_spawns = decls_repository.get_decls_of_subtype(/decl/spawnpoint)
	for(var/spawn_type in all_spawns)
		var/decl/spawnpoint/spawn_data = all_spawns[spawn_type]
		if((!check_flags || (spawn_data.spawn_flags & check_flags)))
			var/add_spawn_turfs = spawn_data.get_spawn_turfs(spawning)
			if(length(add_spawn_turfs))
				spawn_locs |= add_spawn_turfs
	. = SAFEPICK(spawn_locs)
	if(!.)
		// Observer spawn is guaranteed by CI to be populated.
		var/decl/spawnpoint/observer_spawn = GET_DECL(/decl/spawnpoint/observer)
		return pick(observer_spawn.get_spawn_turfs())

/decl/spawnpoint
	abstract_type = /decl/spawnpoint
	decl_flags = DECL_FLAG_MANDATORY_UID
	/// Name displayed in preference setup.
	var/name
	/// Message to display on the arrivals computer. If null, no message will be sent.
	var/spawn_announcement
	/// Determines validity for get_random_spawn_turf()
	var/spawn_flags = (SPAWN_FLAG_GHOSTS_CAN_SPAWN | SPAWN_FLAG_JOBS_CAN_SPAWN | SPAWN_FLAG_PRISONERS_CAN_SPAWN | SPAWN_FLAG_PERSISTENCE_CAN_SPAWN)
	/// List of turfs to spawn on. Retrieved via get_spawn_turfs().
	VAR_PRIVATE/list/_spawn_turfs
	/// A list of job types that are allowed to use this spawnpoint.
	var/list/restrict_job
	/// A list of event categories that are allowed to use this spawnpoint (ex. ASSIGNMENT_JANITOR)
	var/list/restrict_job_event_categories
	/// A list of job types that are not allowed to use this spawnpoint.
	var/list/disallow_job
	/// A list of event categories that are not allowed to use this spawnpoint (ex. ASSIGNMENT_JANITOR)
	var/list/disallow_job_event_categories

// Returns the spawn list. Mob is supplied in case overrides want to check prefs.
/decl/spawnpoint/proc/get_spawn_turfs(var/mob/spawning)
	return _spawn_turfs

// Adds to the spawn list. Uses a proc for subtype overrides.
/decl/spawnpoint/proc/add_spawn_turf(var/turf/adding)
	LAZYDISTINCTADD(_spawn_turfs, adding)

// Validates that a job is allowed to use this spawn point.
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

// Dummy spawnpoint for ghosts.
/decl/spawnpoint/observer
	name = "Observer"
	uid = "spawn_observer"
	spawn_flags = SPAWN_FLAG_GHOSTS_CAN_SPAWN

/obj/abstract/landmark/latejoin/observer
	spawn_decl = /decl/spawnpoint/observer

// The 'default' latejoin spawn location.
/decl/spawnpoint/arrivals
	name = "Arrivals"
	spawn_announcement = "has arrived on the station"
	uid = "spawn_arrivals"

// Spawn the mob inside a cryopod at the spawn loc.
/decl/spawnpoint/cryo
	name = "Cryogenic Storage"
	spawn_announcement = "has completed cryogenic revival"
	disallow_job_event_categories = list(ASSIGNMENT_ROBOT)
	uid = "spawn_cryo"
	spawn_flags = (SPAWN_FLAG_GHOSTS_CAN_SPAWN | SPAWN_FLAG_JOBS_CAN_SPAWN)

/obj/abstract/landmark/latejoin/cryo
	spawn_decl = /decl/spawnpoint/cryo

/decl/spawnpoint/cryo/after_join(mob/living/human/victim)
	if(!istype(victim) || victim.buckled) // They may have spawned with a wheelchair; don't move them into a pod in that case.
		return

	var/area/A = get_area(victim)
	for(var/obj/machinery/cryopod/C in A)
		if(!C.occupant)

			// Store any held or equipped items.
			var/obj/item/backpack/pack = victim.get_equipped_item(slot_back_str)
			if(istype(pack) && pack.storage)
				for(var/atom/movable/thing in victim.get_held_items())
					victim.drop_from_inventory(thing)
					pack.storage.handle_item_insertion(null, thing)

			C.set_occupant(victim, 1)
			SET_STATUS_MAX(victim, STAT_ASLEEP, rand(1,3))
			C.on_mob_spawn()
			to_chat(victim,SPAN_NOTICE("You are slowly waking up from the cryostasis aboard [global.using_map.full_name]. It might take a few seconds."))
			return

// Spawnpoint used specifically for robots.
/decl/spawnpoint/cyborg
	name = "Robot Storage"
	spawn_announcement = "has been activated from storage"
	restrict_job_event_categories = list(ASSIGNMENT_ROBOT)
	spawn_flags = SPAWN_FLAG_JOBS_CAN_SPAWN
	uid = "spawn_cyborg"

/obj/abstract/landmark/latejoin/cyborg
	spawn_decl = /decl/spawnpoint/cyborg
