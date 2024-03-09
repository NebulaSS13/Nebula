/decl/public_access
	var/name
	var/desc

/decl/public_access/public_variable
	var/expected_type
	var/can_write = FALSE
	var/var_type = IC_FORMAT_BOOLEAN // Reuses IC defines for better compatibility.

	var/has_updates = FALSE          // Can register listeners for updates on change.
	var/list/listeners = list()

/*
Must be implemented by subtypes.
*/

// Reads off the var value and returns it
/decl/public_access/public_variable/proc/access_var(datum/owner)

// Writes to the var. Returns true if change occured, false otherwise.
// Subtypes shall call parent, and perform the actual write if the return value is true.
// If the var has_updates, you must never modify the var except through this proc.
/decl/public_access/public_variable/proc/write_var(datum/owner, new_value)
	if(!check_input_type(new_value))
		return FALSE
	var/old_value = access_var(owner)
	if(old_value == new_value)
		return FALSE
	if(has_updates)
		var_changed(owner, old_value, new_value)
	return TRUE

// Any sanitization should be done in here.
/decl/public_access/public_variable/proc/write_var_protected(datum/owner, new_value)
	if(!can_write)
		return FALSE
	return write_var(owner, new_value)

// Checks the input type of the passed value without modification.
/decl/public_access/public_variable/proc/check_input_type(new_value)
	. = FALSE
	switch(var_type)
		if(IC_FORMAT_ANY)
			return TRUE
		if(IC_FORMAT_STRING)
			return istext(new_value)
		if(IC_FORMAT_CHAR)
			return istext(new_value) && length(new_value) == 1
		if(IC_FORMAT_COLOR)
			return sanitize_hexcolor(new_value, null) == new_value
		if(IC_FORMAT_NUMBER)
			return isnum(new_value)
		if(IC_FORMAT_DIR)
			return new_value in global.alldirs
		if(IC_FORMAT_BOOLEAN)
			return new_value == !!new_value
		if(IC_FORMAT_REF)
			return isweakref(new_value)

		// Public variables of these types need to against the contents of the list and the index for validity themselves.
		if(IC_FORMAT_LIST)
			return islist(new_value)
		if(IC_FORMAT_INDEX)
			return isnum(new_value)

/*
Listener registration. You must unregister yourself if you are destroyed; the owner being destroyed will be handled automatically.
*/

/decl/public_access/public_variable/proc/register_listener(datum/listener, datum/owner, registered_proc)
	. = FALSE
	if(!istype(owner, expected_type))
		CRASH("[log_info_line(listener)] attempted to register for the public variable [type], but passed an invalid owner of type [owner.type].")
	if(!has_updates)
		return // Can try and register, but updates aren't coming
	if(!listeners[owner])
		listeners[owner] = list()
		events_repository.register(/decl/observ/destroyed, owner, src, PROC_REF(owner_destroyed))
	LAZYADD(listeners[owner][listener], registered_proc)
	return TRUE

/decl/public_access/public_variable/proc/unregister_listener(datum/listener, datum/owner, registered_proc)
	if(!listeners[owner])
		return
	if(!listeners[owner][listener])
		return

	if(registered_proc) // Remove the proc and remove the listener if no more procs
		listeners[owner][listener] -= registered_proc
		if(!length(listeners[owner][listener]))
			listeners[owner] -= listener
	else // Remove the listener
		listeners[owner] -= listener

	if(!length(listeners[owner])) // Clean up the list if no longer listening to anything.
		listeners -= owner
		events_repository.unregister(/decl/observ/destroyed, owner, src)

/*
Internal procs. Do not modify.
*/

/decl/public_access/public_variable/proc/owner_destroyed(datum/owner)
	events_repository.unregister(/decl/observ/destroyed, owner, src)
	listeners -= owner

/decl/public_access/public_variable/proc/var_changed(owner, old_value, new_value)
	var/list/to_alert = listeners[owner]
	for(var/thing in to_alert)
		for(var/call_proc in to_alert[thing])
			call(thing, call_proc)(src, owner, old_value, new_value)

/*
Public methods machines can expose. Pretty bare-bones; just wraps a proc and gives it a name for UI purposes.
*/

/decl/public_access/public_method
	var/call_proc
	var/forward_args = FALSE

/decl/public_access/public_method/proc/perform(datum/owner, ...)
	if(forward_args)
		return call(owner, call_proc)(arglist(args.Copy(2)))
	else
		return call(owner, call_proc)()

/*
Machinery implementation
*/

/obj/machinery
	var/list/public_variables
	var/list/public_methods

/obj/machinery/Initialize()
	for(var/path in public_variables)
		public_variables[path] = GET_DECL(path)
	for(var/path in public_methods)
		public_methods[path] = GET_DECL(path)
	. = ..()