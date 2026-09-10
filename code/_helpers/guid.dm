// Marks a guid as unused for get_guid() to return later.
var/global/alist/_unused_guids_by_distinguisher = alist()
/proc/free_guid(_distinguisher, _guid)
	var/list/unused_guids = global._unused_guids_by_distinguisher[_distinguisher]
	if(islist(unused_guids))
		unused_guids += _guid
	else
		global._unused_guids_by_distinguisher[_distinguisher] = list(_guid)

// Returns an unused guid.
var/global/alist/_guids_by_distinguisher = alist()
/proc/get_guid(_distinguisher)

	// First time this has been used - set up our lists, return 1.
	if(!global._guids_by_distinguisher[_distinguisher])
		global._guids_by_distinguisher[_distinguisher] = 1
		global._unused_guids_by_distinguisher[_distinguisher] = list()
		return 1

	// If we have unused guids, use one of those first. Otherwise just increment our GUID counter.
	var/list/unused_guids = global._unused_guids_by_distinguisher[_distinguisher]
	if(!length(unused_guids))
		global._guids_by_distinguisher[_distinguisher] = global._guids_by_distinguisher[_distinguisher] + 1
		return global._guids_by_distinguisher[_distinguisher]

	. = unused_guids[1]
	unused_guids.Cut(1, 2)

// Sets our last max guid, only really used after initial subsystem load.
/proc/set_guid(_distinguisher, _guid)
	global._guids_by_distinguisher[_distinguisher] = _guid
