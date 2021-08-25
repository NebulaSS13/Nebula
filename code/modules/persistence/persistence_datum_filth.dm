/decl/persistence_handler/filth
	name = "filth"
	entries_expire_at = 5

/decl/persistence_handler/filth/IsValidEntry(var/atom/entry)
	. = ..() && entry.invisibility == 0

/decl/persistence_handler/filth/CheckTokenSanity(var/list/tokens)
	return ..() && ispath(tokens["path"])

/decl/persistence_handler/filth/CheckTurfContents(var/turf/T, var/list/tokens)
	return !(locate(tokens["path"]) in T)

/decl/persistence_handler/filth/FinalizeTokens(var/list/tokens)
	. = ..()
	if(.["path"] && !ispath(.["path"]))
		.["path"] = text2path(.["path"])
	. = tokens

/decl/persistence_handler/filth/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/_path = tokens["path"]
	new _path(creating, tokens["age"]+1)

/decl/persistence_handler/filth/GetEntryAge(var/atom/entry)
	var/obj/effect/decal/cleanable/filth = entry
	return filth.age

/decl/persistence_handler/filth/proc/GetEntryPath(var/atom/entry)
	var/obj/effect/decal/cleanable/filth = entry
	return filth.generic_filth ? /obj/effect/decal/cleanable/filth : filth.type

/decl/persistence_handler/filth/CompileEntry(var/atom/entry)
	. = ..()
	.["path"] = "[GetEntryPath(entry)]"
