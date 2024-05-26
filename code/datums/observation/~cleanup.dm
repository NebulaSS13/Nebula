var/global/list/global_listen_count = list()

/datum
	/// Tracks how many event registrations are listening to us. Used in cleanup to prevent dangling references.
	var/event_source_count = 0
	/// Tracks how many event registrations we are listening to. Used in cleanup to prevent dangling references.
	var/event_listen_count = 0

/proc/cleanup_events(var/datum/source)
	if(global.global_listen_count && global.global_listen_count[source])
		cleanup_global_listener(source, global.global_listen_count[source])
	if(source?.event_source_count > 0)
		cleanup_source_listeners(source, source?.event_source_count)
	if(source?.event_listen_count > 0)
		cleanup_event_listener(source, source?.event_listen_count)

/decl/observ/register(var/datum/event_source, var/datum/listener, var/proc_call)
	. = ..()
	if(.)
		event_source.event_source_count++
		listener.event_listen_count++

/decl/observ/unregister(var/datum/event_source, var/datum/listener, var/proc_call)
	. = ..() // returns the number of events removed
	if(.)
		event_source.event_source_count -= .
		listener.event_listen_count -= .

/decl/observ/register_global(var/datum/listener, var/proc_call)
	. = ..()
	if(.)
		global.global_listen_count[listener] += 1

/decl/observ/unregister_global(var/datum/listener, var/proc_call)
	. = ..()
	if(.)
		global.global_listen_count[listener] -= .
		if(global.global_listen_count[listener] <= 0)
			global.global_listen_count -= listener

/proc/cleanup_global_listener(listener, listen_count)
	global.global_listen_count -= listener
	var/events_removed
	for(var/entry in global.all_observable_events)
		var/decl/observ/event = entry
		if((events_removed = event.unregister_global(listener)))
			log_debug("[event] ([event.type]) - [log_info_line(listener)] was deleted while still registered to global events.")
			listen_count -= events_removed
			if(!listen_count)
				return
	if(listen_count > 0)
		CRASH("Failed to clean up all global listener entries!")

/proc/cleanup_source_listeners(datum/event_source, source_listener_count)
	event_source.event_source_count = 0
	var/events_removed
	for(var/entry in global.all_observable_events)
		var/decl/observ/event = entry
		var/list/list/proc_owners = event.event_sources[event_source]
		if(proc_owners)
			for(var/proc_owner in proc_owners)
				var/list/callbacks_cached = proc_owners[proc_owner]?.Copy()
				if((events_removed = event.unregister(event_source, proc_owner)))
					log_debug("[event] ([event.type]) - [log_info_line(event_source)] was deleted while still being listened to by [log_info_line(proc_owner)]. Callbacks: [json_encode(callbacks_cached)]")
					source_listener_count -= events_removed
					if(!source_listener_count)
						return
	if(source_listener_count > 0)
		CRASH("Failed to clean up all event source entries!")

/proc/cleanup_event_listener(datum/listener, listener_count)
	listener.event_listen_count = 0
	var/events_removed
	for(var/entry in global.all_observable_events)
		var/decl/observ/event = entry
		for(var/event_source in event.event_sources)
			if(isnull(event.event_sources[event_source]))
				log_debug("[event] ([event.type]) - [log_info_line(event_source)] had null listeners list!")
			var/list/callbacks_cached = event.event_sources[event_source]?[listener]?.Copy()
			if((events_removed = event.unregister(event_source, listener)))
				log_debug("[event] ([event.type]) - [log_info_line(listener)] was deleted while still listening to [log_info_line(event_source)]. Callbacks: [json_encode(callbacks_cached)]")
				listener_count -= events_removed
				if(!listener_count)
					return
	if(listener_count > 0)
		CRASH("Failed to clean up all listener entries!")
