/obj/item/book
	name = "book"
	icon = 'icons/obj/items/books/book.dmi'
	icon_state = ICON_STATE_WORLD
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/organic/paper = MATTER_AMOUNT_REINFORCEMENT)

	/// Actual page content
	var/dat
	/// Cache pencode if input, so it can be edited later.
	var/pencode_dat
	/// Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/author
	/// 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/unique = FALSE
	/// The real name of the book.
	var/title
	/// Who modified the book last?
	var/last_modified_ckey
	/// If TRUE, mild solvents can dissolve ink off the page.
	/// If FALSE, the user instead receives a message about how the text doesn't seem to be normal ink.
	var/can_dissolve_text = TRUE

	// Copied from paper. Todo: generalize.
	var/const/deffont = "Verdana"
	var/const/signfont = "Times New Roman"
	var/const/crayonfont = "Comic Sans MS"
	var/const/fancyfont = "Segoe Script"

/obj/item/book/Initialize(var/ml)
	if(!ml && !unique)
		SSpersistence.track_value(src, /decl/persistence_handler/book)
	. = ..()

/obj/item/book/Destroy()
	. = ..()
	if(SSpersistence.is_tracking(src, /decl/persistence_handler/book))
		. = QDEL_HINT_LETMELIVE

/obj/item/book/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	var/page_state = "[icon_state]-pages"
	if(check_state_in_icon(page_state, icon))
		add_overlay(overlay_image(icon, page_state, COLOR_WHITE, RESET_COLOR))

