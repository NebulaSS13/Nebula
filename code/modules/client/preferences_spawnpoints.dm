/decl/spawnpoint
	var/name                     // Name used in preference setup.
	var/msg                      // Message to display on the arrivals computer.
	var/list/turfs               // List of turfs to spawn on.
	var/always_visible = FALSE   // Whether this spawn point is always visible in selection, ignoring map-specific settings.
	var/list/restrict_job
	var/list/disallow_job

/decl/spawnpoint/proc/check_job_spawning(var/datum/job/job)
	if(restrict_job && !(job.type in restrict_job) && !(job.title in restrict_job))
		return FALSE
	if(disallow_job && ((job.type in disallow_job) || (job.title in disallow_job)))
		return FALSE
	return TRUE

//Called after mob is created, moved to a turf and equipped.
/decl/spawnpoint/proc/after_join(mob/victim)
	return

/decl/spawnpoint/arrivals
	name = "Arrivals"
	msg = "has arrived on the station"

/decl/spawnpoint/arrivals/New()
	..()
	turfs = global.latejoin_locations

/decl/spawnpoint/gateway
	name = "Gateway"
	msg = "has completed translation from offsite gateway"

/decl/spawnpoint/gateway/New()
	..()
	turfs = global.latejoin_gateway_locations

/decl/spawnpoint/cryo
	name = "Cryogenic Storage"
	msg = "has completed cryogenic revival"
	disallow_job = list(/datum/job/cyborg)

/decl/spawnpoint/cryo/New()
	..()
	turfs = global.latejoin_cryo_locations

/decl/spawnpoint/cryo/after_join(mob/living/carbon/human/victim)
	if(!istype(victim))
		return
	var/area/A = get_area(victim)
	for(var/obj/machinery/cryopod/C in A)
		if(!C.occupant)

			// Store any held or equipped items.
			var/obj/item/storage/backpack/pack = victim.back
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
	msg = "has been activated from storage"
	restrict_job = list(/datum/job/cyborg)

/decl/spawnpoint/cyborg/New()
	..()
	turfs = global.latejoin_cyborg_locations
