/obj/item/book
	name = "book"
	icon = 'icons/obj/library.dmi'
	icon_state ="book"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	var/dat			 // Actual page content
	var/author		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/unique = 0   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/title		 // The real name of the book.
	var/carved = 0	 // Has the book been hollowed out for use as a secret storage item?
	var/obj/item/store	//What's in the book?
	var/last_modified_ckey

/obj/item/book/Initialize(var/ml)
	if(!ml && !unique)
		SSpersistence.track_value(src, /datum/persistent/book)
	. = ..()

/obj/item/book/Destroy()
	if(dat && SSpersistence.is_tracking(src, /datum/persistent/book))
		// Create a new book in nullspace that is tracked by persistence.
		// This is so destroying a book does not get rid of someone's 
		// content, as books with null coords will get spawned in a random
		// library bookcase.
		var/obj/item/book/backup_book = new
		backup_book.dat =                dat
		backup_book.author =             author
		backup_book.title =              title
		backup_book.last_modified_ckey = last_modified_ckey
		backup_book.unique =             TRUE
	SSpersistence.forget_value(src, /datum/persistent/book)
	. = ..()

/obj/item/book/attack_self(var/mob/user)
	if(carved)
		if(store)
			to_chat(user, "<span class='notice'>\A [store] falls out of [title]!</span>")
			store.dropInto(loc)
			store = null
			return
		else
			to_chat(user, "<span class='notice'>The pages of [title] have been cut out!</span>")
			return
	if(dat)
		user.visible_message("[user] opens a book titled \"[src.title]\" and begins reading intently.")
		var/processed_dat = user.handle_reading_literacy(user, dat)
		if(processed_dat)
			user << browse(processed_dat, "window=book;size=1000x550")
			onclose(user, "book")
	else
		to_chat(user, "This book is completely blank!")

/obj/item/book/attackby(obj/item/W, mob/user)
	if(carved == 1)
		if(!store)
			if(W.w_class < ITEM_SIZE_NORMAL)
				if(!user.unEquip(W, src))
					return
				store = W
				to_chat(user, "<span class='notice'>You put [W] in [title].</span>")
				return
			else
				to_chat(user, "<span class='notice'>[W] won't fit in [title].</span>")
				return
		else
			to_chat(user, "<span class='notice'>There's already something in [title]!</span>")
			return
	if(istype(W, /obj/item/pen))
		if(unique)
			to_chat(user, "These pages don't seem to take the ink well. Looks like you can't modify it.")
			return
		var/choice = input("What would you like to change?") in list("Title", "Contents", "Author", "Cancel")
		switch(choice)
			if("Title")
				var/newtitle = reject_bad_text(sanitizeSafe(input("Write a new title:")))
				if(!newtitle)
					to_chat(usr, "The title is invalid.")
					return
				else
					newtitle = usr.handle_writing_literacy(usr, newtitle)
					if(newtitle)
						last_modified_ckey = user.ckey
						title = newtitle
						SetName(title)
			if("Contents")
				var/content = sanitize(input("Write your book's contents (HTML NOT allowed):") as message|null, MAX_BOOK_MESSAGE_LEN)
				if(!content)
					to_chat(usr, "The content is invalid.")
					return
				else
					content = usr.handle_writing_literacy(usr, content)
					if(content)
						last_modified_ckey = user.ckey
						dat += content

			if("Author")
				var/newauthor = sanitize(input(usr, "Write the author's name:"))
				if(!newauthor)
					to_chat(usr, "The name is invalid.")
					return
				else
					newauthor = usr.handle_writing_literacy(usr, newauthor)
					if(newauthor)
						last_modified_ckey = user.ckey
						author = newauthor
			else
				return
	else if(istype(W, /obj/item/material/knife) || isWirecutter(W))
		if(carved)	return
		to_chat(user, "<span class='notice'>You begin to carve out [title].</span>")
		if(do_after(user, 30, src))
			to_chat(user, "<span class='notice'>You carve out the pages from [title]! You didn't want to read it anyway.</span>")
			carved = 1
			return
	else
		..()

/obj/item/book/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(user.zone_sel.selecting == BP_EYES)
		user.visible_message("<span class='notice'>You open up the book and show it to [M]. </span>", \
			"<span class='notice'> [user] opens up a book and shows it to [M]. </span>")
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam
		var/processed_dat = M.handle_reading_literacy(user, "<i>Author: [author].</i><br><br>" + "[dat]")
		if(processed_dat)
			M << browse(processed_dat, "window=book;size=1000x550")