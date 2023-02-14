/proc/is_listening_to_movement(var/atom/movable/listening_to, var/listener)
	var/decl/observ/moved/moved_event = GET_DECL(/decl/observ/moved)
	return moved_event.is_listening(listening_to, listener)

/datum/unit_test/observation
	name = "OBSERVATION template"
	template = /datum/unit_test/observation
	async = 0
	var/list/received_moves
	var/list/received_name_set_events

	var/list/stored_global_listen_count
	var/list/stored_event_sources_count
	var/list/stored_event_listen_count

/datum/unit_test/observation/start_test()
	received_moves = received_moves || list()
	received_name_set_events = received_name_set_events || list()
	received_moves.Cut()
	received_name_set_events.Cut()

	var/decl/observ/moved/moved_event = GET_DECL(/decl/observ/moved)
	for(var/global_listener in moved_event.global_listeners)
		events_repository.unregister_global(/decl/observ/moved, global_listener)

	stored_global_listen_count = global.global_listen_count.Copy()
	stored_event_sources_count = global.event_sources_count.Copy()
	stored_event_listen_count =  global.event_listen_count.Copy()

	sanity_check_events("Pre-Test")
	. = conduct_test()
	sanity_check_events("Post-Test")

/datum/unit_test/observation/proc/sanity_check_events(var/phase)
	for(var/entry in global.all_observable_events)
		var/decl/observ/event = entry
		var/null_count = 0
		for(var/null_candidate in event.global_listeners)
			if(isnull(event.global_listeners[null_candidate]))
				null_count++
		if(null_count > 0)
			fail("[phase]: [event] - The global listeners list contains a null entry.")

		for(var/event_source in event.event_sources)
			for(var/list/list_of_listeners in event.event_sources[event_source])
				if(isnull(list_of_listeners))
					fail("[phase]: [event] - The event source list contains a null entry.")
				else if(!istype(list_of_listeners))
					fail("[phase]: [event] - The list of listeners was not of the expected type. Was [list_of_listeners.type].")
				else
					for(var/listener in list_of_listeners)
						if(isnull(listener))
							fail("[phase]: [event] - The event source listener list contains a null entry.")
						else
							var/proc_calls = list_of_listeners[listener]
							if(isnull(proc_calls))
								fail("[phase]: [event] - [listener] - The proc call list was null.")
							else
								for(var/proc_call in proc_calls)
									if(isnull(proc_call))
										fail("[phase]: [event] - [listener]- The proc call list contains a null entry.")

	for(var/entry in (global.global_listen_count - stored_global_listen_count))
		fail("[phase]: global_listen_count - Contained [log_info_line(entry)].")
	for(var/entry in (global.event_sources_count - stored_event_sources_count))
		fail("[phase]: event_sources_count - Contained [log_info_line(entry)].")
	for(var/entry in (global.event_listen_count - stored_event_listen_count))
		fail("[phase]: event_listen_count - Contained [log_info_line(entry)].")

/datum/unit_test/observation/proc/conduct_test()
	return 0

/datum/unit_test/observation/proc/receive_move(var/atom/movable/am, var/old_loc, var/new_loc)
	received_moves[++received_moves.len] =  list(am, old_loc, new_loc)

/datum/unit_test/observation/proc/dump_received_moves()
	for(var/entry in received_moves)
		var/list/l = entry
		log_unit_test("[l[1]] - [l[2]] - [l[3]]")

/datum/unit_test/observation/proc/receive_name_change(source, old_name, new_name)
	received_name_set_events[++received_name_set_events.len] = list(source, old_name, new_name)

/datum/unit_test/observation/proc/dump_received_names()
	for(var/entry in received_name_set_events)
		var/list/l = entry
		log_unit_test("[l[1]] - [l[2]] - [l[3]]")

/datum/unit_test/observation/global_listeners_shall_receive_events
	name = "OBSERVATION: Global listeners shall receive events"
	var/old_name
	var/new_name

