/datum/unit_test/del_the_world
	name = "Create and Destroy: Atoms Shall Create And Destroy Without Runtimes"
	priority = -1 // Run last!
	var/list/failures = list()

/datum/unit_test/del_the_world/start_test()
	var/turf/spawn_loc = get_safe_turf()
	var/list/cached_contents = spawn_loc.contents.Copy()

	var/list/ignore = typesof(
		// will error if the area already has one
		/obj/machinery/apc,
		// throw assert failures around non-null alarm area on spawn
		/obj/machinery/alarm,
		// Needs a level above.
		/obj/structure/stairs
	)

	// Suspend to avoid fluid flows shoving stuff off the testing turf.
	SSfluids.suspend()

	// Instantiate all spawnable atoms
	for(var/path in typesof(/obj/item, /obj/effect, /obj/structure, /obj/machinery, /obj/vehicle, /mob) - ignore)
		var/atom/movable/AM
		try
			AM = path
			if(!TYPE_IS_SPAWNABLE(AM))
				continue
			AM = new path(spawn_loc)
			if(!QDELETED(AM)) // could have returned the qdel hint
				qdel(AM, force = TRUE) // must qdel prior to anything it spawns, just in case
		catch(var/exception/e)
			failures += "Runtime during creation of [path]: [EXCEPTION_TEXT(e)]"
		// If it spawned anything else, delete that.
		var/list/del_candidates = spawn_loc.contents - cached_contents
		if(length(del_candidates)) // explicit length check is faster here
			for(var/atom/to_del in del_candidates)
				if(QDELETED(to_del))
					continue
				qdel(to_del, force = TRUE) // I hate borg stacks I hate borg stacks
		AM = null // this counts as a reference to the last item if we don't explicitly clear it??
		del_candidates.Cut() // this also??

	// Check for hanging references.
	SSticker.delay_end = TRUE // Don't end the round while we wait!
	// Drastically lower the amount of time it takes to GC, since we don't have clients that can hold it up.
	SSgarbage.collection_timeout[GC_QUEUE_CHECK] = 10 SECONDS
	cached_contents.Cut()

	var/list/queues_we_care_about = list()
	// All of em, I want hard deletes too, since we rely on the debug info from them
	for(var/i in 1 to GC_QUEUE_HARDDELETE)
		queues_we_care_about += i

	//Now that we've qdel'd everything, let's sleep until the gc has processed all the shit we care about
	// + 2 seconds to ensure that everything gets in the queue.
	var/time_needed = 2 SECONDS
	for(var/index in queues_we_care_about)
		time_needed += SSgarbage.collection_timeout[index]

	// track start time so we know anything deleted after this point isn't ours
	var/start_time = world.time
	var/real_start_time = REALTIMEOFDAY
	var/garbage_queue_processed = FALSE

	sleep(time_needed)
	while(!garbage_queue_processed)
		var/oldest_packet_creation = INFINITY
		for(var/index in queues_we_care_about)
			var/list/queue_to_check = SSgarbage.queues[index]
			if(!length(queue_to_check))
				continue

			var/list/oldest_packet = queue_to_check[1]
			//Pull out the time we inserted at
			var/qdeld_at = oldest_packet[GC_QUEUE_ITEM_GCD_DESTROYED]

			oldest_packet_creation = min(qdeld_at, oldest_packet_creation)

		//If we've found a packet that got del'd later then we finished, then all our shit has been processed
		//That said, if there are any pending hard deletes you may NOT sleep, we gotta handle that shit
		if(oldest_packet_creation > start_time && !length(SSgarbage.queues[GC_QUEUE_HARDDELETE]))
			garbage_queue_processed = TRUE
			break

		if(REALTIMEOFDAY > real_start_time + time_needed + 30 MINUTES) //If this gets us gitbanned I'm going to laugh so hard
			fail("Something has gone horribly wrong, the garbage queue has been processing for well over 30 minutes. What the hell did you do")
			break

		//Immediately fire the gc right after
		SSgarbage.next_fire = 1
		//Unless you've seriously fucked up, queue processing shouldn't take "that" long. Let her run for a bit, see if anything's changed
		sleep(20 SECONDS)

	//Alright, time to see if anything messed up
	var/list/cache_for_sonic_speed = SSgarbage.items
	for(var/path in cache_for_sonic_speed)
		var/datum/qdel_item/item = cache_for_sonic_speed[path]
		if(item.failures)
			failures += "[item.name] hard deleted [item.failures] times out of a total del count of [item.qdels]"
		if(item.no_respect_force)
			failures += "[item.name] failed to respect force deletion [item.no_respect_force] times out of a total del count of [item.qdels]"
		if(item.no_hint)
			failures += "[item.name] failed to return a qdel hint [item.no_hint] times out of a total del count of [item.qdels]"

	cache_for_sonic_speed = SSatoms.BadInitializeCalls
	for(var/path in cache_for_sonic_speed)
		var/fails = cache_for_sonic_speed[path]
		if(fails & BAD_INIT_NO_HINT)
			failures += "[path] didn't return an Initialize hint"
		if(fails & BAD_INIT_DIDNT_INIT)
			failures += "[path] didn't set the initialized flag"
		if(fails & BAD_INIT_QDEL_BEFORE)
			failures += "[path] qdel'd in New()"
		if(fails & BAD_INIT_SLEPT)
			failures += "[path] slept during Initialize()"

	SSfluids.wake()

	SSticker.delay_end = FALSE
	//This shouldn't be needed, but let's be polite
	SSgarbage.collection_timeout[GC_QUEUE_HARDDELETE] = 10 SECONDS
	if(length(failures))
		fail("[length(failures)] issue\s with creation/destruction [length(failures) > 1? "were" : "was"] found:\n[jointext(failures, "\n")]")
	else
		pass("All items passed the tests.")
	return TRUE
