/decl/persistence_handler/filth/trash
	name = "trash"

/decl/persistence_handler/filth/trash/CheckTurfContents(var/turf/T, var/list/tokens)
	var/too_much_trash = 0
	for(var/obj/item/trash/trash in T)
		too_much_trash++
		if(too_much_trash >= 5)
			return FALSE
	return TRUE

/decl/persistence_handler/filth/trash/GetEntryAge(var/atom/entry)
	var/obj/item/trash/trash = entry
	return trash.age

/decl/persistence_handler/filth/trash/GetEntryPath(var/atom/entry)
	return entry.type