/datum/unit_test/observation/global_listeners_shall_receive_events/conduct_test()
	var/turf/start = get_safe_turf()
	var/obj/O = get_named_instance(/obj, start)
	old_name = O.name
	new_name = O.name + " (New)"

	events_repository.register_global(/decl/observ/name_set, src, /datum/unit_test/observation/proc/receive_name_change)
	O.SetName(new_name)

	if(received_name_set_events.len != 1)
		fail("Expected 1 raised name set event, were [received_name_set_events.len].")
		dump_received_names()
		return 1

	var/list/event = received_name_set_events[1]
	if(event[1] != O || event[2] != old_name || event[3] != new_name)
		fail("Unepected name set event received. Expected [O], was [event[1]]. Expected [old_name], was [event[2]]. Expected [new_name], was [event[3]]")
	else
		pass("Received the expected name set event.")

	events_repository.unregister_global(/decl/observ/name_set, src)
	qdel(O)
	return 1

/datum/unit_test/observation/moved_observer_shall_register_on_follow
	name = "OBSERVATION: Moved - Observer Shall Register on Follow"

/datum/unit_test/observation/moved_observer_shall_register_on_follow/conduct_test()
	var/turf/T = get_safe_turf()
	var/mob/living/human/H = get_named_instance(/mob/living/human, T, global.using_map.default_species)
	var/mob/observer/ghost/O = get_named_instance(/mob/observer/ghost, T, "Ghost")

	O.ManualFollow(H)
	if(is_listening_to_movement(H, O))
		pass("The observer is now following the mob.")
	else
		fail("The observer is not following the mob.")

	qdel(H)
	qdel(O)
	return 1

/datum/unit_test/observation/moved_observer_shall_unregister_on_nofollow
	name = "OBSERVATION: Moved - Observer Shall Unregister on NoFollow"

/datum/unit_test/observation/moved_observer_shall_unregister_on_nofollow/conduct_test()
	var/turf/T = get_safe_turf()
	var/mob/living/human/H = get_named_instance(/mob/living/human, T, global.using_map.default_species)
	var/mob/observer/ghost/O = get_named_instance(/mob/observer/ghost, T, "Ghost")

	O.ManualFollow(H)
	O.stop_following()
	if(!is_listening_to_movement(H, O))
		pass("The observer is no longer following the mob.")
	else
		fail("The observer is still following the mob.")

	qdel(H)
	qdel(O)
	return 1

/datum/unit_test/observation/moved_shall_not_register_on_enter_without_listeners
	name = "OBSERVATION: Moved - Shall Not Register on Enter Without Listeners"

/datum/unit_test/observation/moved_shall_not_register_on_enter_without_listeners/conduct_test()
	var/turf/T = get_safe_turf()
	var/mob/living/human/H = get_named_instance(/mob/living/human, T, global.using_map.default_species)
	qdel(H.virtual_mob)
	H.virtual_mob = null

	var/obj/structure/closet/C = get_named_instance(/obj/structure/closet, T, "Closet")

	H.forceMove(C)
	if(!is_listening_to_movement(C, H))
		pass("The mob did not register to the closet's moved event.")
	else
		fail("The mob has registered to the closet's moved event.")

	qdel(C)
	qdel(H)
	return 1

/datum/unit_test/observation/moved_shall_register_recursively_on_new_listener
	name = "OBSERVATION: Moved - Shall Register Recursively on New Listener"

/datum/unit_test/observation/moved_shall_register_recursively_on_new_listener/conduct_test()
	var/turf/T = get_safe_turf()
	var/mob/living/human/H = get_named_instance(/mob/living/human, T, global.using_map.default_species)
	var/obj/structure/closet/C = get_named_instance(/obj/structure/closet, T, "Closet")
	var/mob/observer/ghost/O = get_named_instance(/mob/observer/ghost, T, "Ghost")

	H.forceMove(C)
	O.ManualFollow(H)
	var/listening_to_closet = is_listening_to_movement(C, H)
	var/listening_to_human = is_listening_to_movement(H, O)
	if(listening_to_closet && listening_to_human)
		pass("Recursive moved registration succesful.")
	else
		fail("Recursive moved registration failed. Human listening to closet: [listening_to_closet] - Observer listening to human: [listening_to_human]")

	qdel(C)
	qdel(H)
	qdel(O)
	return 1

/datum/unit_test/observation/moved_shall_register_recursively_with_existing_listener
	name = "OBSERVATION: Moved - Shall Register Recursively with Existing Listener"

