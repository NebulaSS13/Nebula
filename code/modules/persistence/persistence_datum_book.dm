/decl/persistence_handler/book
	name = "books"
	has_admin_data =     TRUE
	ignore_area_flags =  TRUE
	ignore_invalid_loc = TRUE
	legacy_type = /obj/item/book
	legacy_map_values = list(
		"author"    = nameof(/obj/item/book::last_modified_ckey),
		"writer"    = nameof(/obj/item/book::author),
		"book_type" = nameof(/obj/item/book::type),
		"message"   = nameof(/obj/item/book::dat)
	)

/decl/persistence_handler/book/IsValidEntry(var/atom/entry)
	. = ..()
	if(.)
		var/obj/item/book/book = entry
		. = istype(book) && book.dat && book.last_modified_ckey

/decl/persistence_handler/book/RemoveValue(var/atom/movable/value)
	var/obj/structure/bookcase/bookcase = value.loc
	if(istype(bookcase))
		if(istype(value))
			value.forceMove(null)
		bookcase.update_icon()
	..()

/decl/persistence_handler/book/GetAdminDataStringFor(var/thing, var/can_modify, var/mob/user)
	var/obj/item/book/book = thing
	if(can_modify)
		. = "<td>[book.dat]</td><td>[book.title]</td><td>[book.last_modified_ckey]</td><td><a href='byond://?src=\ref[src];user=\ref[user];remove_entry=\ref[thing]'>Destroy</a></td>"
	else
		. = "<td colspan = 2>[book.dat]</td><td>[book.title]</td><td>[book.last_modified_ckey]</td>"
