/decl/persistence_handler/paper/noticeboard
	name = "noticeboard paper"
	paper_type = /obj/item/paper

/decl/persistence_handler/paper/noticeboard/CheckTurfContents(var/turf/T, var/list/tokens)
	if(!(locate(/obj/structure/noticeboard) in T))
		new /obj/structure/noticeboard(T)
	. = ..()

/decl/persistence_handler/paper/noticeboard/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/obj/structure/noticeboard/board = locate() in creating
	if(!board || LAZYLEN(board.notices) >= board.max_notices)
		return
	. = ..()
	board.add_paper(.)

/decl/persistence_handler/paper/noticeboard/RemoveValue(var/atom/value)
	var/obj/structure/noticeboard/board = value.loc
	if(istype(board))
		board.remove_paper(value)
	. = ..()