var/global/list/spawntypes

/proc/spawntypes()
	if(!global.spawntypes)
		global.spawntypes = list()
		for(var/type in typesof(/datum/spawnpoint)-/datum/spawnpoint)
			var/datum/spawnpoint/S = type
			var/display_name = initial(S.display_name)
			if((display_name in global.using_map.allowed_spawns) || initial(S.always_visible))
				global.spawntypes[display_name] = new S
	return global.spawntypes

/datum/spawnpoint
	var/msg		  //Message to display on the arrivals computer.
	var/list/turfs   //List of turfs to spawn on.
	var/display_name //Name used in preference setup.
	var/always_visible = FALSE	// Whether this spawn point is always visible in selection, ignoring map-specific settings.
	var/list/restrict_job = null
	var/list/disallow_job = null

/datum/spawnpoint/proc/check_job_spawning(job)
	if(restrict_job && !(job in restrict_job))
		return 0

	if(disallow_job && (job in disallow_job))
		return 0

	return 1

//Called after mob is created, moved to a turf and equipped.
/datum/spawnpoint/proc/after_join(mob/victim)
	return

#ifdef UNIT_TEST
/datum/spawnpoint/Del()
	PRINT_STACK_TRACE("Spawn deleted: [log_info_line(src)]")
	..()

/datum/spawnpoint/Destroy()
	PRINT_STACK_TRACE("Spawn destroyed: [log_info_line(src)]")
	. = ..()
#endif

/datum/spawnpoint/arrivals
	display_name = "Arrivals Shuttle"
	msg = "has arrived on the station"

/datum/spawnpoint/arrivals/New()
	..()
	turfs = global.latejoin_locations

/datum/spawnpoint/gateway
	display_name = "Gateway"
	msg = "has completed translation from offsite gateway"

/datum/spawnpoint/gateway/New()
	..()
	turfs = global.latejoin_gateway_locations

/datum/spawnpoint/cryo
	display_name = "Cryogenic Storage"
	msg = "has completed cryogenic revival"
	disallow_job = list("Robot")

/datum/spawnpoint/cryo/New()
	..()
	turfs = global.latejoin_cryo_locations

/datum/spawnpoint/cryo/after_join(mob/living/carbon/human/victim)
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

/datum/spawnpoint/cyborg
	display_name = "Robot Storage"
	msg = "has been activated from storage"
	restrict_job = list("Robot")

/datum/spawnpoint/cyborg/New()
	..()
	turfs = global.latejoin_cyborg_locations

/datum/spawnpoint/default
	display_name = DEFAULT_SPAWNPOINT_ID
	msg = "has arrived on the station"
	always_visible = TRUE