/datum
	/// Used to indicate that this type is abstract and should not itself be instantiated.
	var/abstract_type = /datum
	/// Time when this object was destroyed.
	var/tmp/gc_destroyed
	/// Indicates if a processing subsystem is currenting queuing this datum
	var/tmp/is_processing = FALSE
	/// Used by the SStimer subsystem
	var/list/active_timers

#ifdef TESTING
	var/tmp/running_find_references
	var/tmp/last_find_references = 0
#endif

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)
	SHOULD_CALL_PARENT(TRUE)
	tag = null
	weakref = null // Clear this reference to ensure it's kept for as brief duration as possible.

	if(istype(SSnano))
		SSnano.close_uis(src)

	var/list/timers = active_timers
	active_timers = null
	for(var/thing in timers)
		var/datum/timedevent/timer = thing
		if (timer.spent && !(timer.flags & TIMER_LOOP))
			continue
		qdel(timer)

	if(extensions)
		for(var/expansion_key in extensions)
			var/list/extension = extensions[expansion_key]
			if(islist(extension))
				extension.Cut()
			else
				qdel(extension)
		extensions = null

	var/decl/observ/destroyed/destroyed_event = GET_DECL(/decl/observ/destroyed)
	// Typecheck is needed (rather than nullchecking) due to oddness with new() ordering during world creation.
	if(istype(events_repository) && destroyed_event.global_listeners.len || destroyed_event.event_sources[src])
		RAISE_EVENT(/decl/observ/destroyed, src)

	if (!isturf(src))	// Not great, but the 'correct' way to do it would add overhead for little benefit.
		cleanup_events(src)

	var/list/machines = global.state_machines["\ref[src]"]
	if(length(machines))
		for(var/base_type in machines)
			qdel(machines[base_type])
		global.state_machines -= "\ref[src]"

	return QDEL_HINT_QUEUE

/datum/proc/Process()
	SHOULD_NOT_SLEEP(TRUE)
	return PROCESS_KILL

// This is more or less a helper to avoid needing to cast extension holders to atom.
// Previously called get() and get_holder_of_type().
// See /atom/get_recursive_loc_of_type() for actual logic.
/datum/proc/get_recursive_loc_of_type(var/loc_type)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("get_recursive_loc_of_type() called on datum type [type] - this proc should only be called on /atom.")

/**
 * Returns whether the object supports being cloned.
 * This is useful for things that should only ever exist once in the world.
 */
/datum/proc/CanClone()
	return TRUE

/**
 * This proc returns a clone of the src datum.
 * Clone here implies a copy similar in terms of look and contents, but internally may differ a bit.
 * The clone shall not keep references onto instances owned by the original, in most cases.
 * Try to avoid overriding this proc directly and instead override GetCloneArgs() and PopulateClone().
 */
/datum/proc/Clone()
	SHOULD_CALL_PARENT(TRUE)
	if(!CanClone())
		CRASH("Called clone on ``[type]`` which does not support cloning!")
	var/list/newargs = GetCloneArgs()
	if(newargs)
		. = new type(arglist(newargs))
	else
		. = new type
	return PopulateClone(.)

/**
 * Returns a list with the arguments passed to the new() of a cloned instance.
 * Override this, instead of Clone() itself.
 */
/datum/proc/GetCloneArgs()
	return

/**
 * Used to allow sub-classes to do further processing on the cloned instance returned by Clone().
 * Override this, instead of Clone() itself.
 * ** Please avoid running update code in here if possible. You could always override Clone() for this kind of things, so we don't end up with 50 calls to update_icon in the chain. **
 */
/datum/proc/PopulateClone(var/datum/clone)
	return clone

/////////////////////////////////////////////////////////////
//Common implementations
/////////////////////////////////////////////////////////////

/image/GetCloneArgs()
	return list(icon, loc, icon_state, layer, dir)