/datum/unit_test/observation/moved_shall_register_recursively_with_existing_listener/conduct_test()
	var/turf/T = get_safe_turf()
	var/mob/living/human/H = get_named_instance(/mob/living/human, T, global.using_map.default_species)
	var/obj/structure/closet/C = get_named_instance(/obj/structure/closet, T, "Closet")
	var/mob/observer/ghost/O = get_named_instance(/mob/observer/ghost, T, "Ghost")

	O.ManualFollow(H)
	H.forceMove(C)
	var/listening_to_closet = is_listening_to_movement(C, H)
	var/listening_to_human = is_listening_to_movement(H, O)
	if(listening_to_closet && listening_to_human)
		pass("Recursive moved registration succesful.")
	else
		fail("Recursive moved registration failed. Human listening to closet: [listening_to_closet] - Observer listening to human: [listening_to_human]")

	qdel(C)
	qdel(H)
	qdel(O)

	return 1

// Should have updated this to work with the new mechs
/*
/datum/unit_test/observation/moved_shall_only_trigger_for_recursive_drop
	name = "OBSERVATION: Moved - Shall Only Trigger Once For Recursive Drop"

/datum/unit_test/observation/moved_shall_only_trigger_for_recursive_drop/conduct_test()
	var/turf/T = get_safe_turf()
	var/obj/exosuit/exosuit = get_named_instance(/obj/exosuit, T, "exosuit")
	var/obj/item/wrench/held_item = get_named_instance(/obj/item/wrench, T, "Wrench")
	var/mob/living/human/dummy/held_mob = get_named_instance(/mob/living/human/dummy, T, "Held Mob")
	var/mob/living/human/dummy/holding_mob = get_named_instance(/mob/living/human/dummy, T, "Holding Mob")

	held_mob.mob_size = MOB_SIZE_SMALL
	held_mob.put_in_active_hand(held_item)
	held_mob.get_scooped(holding_mob, holding_mob)

	holding_mob.forceMove(exosuit)

	exosuit.occupant = holding_mob

	events_repository.register(/decl/observ/moved, held_item, src, /datum/unit_test/observation/proc/receive_move)
	holding_mob.drop_from_inventory(held_item)

	if(received_moves.len != 1)
		fail("Expected 1 raised moved event, were [received_moves.len].")
		dump_received_moves()
		return 1

	var/list/event = received_moves[1]
	if(event[1] != held_item || event[2] != held_mob || event[3] != exosuit)
		fail("Unexpected move event received. Expected [held_item], was [event[1]]. Expected [held_mob], was [event[2]]. Expected [exosuit], was [event[3]]")
	else if(!(held_item in exosuit.dropped_items))
		fail("Expected \the [held_item] to be in the mechs' dropped item list")
	else
		pass("One one moved event with expected arguments raised.")

	events_repository.unregister(/decl/observ/moved, held_item, src)
	qdel(exosuit)
	qdel(held_item)
	qdel(held_mob)
	qdel(holding_mob)

	return 1
*/

/datum/unit_test/observation/moved_shall_not_unregister_recursively_one
	name = "OBSERVATION: Moved - Shall Not Unregister Recursively - One"

/datum/unit_test/observation/moved_shall_not_unregister_recursively_one/conduct_test()
	var/turf/T = get_safe_turf()
	var/mob/observer/ghost/one = get_named_instance(/mob/observer/ghost, T, "Ghost One")
	var/mob/observer/ghost/two = get_named_instance(/mob/observer/ghost, T, "Ghost Two")
	var/mob/observer/ghost/three = get_named_instance(/mob/observer/ghost, T, "Ghost Three")

	two.ManualFollow(one)
	three.ManualFollow(two)

	two.stop_following()
	if(is_listening_to_movement(two, three))
		pass("Observer three is still following observer two.")
	else
		fail("Observer three is no longer following observer two.")

	qdel(one)
	qdel(two)
	qdel(three)

	return 1

/datum/unit_test/observation/moved_shall_not_unregister_recursively_two
	name = "OBSERVATION: Moved - Shall Not Unregister Recursively - Two"

