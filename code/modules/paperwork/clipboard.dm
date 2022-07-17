/obj/item/clipboard
	name                  = "clipboard"
	desc                  = "It's a board with a clip used to organise papers."
	icon                  = 'icons/obj/bureaucracy.dmi'
	icon_state            = "clipboard"
	item_state            = "clipboard"
	throwforce            = 0
	w_class               = ITEM_SIZE_SMALL
	throw_speed           = 3
	throw_range           = 10
	slot_flags            = SLOT_LOWER_BODY
	applies_material_name = FALSE
	material              = /decl/material/solid/wood
	drop_sound            = 'sound/foley/tooldrop5.ogg'
	pickup_sound          = 'sound/foley/paperpickup2.ogg'

	var/obj/item/stored_pen        //The stored pen.
	var/list/papers
	var/tmp/max_papers = 50

/obj/item/clipboard/Initialize()
	. = ..()
	update_icon()

/obj/item/clipboard/Destroy()
	QDEL_NULL_LIST(papers)
	return ..()

/obj/item/clipboard/handle_mouse_drop(atom/over, mob/user)
	if(ishuman(user) && istype(over, /obj/screen/inventory))
		var/obj/screen/inventory/inv = over
		add_fingerprint(user)
		if(user.unEquip(src))
			user.equip_to_slot_if_possible(src, inv.slot_id)
			return TRUE
	. = ..()

/obj/item/clipboard/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(stored_pen)
		to_chat(user, "It's holding \a [stored_pen].")
	if(!LAZYLEN(papers))
		to_chat(user, "It contains [length(papers)] / [max_papers] paper\s.")
	else 
		to_chat(user, "It has room for [max_papers] paper\s.")

/obj/item/clipboard/proc/top_paper()
	return LAZYACCESS(papers, 1)

/obj/item/clipboard/proc/push_paper(var/obj/item/P)
	LAZYINSERT(papers, P, 1)

/obj/item/clipboard/proc/pop_paper()
	. = top_paper()
	LAZYREMOVE(papers, 1)

/obj/item/clipboard/on_update_icon()
	..()
	var/obj/item/top_paper = top_paper()
	if(top_paper)
		overlays += overlay_image(top_paper.icon, top_paper.icon_state, flags=RESET_COLOR)
		overlays += top_paper.overlays
	if(stored_pen)
		overlays += overlay_image(icon, "clipboard_pen", flags=RESET_COLOR)
	overlays += overlay_image(icon, "clipboard_over", flags=RESET_COLOR)
	return

/obj/item/clipboard/attackby(obj/item/W, mob/user)
	var/obj/item/top_paper = top_paper()
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo))
		if(!user.unEquip(W, src))
			return
		push_paper(W)
		to_chat(user, SPAN_NOTICE("You clip the [W] onto \the [src]."))
		update_icon()
		return TRUE

	else if(top_paper)
		top_paper.attackby(W, user)
		update_icon()
		return TRUE

	return ..()

/obj/item/clipboard/attack_self(mob/user)
	if(CanPhysicallyInteractWith(user, src))
		interact(user)
		return TRUE

/obj/item/clipboard/interact(mob/user)
	var/dat = "<title>Clipboard</title>"
	if(stored_pen)
		dat += "<A href='?src=\ref[src];pen=1'>Remove Pen</A><BR><HR>"
	else
		dat += "<A href='?src=\ref[src];addpen=1'>Add Pen</A><BR><HR>"

	for(var/i = 1 to length(papers))
		var/obj/item/P = papers[i]
		dat += "<A href='?src=\ref[src];examine=\ref[P]'>[P.name]</A> - <DIV style='float:right;white-space: nowrap;'>"
		if(i == 1)
			dat += "<A href='?src=\ref[src];write=\ref[P]'>Write</A> "
		dat += "<A href='?src=\ref[src];remove=\ref[P]'>Remove</A> <A href='?src=\ref[src];rename=\ref[P]'>Rename</A></DIV><BR>"

	show_browser(user, dat, "window=clipboard")
	onclose(user, "clipboard")
	add_fingerprint(usr)
	return