/obj/item/book/proc/get_style_css()
	return {"
		<style>
			h1 {font-size: 18px; margin: 15px 0px 5px;}
			h2 {font-size: 15px; margin: 15px 0px 5px;}
			h3 {font-size: 13px; margin: 15px 0px 5px;}
			li {margin: 2px 0px 2px 15px;}
			ul {margin: 5px; padding: 0px;}
			ol {margin: 5px; padding: 0px 15px;}
			body {font-size: 13px; font-family: Verdana;}
		</style>
	"}

/obj/item/book/attack_self(var/mob/user)
	return try_to_read(user) || ..()

/obj/item/book/proc/try_to_read(var/mob/user)
	if(storage)
		var/list/stored = get_stored_inventory()
		if(length(stored))
			for(var/atom/movable/thing in stored)
				to_chat(user, SPAN_NOTICE("\A [thing] falls out of [title]!"))
				thing.dropInto(loc)
		else
			to_chat(user, SPAN_NOTICE("The pages of [title] have been cut out!"))
		return

	if(dat)
		user.visible_message("\The [user] opens a book titled \"[title]\" and begins reading intently.")
		var/processed_dat = user.handle_reading_literacy(user, dat)
		if(processed_dat)
			show_browser(user, processed_dat, "window=book;size=1000x550")
			onclose(user, "book")
	else
		to_chat(user, SPAN_WARNING("This book is completely blank!"))

/obj/item/book/attackby(obj/item/W, mob/user)

	if(IS_PEN(W))
		if(unique)
			to_chat(user, SPAN_WARNING("These pages don't seem to take the ink well. Looks like you can't modify it."))
			return TRUE

		var/choice = input("What would you like to change?") in list("Title", "Contents", "Author", "Cancel")
		switch(choice)
			if("Title")
				var/newtitle = reject_bad_text(sanitize_safe(input("Write a new title:")))
				if(!newtitle)
					to_chat(usr, SPAN_WARNING("The title is invalid."))
				else
					newtitle = usr.handle_writing_literacy(usr, newtitle)
					if(newtitle)
						last_modified_ckey = user.ckey
						title = newtitle
						SetName(title)

			if("Contents")
				var/content = sanitize(input(usr, "What would you like your book to say?", "Editing Book", pencode_dat) as message|null, MAX_BOOK_MESSAGE_LEN)
				if(!content)
					to_chat(usr, SPAN_WARNING("The content is invalid."))
				else
					content = usr.handle_writing_literacy(usr, content)
					if(content)
						last_modified_ckey = user.ckey
						pencode_dat = content
						dat = formatpencode(usr, content, W)

			if("Author")
				var/newauthor = sanitize(input(usr, "Write the author's name:"))
				if(!newauthor)
					to_chat(usr, SPAN_WARNING("The name is invalid."))
				else
					newauthor = usr.handle_writing_literacy(usr, newauthor)
					if(newauthor)
						last_modified_ckey = user.ckey
						author = newauthor
		return TRUE

	if((IS_KNIFE(W) || IS_WIRECUTTER(W)) && user.a_intent == I_HURT && try_carve(user, W))
		return TRUE

	return ..()

/obj/item/book/proc/try_carve(mob/user, obj/item/tool)
	if(storage)
		to_chat(user, SPAN_WARNING("\The [src] has already been carved out."))
	else
		to_chat(user, SPAN_NOTICE("You begin to carve out [title] with \the [tool]."))
		if(do_after(user, 3 SECONDS, src) && !storage)
			to_chat(user, SPAN_NOTICE("You carve out the pages from [title] with \the [tool]! You didn't want to read it anyway."))
			storage = new /datum/storage/book(src)
	return TRUE

/obj/item/book/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(user.get_target_zone() == BP_EYES)
		user.visible_message(
			SPAN_NOTICE("You open up the book and show it to \the [target]."),
			SPAN_NOTICE("\The [user] opens up a book and shows it to \the [target].")
		)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam
		var/processed_dat = target.handle_reading_literacy(user, "<i>Author: [author].</i><br><br>" + "[dat]")
		if(processed_dat)
			show_browser(target, processed_dat, "window=book;size=1000x550")
		return TRUE
	return ..()

// Copied from paper for the most part. TODO: generalize.
/obj/item/book/proc/formatpencode(var/mob/user, var/t, var/obj/item/pen/P)
	. = t
	if(findtext(t, "\[sign\]"))
		var/decl/tool_archetype/pen/parch = GET_DECL(TOOL_PEN)
		var/signature = parch.get_signature(user, P)
		. = replacetext(t, "\[sign\]", "<font face=\"[signfont]\"><i>[signature]</i></font>")

	var/pen_flag  = P.get_tool_property(TOOL_PEN, TOOL_PROP_PEN_FLAG)
	var/pen_color = P.get_tool_property(TOOL_PEN, TOOL_PROP_COLOR)
	if(P)
		if(pen_flag & PEN_FLAG_CRAYON)
			. = replacetext(t, "\[*\]", "")
			. = replacetext(t, "\[hr\]", "")
			. = replacetext(t, "\[small\]", "")
			. = replacetext(t, "\[/small\]", "")
			. = replacetext(t, "\[list\]", "")
			. = replacetext(t, "\[/list\]", "")
			. = replacetext(t, "\[table\]", "")
			. = replacetext(t, "\[/table\]", "")
			. = replacetext(t, "\[row\]", "")
			. = replacetext(t, "\[cell\]", "")
			. = replacetext(t, "\[logo\]", "")
			. = "<font face=\"[crayonfont]\" color=\"[pen_color]\"><b>[.]</b></font>"
		else if(pen_flag & PEN_FLAG_FANCY)
			. = "<font face=\"[fancyfont]\" color=\"[pen_color]\"><i>[.]</i></font>"
		else
			. = "<font face=\"[deffont]\" color=\"[pen_color]\">[.]</font>"
	else
		. = "<font face=\"[deffont]\" color=\"black\"]>[.]</font>"
	. = pencode2html(.)

/obj/item/book/printable_black
	icon = 'icons/obj/items/books/book_printable_black.dmi'
/obj/item/book/printable_red
	icon = 'icons/obj/items/books/book_printable_red.dmi'
/obj/item/book/printable_yellow
	icon = 'icons/obj/items/books/book_printable_yellow.dmi'
/obj/item/book/printable_blue
	icon = 'icons/obj/items/books/book_printable_blue.dmi'
/obj/item/book/printable_green
	icon = 'icons/obj/items/books/book_printable_green.dmi'
/obj/item/book/printable_purple
	icon = 'icons/obj/items/books/book_printable_purple.dmi'
/obj/item/book/printable_light_blue
	icon = 'icons/obj/items/books/book_printable_light_blue.dmi'
/obj/item/book/printable_magazine
	icon = 'icons/obj/items/books/book_printable_magazine.dmi'
