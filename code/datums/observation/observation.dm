//
//	Observer Pattern Implementation
//
//	Implements a basic observer pattern with the following main procs:
//
//	/decl/observ/proc/is_listening(var/event_source, var/datum/listener, var/proc_call)
//		event_source: The instance which is generating events.
//		listener: The instance which may be listening to events by event_source
//		proc_call: Optional. The specific proc to call when the event is raised.
//
//		Returns true if listener is listening for events by event_source, and proc_call supplied is either null or one of the proc that will be called when an event is raised.
//
//	/decl/observ/proc/has_listeners(var/event_source)
//		event_source: The instance which is generating events.
//
//		Returns true if the given event_source has any listeners at all, globally or to specific event sources.
//
//	/decl/observ/proc/register(var/event_source, var/datum/listener, var/proc_call)
//		event_source: The instance you wish to receive events from.
//		listener: The instance/owner of the proc to call when an event is raised by the event_source.
//		proc_call: The proc to call when an event is raised.
//
//		It is possible to register the same listener to the same event_source multiple times as long as it is using different proc_calls.
//		Registering again using the same event_source, listener, and proc_call that has been registered previously will have no additional effect.
//			I.e.: The proc_call will still only be called once per raised event. That particular proc_call will only have to be unregistered once.
//
//		When proc_call is called the first argument is always the source of the event (event_source).
//		Additional arguments may or may not be supplied, see individual event definition files (destroyed.dm, moved.dm, etc.) for details.
//
//		The instance making the register() call is also responsible for calling unregister(), see below for additonal details, including when event_source is destroyed.
//			This can be handled by listening to the event_source's destroyed event, unregistering in the listener's Destroy() proc, etc.
//
//	/decl/observ/proc/unregister(var/event_source, var/datum/listener, var/proc_call)
//		event_source: The instance you wish to stop receiving events from.
//		listener: The instance which will no longer receive the events.
//		proc_call: Optional: The proc_call to unregister.
//
//		Unregisters the listener from the event_source.
//		If a proc_call has been supplied only that particular proc_call will be unregistered. If the proc_call isn't currently registered there will be no effect.
//		If no proc_call has been supplied, the listener will have all registrations made to the given event_source undone.
//
//	/decl/observ/proc/register_global(var/datum/listener, var/proc_call)
//		listener: The instance/owner of the proc to call when an event is raised by any and all sources.
//		proc_call: The proc to call when an event is raised.
//
//		Works very much the same as register(), only the listener/proc_call will receive all relevant events from all event sources.
//		Global registrations can overlap with registrations made to specific event sources and these will not affect each other.
//
//	/decl/observ/proc/unregister_global(var/datum/listener, var/proc_call)
//		listener: The instance/owner of the proc which will no longer receive the events.
//		proc_call: Optional: The proc_call to unregister.
//
//		Works very much the same as unregister(), only it undoes global registrations instead.
//
//	/decl/observ/proc/raise_event(src, ...)
//		Should never be called unless implementing a new event type.
//		The first argument shall always be the event_source belonging to the event. Beyond that there are no restrictions.

/decl/observ
	var/name = "Unnamed Event"                // The name of this event, used mainly for debug/VV purposes. The list of event managers can be reached through the "Debug Controller" verb, selecting the "Observation" entry.
	var/expected_type = /datum                // The expected event source for this event. register() will CRASH() if it receives an unexpected type.
	var/list/global_listeners = list()        // Associative list of instances that listen to all events of this type (as opposed to events belonging to a specific source) and the proc to call.
	VAR_PROTECTED/flags                       // See _defines.dm for available flags and what they do

/datum
	/// Associative list of observ type -> associative list of listeners -> an instance/list of procs to call on the listener when the event is raised.
	var/list/list/list/event_listeners
	/// Associative list of observ type -> datums we're listening to; contains no information about callbacks as that's already stored on their event_listeners list.
	var/list/_listening_to

/decl/observ/proc/is_listening(var/datum/event_source, var/datum/listener, var/proc_call)
	// Return whether there are global listeners unless the event source is given.
	if (!event_source)
		return !!global_listeners.len

	var/list/listeners = event_source.event_listeners?[type]
	// Return whether anything is listening to a source, if no listener is given.
	if (!listener)
		return length(global_listeners) || !!listeners

	// Return false if nothing is associated with that source.
	if (!listeners)
		return FALSE

	// Get and check the listeners for the requested event.
	if (!listeners[listener])
		return FALSE

	// Return true unless a specific callback needs checked.
	if (!proc_call)
		return TRUE

	// Check if the specific callback exists.
	var/list/callback = listeners[listener]
	if (!callback)
		return FALSE

	return (proc_call in callback)

/decl/observ/proc/has_listeners(var/datum/event_source)
	return is_listening(event_source)