/datum/unit_test/observation/moved_shall_not_unregister_recursively_two/conduct_test()
	var/turf/T = get_safe_turf()
	var/mob/observer/ghost/one = get_named_instance(/mob/observer/ghost, T, "Ghost One")
	var/mob/observer/ghost/two = get_named_instance(/mob/observer/ghost, T, "Ghost Two")
	var/mob/observer/ghost/three = get_named_instance(/mob/observer/ghost, T, "Ghost Three")

	two.ManualFollow(one)
	three.ManualFollow(two)

	three.stop_following()
	if(is_listening_to_movement(one, two))
		pass("Observer two is still following observer one.")
	else
		fail("Observer two is no longer following observer one.")

	qdel(one)
	qdel(two)
	qdel(three)

	return 1

/datum/unit_test/observation/sanity_global_listeners_shall_not_leave_null_entries_when_destroyed
	name = "OBSERVATION: Sanity - Global listeners shall not leave null entries when destroyed"

/datum/unit_test/observation/sanity_global_listeners_shall_not_leave_null_entries_when_destroyed/conduct_test()
	var/turf/T = get_safe_turf()
	var/obj/O = get_named_instance(/obj, T)

	events_repository.register_global(/decl/observ/name_set, O, /atom/movable/proc/move_to_turf)
	qdel(O)

	var/decl/observ/name_set/name_set_event = GET_DECL(/decl/observ/name_set)
	var/null_count = 0
	for(var/null_candidate in name_set_event.global_listeners)
		if (isnull(name_set_event.event_sources[null_candidate]))
			null_count++
	if(null_count > 0)
		fail("The global listener list contains a null value.")
	else
		pass("The global listener list does not contain a null value.")
	if(name_set_event.global_listeners && (null in name_set_event.global_listeners))
		fail("The global listener list contains a null key.")
	else
		pass("The global listener list does not contain a null key.")

	return 1

/datum/unit_test/observation/sanity_event_sources_shall_not_leave_null_entries_when_destroyed
	name = "OBSERVATION: Sanity - Event sources shall not leave null entries when destroyed"

/datum/unit_test/observation/sanity_event_sources_shall_not_leave_null_entries_when_destroyed/conduct_test()
	var/turf/T = get_safe_turf()
	var/mob/event_source = get_named_instance(/mob, T, "Event Source")
	var/mob/listener = get_named_instance(/mob, T, "Event Listener")

	events_repository.register(/decl/observ/moved, event_source, listener, /atom/movable/proc/recursive_move)
	qdel(event_source)

	var/decl/observ/moved/moved_event = GET_DECL(/decl/observ/moved)
	var/null_count = 0
	for(var/null_candidate in moved_event.event_sources)
		if (isnull(moved_event.event_sources[null_candidate]))
			null_count++
	if(null_count > 0)
		fail("The event source list contains a null value.")
	else
		pass("The event source list does not contain a null value.")
	if(moved_event.event_sources && (null in moved_event.event_sources))
		fail("The event source list contains a null key.")
	else
		pass("The event source list does not contain a null key.")

	qdel(listener)
	return 1

/datum/unit_test/observation/sanity_event_listeners_shall_not_leave_null_entries_when_destroyed
	name = "OBSERVATION: Sanity - Event listeners shall not leave null entries when destroyed"

/datum/unit_test/observation/sanity_event_listeners_shall_not_leave_null_entries_when_destroyed/conduct_test()
	var/turf/T = get_safe_turf()
	var/mob/event_source = get_named_instance(/mob, T, "Event Source")
	var/mob/listener = get_named_instance(/mob, T, "Event Listener")

	events_repository.register(/decl/observ/moved, event_source, listener, /atom/movable/proc/recursive_move)
	qdel(listener)

	var/decl/observ/moved/moved_event = GET_DECL(/decl/observ/moved)
	var/listeners = moved_event.event_sources[event_source]
	var/null_count = 0
	for(var/null_candidate in listeners)
		if (isnull(listeners[null_candidate]))
			null_count++
	if(null_count > 0)
		fail("The event source listener list contains a null value.")
	else
		pass("The event source listener list does not contain a null value.")
	if(listeners && (null in listeners))
		fail("The event source listener list contains a null key.")
	else
		pass("The event source listener list does not contain a null key.")
	qdel(event_source)
	return 1
