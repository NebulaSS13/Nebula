/**
 *# Callback Datums
 *A datum that holds a proc to be called on another object, used to track proccalls to other objects
 *
 * ## USAGE
 *
 * ```
 * var/datum/callback/C = new(object|null, PROC_REF(procname), arg1, arg2, ... argn)
 * var/timerid = addtimer(C, time, timertype)
 * you can also use the compiler define shorthand
 * var/timerid = addtimer(CALLBACK(object|null, PROC_REF(procname), arg1, arg2, ... argn), time, timertype)
 * ```
 *
 * Note: proc strings can only be given for datum proc calls, global procs must be proc paths
 *
 * Also proc strings are strongly advised against because they don't compile error if the proc stops existing
 *
 * In some cases you can provide a shortform of the procname, see the proc typepath shortcuts documentation below
 *
 * ## INVOKING THE CALLBACK
 *`var/result = C.Invoke(args, to, add)` additional args are added after the ones given when the callback was created
 *
 * `var/result = C.InvokeAsync(args, to, add)` Asynchronous - returns . on the first sleep then continues on in the background
 * after the sleep/block ends, otherwise operates normally.
 *
 * ## PROC TYPEPATH SHORTCUTS
 * (these operate on paths, not types, so to these shortcuts, datum is NOT a parent of atom, etc...)
 *
 * ### proc defined on current(src) object OR overridden at src or any of its parents:
 * PROC_REF(procname)
 *
 * `CALLBACK(src, PROC_REF(some_proc_here))`
 *
 * ### global proc
 * GLOBAL_PROC_REF(procname)
 *
 * `CALLBACK(src, GLOBAL_PROC_REF(some_proc_here))`
 *
 * ### proc defined on some type
 * TYPE_PROC_REF(/some/type/, some_proc_here)
 */
/datum/callback
	var/datum/object = GLOBAL_PROC
	var/delegate
	var/list/arguments

/datum/callback/New(thingtocall, proctocall, ...)
	if (thingtocall)
		object = thingtocall
	delegate = proctocall
	if (length(args) > 2)
		arguments = args.Copy(3)

/proc/ImmediateInvokeAsync(thingtocall, proctocall, ...)
	set waitfor = FALSE

	if (!thingtocall)
		return

	var/list/calling_arguments = length(args) > 2 ? args.Copy(3) : null

	if (thingtocall == GLOBAL_PROC)
		call(proctocall)(arglist(calling_arguments))
	else
		call(thingtocall, proctocall)(arglist(calling_arguments))

/datum/callback/proc/Invoke(...)
	if (!object)
		return
	var/list/calling_arguments = arguments
	if (length(args))
		if (length(arguments))
			calling_arguments = calling_arguments + args //not += so that it creates a new list so the arguments list stays clean
		else
			calling_arguments = args
	if (object == GLOBAL_PROC)
		return call(delegate)(arglist(calling_arguments))
	return call(object, delegate)(arglist(calling_arguments))

//copy and pasted because fuck proc overhead
/datum/callback/proc/InvokeAsync(...)
	set waitfor = FALSE
	if (!object)
		return
	var/list/calling_arguments = arguments
	if (length(args))
		if (length(arguments))
			calling_arguments = calling_arguments + args //not += so that it creates a new list so the arguments list stays clean
		else
			calling_arguments = args
	if (object == GLOBAL_PROC)
		return call(delegate)(arglist(calling_arguments))
	return call(object, delegate)(arglist(calling_arguments))