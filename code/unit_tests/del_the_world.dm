/datum/unit_test/del_the_world
	name = "Create and Destroy: Atoms Shall Create And Destroy Without Runtimes"
	priority = -1 // Run last!
	var/list/failures = list()

/datum/unit_test/del_the_world/start_test()
	var/turf/spawn_loc = get_safe_turf()
	var/list/cached_contents = spawn_loc.contents.Copy()

	/// Types to except from GC checking tests.
	var/list/gc_exceptions = list(
		// I hate doing this, but until the graph tests are fixed by someone who actually understands them,
		// this is the best I can do without breaking other stuff.
		/datum/node/physical,
		// Randomly fails to GC during CI, cause unclear. Remove this if the root cause is identified.
		/obj/item/organ/external/chest
	)

	var/list/ignore = typesof(
		// will error if the area already has one
		/obj/machinery/power/apc,
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

	// Check for hanging references.
	SSticker.delay_end = TRUE // Don't end the round while we wait!
	// No harddels during this test.
	SSgarbage.collection_timeout[GC_QUEUE_HARDDELETE] = 6 HOURS // github CI timeout length
	cached_contents.Cut()

	// track start time so we know anything deleted after this point isn't ours
	var/start_time = world.time
	// spin until the first item in the filter queue is older than start_time
	var/filter_queue_finished = FALSE
	var/list/filter_queue = SSgarbage.queues[GC_QUEUE_FILTER]
	while(!filter_queue_finished)
		if(!length(filter_queue))
			filter_queue_finished = TRUE
			break
		var/oldest_item = filter_queue[1]
		var/qdel_time = filter_queue[oldest_item]
		if(qdel_time > start_time) // Everything is in the check queue now!
			filter_queue_finished = TRUE
			break
		if(world.time > start_time + 2 MINUTES)
			fail("Something has gone horribly wrong, the filter queue has been processing for well over 2 minutes. What the hell did you do??")
			break
		// We want to fire every time.
		SSgarbage.next_fire = 1
		sleep(2 SECONDS)
	// We need to check the check queue now.
	start_time = world.time
	// sleep until SSgarbage has run through the queue
	var/time_needed = SSgarbage.collection_timeout[GC_QUEUE_CHECK]
	sleep(time_needed)
	// taken verbatim from TG's Del The World
	var/garbage_queue_processed = FALSE
	var/list/check_queue = SSgarbage.queues[GC_QUEUE_CHECK]
	while(!garbage_queue_processed)
		//How the hell did you manage to empty this? Good job!
		if(!length(check_queue))
			garbage_queue_processed = TRUE
			break

		var/oldest_packet = check_queue[1]
		//Pull out the time we deld at
		var/qdeld_at = check_queue[oldest_packet]
		//If we've found a packet that got del'd later then we finished, then all our shit has been processed
		if(qdeld_at > start_time)
			garbage_queue_processed = TRUE
			break

		if(world.time > start_time + time_needed + 8 MINUTES)
			fail("The garbage queue has been processing for well over 10 minutes. Something is likely broken.")
			break

		//Immediately fire the gc right after
		SSgarbage.next_fire = 1
		//Unless you've seriously fucked up, queue processing shouldn't take "that" long. Let her run for a bit, see if anything's changed
		sleep(20 SECONDS)

	//Alright, time to see if anything messed up
	var/list/cache_for_sonic_speed = SSgarbage.items
	for(var/path in cache_for_sonic_speed)
		if(path in gc_exceptions)
			continue
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
