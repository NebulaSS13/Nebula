/decl/persistence_handler/graffiti
	name = "graffiti"
	entries_expire_at = 50
	has_admin_data = TRUE
	legacy_type = /obj/effect/decal/writing

/decl/persistence_handler/graffiti/IsValidEntry(var/atom/entry)
	. = ..()
	if(.)
		var/turf/T = entry.loc
		. = T.can_engrave()

/decl/persistence_handler/graffiti/GetAdminDataStringFor(var/thing, var/can_modify, var/mob/user)
	var/obj/effect/decal/writing/save_graffiti = thing
	if(can_modify)
		. = "<td colspan = 2>[save_graffiti.message]</td><td>[save_graffiti.author]</td><td><a href='byond://?src=\ref[src];user=\ref[user];remove_entry=\ref[thing]'>Destroy</a></td>"
	else
		. = "<td colspan = 3>[save_graffiti.message]</td><td>[save_graffiti.author]</td>"
