/decl/persistence_handler/paper
	name = "paper"
	entries_expire_at = 50
	has_admin_data = TRUE
	var/paper_type = /obj/item/paper

/decl/persistence_handler/paper/CreateEntryInstance(var/turf/creating, var/list/tokens)

	var/obj/item/paper/paper = new paper_type(creating)
	paper.set_content(tokens["message"], tokens["title"])
	paper.last_modified_ckey = tokens["author"]

	if("has_noticeboard" in tokens)
		var/obj/structure/noticeboard/board = locate() in creating
		if(!board)
			var/decl/material/mat = decls_repository.get_decl_by_id_or_var(tokens["noticeboard_material"], /decl/material, "name")
			board = new(creating, (mat?.type || /decl/material/solid/organic/wood))
			if("noticeboard_direction" in tokens)
				board.set_dir(tokens["noticeboard_direction"])
		if(LAZYLEN(board.notices) < board.max_notices)
			board.add_paper(paper)

	return paper

/decl/persistence_handler/paper/GetEntryAge(var/atom/entry)
	var/obj/item/paper/paper = entry
	return paper.age

/decl/persistence_handler/paper/CompileEntry(var/atom/entry)
	. = ..()
	var/obj/item/paper/paper = entry
	.["author"] =  paper.last_modified_ckey || "unknown"
	.["message"] = paper.info || ""
	.["title"] =   paper.name || "paper"
	var/obj/structure/noticeboard/board = entry.loc
	if(istype(board))
		.["has_noticeboard"] = TRUE
		.["noticeboard_direction"] = board.dir
		.["noticeboard_material"] = board.material.uid

/decl/persistence_handler/paper/GetAdminDataStringFor(var/thing, var/can_modify, var/mob/user)
	var/obj/item/paper/paper = thing
	if(can_modify)
		. = "<td style='background-color:[paper.color]'>[paper.info]</td><td>[paper.name]</td><td>[paper.last_modified_ckey]</td><td><a href='byond://?src=\ref[src];caller=\ref[user];remove_entry=\ref[thing]'>Destroy</a></td>"
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
