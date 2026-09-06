/decl/persistence_handler/paper
	name = "paper"
	entries_expire_at = 50
	has_admin_data = TRUE
	legacy_map_values = list(
		"author"  = nameof(/obj/item/paper::last_modified_ckey),
		"message" = nameof(/obj/item/paper::info),
		"title"   = nameof(/obj/item/paper::name)
	)
	legacy_type = /obj/item/paper

/decl/persistence_handler/paper/GetAdminDataStringFor(var/thing, var/can_modify, var/mob/user)
	var/obj/item/paper/paper = thing
	if(can_modify)
		. = "<td style='background-color:[paper.color]'>[paper.info]</td><td>[paper.name]</td><td>[paper.last_modified_ckey]</td><td><a href='byond://?src=\ref[src];user=\ref[user];remove_entry=\ref[thing]'>Destroy</a></td>"
	else
		. = "<td colspan = 2;style='background-color:[paper.color]'>[paper.info]</td><td>[paper.name]</td><td>[paper.last_modified_ckey]</td>"

/decl/persistence_handler/paper/IsValidEntry(var/atom/entry)
	. = ..()
	if(.)
		var/obj/item/paper/paper = entry
		. = istype(paper) && paper.info && paper.last_modified_ckey

/decl/persistence_handler/paper/RemoveValue(var/atom/value)
	var/obj/structure/noticeboard/board = value.loc
	if(istype(board))
		board.remove_paper(value)
	. = ..()