/decl/observ/proc/register(var/datum/event_source, var/datum/listener, var/proc_call)
	// Sanity checking.
	if (!(event_source && listener && proc_call))
		return FALSE
	if (istype(event_source, /decl/observ))
		return FALSE

	// Crash if the event source is the wrong type.
	if (!istype(event_source, expected_type))
		CRASH("Unexpected type. Expected [expected_type], was [event_source.type]")

	// Setup the listeners for this source if needed.
	LAZYINITLIST(event_source.event_listeners)
	LAZYINITLIST(event_source.event_listeners[type])
	var/list/listeners = event_source.event_listeners[type]
	// Make sure the callbacks are a list.
	var/list/callbacks = listeners[listener]
	if (!callbacks)
		callbacks = list()
		listeners[listener] = callbacks
		LAZYINITLIST(listener._listening_to)
		LAZYADD(listener._listening_to[type], event_source)

	// If the proc_call is already registered skip
	if(proc_call in callbacks)
		return FALSE

	// Add the callback, and return true.
	callbacks += proc_call
	return TRUE

/decl/observ/proc/unregister(var/datum/event_source, var/datum/listener, var/proc_call)
	// Sanity.
	if (!event_source || !listener || !event_source.event_listeners?[type])
		return 0

	var/list/list/listeners = event_source.event_listeners[type]
	// Remove all callbacks if no specific one is given.
	if (!proc_call)
		// Return the number of callbacks removed.
		. = length(listeners[listener])
		if(listeners.Remove(listener))
			LAZYREMOVE(listener._listening_to?[type], event_source)
			UNSETEMPTY(listener._listening_to)
			// Perform some cleanup and return true.
			if (!length(listeners)) // No one is listening to us on this source anymore.
				LAZYREMOVE(event_source.event_listeners, type)
			UNSETEMPTY(event_source.event_listeners?[type])
			UNSETEMPTY(event_source.event_listeners)
			return .
		return 0

	// See if the listener is registered.
	var/list/callbacks = listeners[listener]
	if (!callbacks)
		return 0

	// See if the callback exists.
	if(!callbacks.Remove(proc_call))
		return 0

	if(!LAZYLEN(callbacks)) // the above Remove() took our last callback away, so remove our callbacks list for this listener
		LAZYREMOVE(event_source.event_listeners[type], listener) // note that UNSETEMPTY would just give it a null value
		LAZYREMOVE(listener._listening_to[type], event_source)
		if(!LAZYLEN(listener._listening_to[type]))
			LAZYREMOVE(listener._listening_to, type)
	if(!LAZYLEN(event_source.event_listeners[type]))
		LAZYREMOVE(event_source.event_listeners, type)
	return 1

/decl/observ/proc/register_global(var/datum/listener, var/proc_call)
	// Sanity.
	if (!(listener && proc_call))
		return FALSE

	if(flags & OBSERVATION_NO_GLOBAL_REGISTRATIONS)
		PRINT_STACK_TRACE("Attempt to register globally was denied")
		return FALSE

	// Make sure the callbacks are setup.
	var/list/callbacks = global_listeners[listener]
	if (!callbacks)
		callbacks = list()
		global_listeners[listener] = callbacks

	// Add the callback and return true.
	callbacks |= proc_call
	return TRUE

/decl/observ/proc/unregister_global(var/datum/listener, var/proc_call)
	// None unregistered unless the listener is set as a global listener.
	if (!(listener && global_listeners[listener]))
		return 0

	// Remove all callbacks if no specific one is given.
	if (!proc_call)
		. = length(global_listeners[listener])
		global_listeners -= listener
		return .

	// See if the listener is registered.
	var/list/callbacks = global_listeners[listener]
	if (!callbacks)
		return 0

	// See if the callback exists.
	if(!callbacks.Remove(proc_call))
		return 0

	if (!callbacks.len)
		global_listeners -= listener
	return 1

/// A variant of raise_event for extra-fast processing, for observs that are certain to never have any global registrations.
/datum/proc/raise_event_non_global(event_type)
	// Call the listeners for this specific event source, if they exist.
	var/list/listeners = event_listeners?[event_type]
	if(length(listeners))
		args[1] = src // replace event_type with src for the call
		for (var/listener in listeners)
			var/list/callbacks = listeners[listener]
			for (var/proc_call in callbacks)
				// If the callback crashes, record the error and remove it.
				try
					call(listener, proc_call)(arglist(args))
				catch (var/exception/e)
					error(EXCEPTION_TEXT(e))
					var/decl/observ/event = GET_DECL(event_type)
					event.unregister(src, listener, proc_call)
	return TRUE

/decl/observ/proc/raise_event(datum/source)
	// Sanity
	if(!source)
		return FALSE

	if(length(global_listeners))
		// Call the global listeners.
		for (var/listener in global_listeners)
			var/list/callbacks = global_listeners[listener]
			for (var/proc_call in callbacks)

				// If the callback crashes, record the error and remove it.
				try
					call(listener, proc_call)(arglist(args))
				catch (var/exception/e)
					error(EXCEPTION_TEXT(e))
					unregister_global(listener, proc_call)

	// Call the listeners for this specific event source, if they exist.
	var/list/listeners = source.event_listeners?[type]
	if(length(listeners))
		for (var/listener in listeners)
			var/list/callbacks = listeners[listener]
			for (var/proc_call in callbacks)
				// If the callback crashes, record the error and remove it.
				try
					call(listener, proc_call)(arglist(args))
				catch (var/exception/e)
					error(EXCEPTION_TEXT(e))
					unregister(source, listener, proc_call)
	return TRUE
