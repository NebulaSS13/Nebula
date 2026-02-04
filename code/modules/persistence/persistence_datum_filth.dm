/decl/persistence_handler/filth
	name = "filth"
	entries_expire_at = 5
	legacy_type = /obj/effect/decal/cleanable/filth
	legacy_map_values = list(
		"path"       = nameof(/obj/effect/decal/cleanable::type),
		"filthiness" = nameof(/obj/effect/decal/cleanable/dirt::dirt_amount)
	)

/decl/persistence_handler/filth/IsValidEntry(var/atom/entry)
	. = ..() && entry.invisibility == 0