/**Tries to find a pen in the user's held items. */
/obj/item/clipboard/proc/get_user_pen(var/mob/user)
	var/obj/item/I = user.get_active_hand()
	if(I != src && IS_PEN(I))
		return I
	for(I in user.get_held_items()) //Its pretty likely the current held thing is the clipdboard
		if(IS_PEN(I))
			return I //In that case pick the first pen item we're holding

/obj/item/clipboard/proc/add_pen(var/obj/item/I, var/mob/user)
	if(!stored_pen && I.w_class <= ITEM_SIZE_TINY && IS_PEN(I) && user.unEquip(I, src))
		stored_pen = I
		to_chat(user, SPAN_NOTICE("You slot \the [I] into \the [src]."))
		return TRUE
	else if(stored_pen)
		to_chat(user, SPAN_WARNING("There is already \a [stored_pen] in \the [src]."))
	else if(I.w_class > ITEM_SIZE_TINY)
		to_chat(user, SPAN_WARNING("\The [I] is too big to fit in \the [src]."))

/obj/item/clipboard/proc/remove_pen(var/mob/user)
	if(stored_pen && user.put_in_hands(stored_pen))
		to_chat(user, SPAN_NOTICE("You pull your trusty [stored_pen] from your [src]."))
		. = stored_pen
		stored_pen = null
		return .
	else if(!stored_pen)
		to_chat(user, SPAN_WARNING("There is no pen in \the [src]."))
	else
		to_chat(user, SPAN_WARNING("Your hands are full.")) 

/obj/item/clipboard/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	var/obj/item/tpaper = top_paper()

	if(href_list["pen"] && remove_pen(user))
		. = TOPIC_HANDLED | TOPIC_REFRESH

	else if(href_list["addpen"] && add_pen(get_user_pen(user), user))
		. = TOPIC_HANDLED | TOPIC_REFRESH

	else if(href_list["write"])
		if(tpaper)
			var/obj/item/I = get_user_pen(user)
			//We can also use the stored pen if we have one and a free hand
			if(!I && IS_PEN(stored_pen))
				I = remove_pen(user)
			else if(!I)
				to_chat(user, SPAN_WARNING("You don't have a pen!"))

			if(I)
				tpaper.attackby(I, user)
				. = TOPIC_HANDLED | TOPIC_REFRESH
		else
			. = TOPIC_NOACTION

	else if(href_list["remove"])
		var/obj/item/P = locate(href_list["remove"])
		if(P && user.put_in_hands(P))
			papers.Remove(P)
			. = TOPIC_HANDLED | TOPIC_REFRESH

	else if(href_list["rename"])
		var/obj/item/O = locate(href_list["rename"])
		if(istype(O, /obj/item/paper))
			var/obj/item/paper/to_rename = O
			to_rename.rename()
			. = TOPIC_HANDLED | TOPIC_REFRESH

		else if(istype(O, /obj/item/photo))
			var/obj/item/photo/to_rename = O
			to_rename.rename()
			. = TOPIC_HANDLED | TOPIC_REFRESH

		else
			. = TOPIC_NOACTION

	else if(href_list["examine"])
		var/obj/item/P = locate(href_list["examine"])

		if(istype(P, /obj/item/paper))
			var/obj/item/paper/PP = P
			PP.show_content(user)
			. = TOPIC_HANDLED

		else if(istype(P, /obj/item/photo))
			var/obj/item/photo/PP = P
			PP.show(user)
			. = TOPIC_HANDLED

	//Update everything
	if(. & TOPIC_REFRESH)
		attack_self(user)
		update_icon()

/obj/item/clipboard/ebony
	material = /decl/material/solid/wood/ebony

/obj/item/clipboard/steel
	material = /decl/material/solid/metal/steel

/obj/item/clipboard/aluminium
	material = /decl/material/solid/metal/aluminium

/obj/item/clipboard/glass
	material = /decl/material/solid/glass

/obj/item/clipboard/plastic
	material = /decl/material/solid/plastic
