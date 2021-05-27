/decl/persistence_handler/book
	name = "books"
	has_admin_data = TRUE
	
/decl/persistence_handler/book/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/obj/item/book/book = new(creating)
	book.dat =                tokens["message"] 
	book.title =              tokens["title"] 
	book.author =             tokens["writer"]
	book.icon_state =         tokens["icon_state"]
	book.last_modified_ckey = tokens["author"] || "unknown"
	book.unique =             TRUE
	book.SetName(book.title)
	var/obj/structure/bookcase/case = locate() in creating
	if(case)
		book.forceMove(case)
		case.update_icon()
	. = book

/decl/persistence_handler/book/IsValidEntry(var/atom/entry)
	. = ..()
	if(.)
		var/obj/item/book/book = entry
		. = istype(book) && book.dat && book.last_modified_ckey

/decl/persistence_handler/book/CompileEntry(var/atom/entry, var/write_file)
	. = ..()
	var/obj/item/book/book = entry
	.["author"] =     book.last_modified_ckey || ""
	.["message"] =    book.dat                || "dat"
	.["title"] =      book.title              || "Untitled"
	.["writer"] =     book.author             || "unknown"
	.["icon_state"] = book.icon_state         || "book"

/decl/persistence_handler/book/RemoveValue(var/atom/movable/value)
	var/obj/structure/bookcase/bookcase = value.loc
	if(istype(bookcase))
		if(istype(value))
			value.forceMove(null)
		bookcase.update_icon()
	..()

/decl/persistence_handler/book/GetValidTurf(var/turf/T, var/list/tokens)
	. = ..(T || get_turf(pick(global.station_bookcases)), tokens)

/decl/persistence_handler/book/GetEntryAge(var/atom/entry)
	. = -1

/decl/persistence_handler/book/GetAdminDataStringFor(var/thing, var/can_modify, var/mob/user)
	var/obj/item/book/book = thing
	if(can_modify)
		. = "<td>[book.dat]</td><td>[book.title]</td><td>[book.last_modified_ckey]</td><td><a href='byond://?src=\ref[src];caller=\ref[user];remove_entry=\ref[thing]'>Destroy</a></td>"
	else
		. = "<td colspan = 2>[book.dat]</td><td>[book.title]</td><td>[book.last_modified_ckey]</td>"
