/datum
	var/tmp/weakref/weakref

//obtain a weak reference to a datum
/proc/weakref(datum/D)
	if(!istype(D))
		return
	if(QDELETED(D))
		return
	if(istype(D, /weakref))
		return D
	if(!D.weakref)
		D.weakref = new/weakref(D)
	return D.weakref

/weakref
	var/ref          //- Actual datum ref.
	var/name         //- Useful for input() on lists of weakrefs.
	var/tmp/ref_type //- Handy info for debugging

/weakref/New(datum/D)
	ref      = "\ref[D]"
	name     = "[D]"
	ref_type = D.type

/weakref/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	// A weakref datum should not be manually destroyed as it is a shared resource,
	//  rather it should be automatically collected by the BYOND GC when all references are gone.
	return QDEL_HINT_IWILLGC

/weakref/proc/resolve()
	var/datum/D = locate(ref)
	if(D && D.weakref == src)
		return D
	return null

/weakref/get_log_info_line()
	return "[name] ([ref_type]) ([ref]) (WEAKREF)"

/weakref/CanClone()
	return FALSE //Pass weakref as references since they're unique per atom instance