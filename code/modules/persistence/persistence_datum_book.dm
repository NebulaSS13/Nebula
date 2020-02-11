/datum/persistent/book
	name = "books"
	has_admin_data = TRUE

/datum/persistent/book/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/obj/item/book/book = new(creating)
	book.dat =                tokens["message"] 
	book.title =              tokens["title"] 
	book.author =             tokens["writer"]
	book.last_modified_ckey = tokens["author"] || "unknown"
	book.unique =             TRUE
	var/obj/structure/bookcase/case = locate() in creating
	if(case)
		book.forceMove(case)
		case.update_icon()
	. = book

/datum/persistent/book/CompileEntry(var/atom/entry, var/write_file)
	. = ..()
	var/obj/item/book/book = entry
	.["author"] =  book.last_modified_ckey || ""
	.["message"] = book.dat                || "dat"
	.["title"] =   book.title              || "Untitled"
	.["writer"] =  book.author             || "unknown"

/datum/persistent/book/RemoveValue(var/atom/movable/value)
	var/obj/structure/bookcase/bookcase = value.loc
	if(istype(bookcase))
		if(istype(value))
			value.forceMove(null)
		bookcase.update_icon()
	..()

/datum/persistent/book/GetValidTurf(var/turf/T, var/list/tokens)
	. = ..(T || get_turf(pick(GLOB.station_bookcases)), tokens)

/datum/persistent/book/GetEntryAge(var/atom/entry)
	. = -1