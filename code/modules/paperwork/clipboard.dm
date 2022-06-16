/obj/item/clipboard
	name = "clipboard"
	desc = "It's a board with a clip used to organise papers."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "clipboard"
	item_state = "clipboard"
	throwforce = 0
	w_class = ITEM_SIZE_SMALL
	throw_speed = 3
	throw_range = 10
	slot_flags = SLOT_LOWER_BODY
	applies_material_name = FALSE
	material = /decl/material/solid/wood
	drop_sound = 'sound/foley/tooldrop5.ogg'
	pickup_sound = 'sound/foley/paperpickup2.ogg'

	var/obj/item/pen/haspen		//The stored pen.
	var/obj/item/toppaper	//The topmost piece of paper.

/obj/item/clipboard/Initialize()
	. = ..()
	update_icon()
	if(material)
		desc = initial(desc)
		desc += " It's made of [material.use_name]."

/obj/item/clipboard/handle_mouse_drop(atom/over, mob/user)
	if(ishuman(user) && istype(over, /obj/screen/inventory))
		var/obj/screen/inventory/inv = over
		add_fingerprint(user)
		if(user.unEquip(src))
			user.equip_to_slot_if_possible(src, inv.slot_id)
			return TRUE
	. = ..()

/obj/item/clipboard/on_update_icon()
	..()
	if(toppaper)
		overlays += overlay_image(toppaper.icon, toppaper.icon_state, flags=RESET_COLOR)
		overlays += toppaper.overlays
	if(haspen)
		overlays += overlay_image(icon, "clipboard_pen", flags=RESET_COLOR)
	overlays += overlay_image(icon, "clipboard_over", flags=RESET_COLOR)
	return

/obj/item/clipboard/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo))
		if(!user.unEquip(W, src))
			return
		if(istype(W, /obj/item/paper))
			toppaper = W
		to_chat(user, "<span class='notice'>You clip the [W] onto \the [src].</span>")
		update_icon()

	else if(istype(toppaper) && IS_PEN(W))
		toppaper.attackby(W, usr)
		update_icon()

	return

/obj/item/clipboard/attack_self(mob/user)
	var/dat = "<title>Clipboard</title>"
	if(haspen)
		dat += "<A href='?src=\ref[src];pen=1'>Remove Pen</A><BR><HR>"
	else
		dat += "<A href='?src=\ref[src];addpen=1'>Add Pen</A><BR><HR>"

	//The topmost paper. I don't think there's any way to organise contents in byond, so this is what we're stuck with.	-Pete
	if(toppaper)
		var/obj/item/paper/P = toppaper
		dat += "<A href='?src=\ref[src];write=\ref[P]'>Write</A> <A href='?src=\ref[src];remove=\ref[P]'>Remove</A> <A href='?src=\ref[src];rename=\ref[P]'>Rename</A> - <A href='?src=\ref[src];read=\ref[P]'>[P.name]</A><BR><HR>"

	for(var/obj/item/paper/P in src)
		if(P==toppaper)
			continue
		dat += "<A href='?src=\ref[src];remove=\ref[P]'>Remove</A> <A href='?src=\ref[src];rename=\ref[P]'>Rename</A> - <A href='?src=\ref[src];read=\ref[P]'>[P.name]</A><BR>"
	for(var/obj/item/photo/Ph in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Ph]'>Remove</A> <A href='?src=\ref[src];rename=\ref[Ph]'>Rename</A> - <A href='?src=\ref[src];look=\ref[Ph]'>[Ph.name]</A><BR>"

	show_browser(user, dat, "window=clipboard")
	onclose(user, "clipboard")
	add_fingerprint(usr)
	return

/obj/item/clipboard/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()

	if(src.loc != user)
		return

	if(href_list["pen"])
		if(IS_PEN(haspen) && (haspen.loc == src))
			user.put_in_hands_or_store_or_drop(haspen)
			haspen = null

	else if(href_list["addpen"])
		if(!haspen)
			var/obj/item/W = user.get_active_hand()
			
			//Its pretty likely the current held thing is the clipdboard
			if(W == src)
				var/list/held = user.get_held_items()
				LAZYREMOVE(held, src)
				for(W in held)
					if(IS_PEN(W))
						break //In that case pick the first pen item we're holding

			if(IS_PEN(W) && (W.w_class <= ITEM_SIZE_TINY))
				if(!user.unEquip(W, src))
					return
				haspen = W
				to_chat(user, SPAN_NOTICE("You slot the pen into \the [src]."))

	else if(href_list["write"])
		var/obj/item/P = locate(href_list["write"])
		if(P && (P.loc == src) && istype(P, /obj/item/paper) && (P == toppaper) )
			var/obj/item/I = user.get_active_hand()
			if(IS_PEN(I))
				P.attackby(I, user)

	else if(href_list["remove"])
		var/obj/item/P = locate(href_list["remove"])

		if(P && (P.loc == src) && (istype(P, /obj/item/paper) || istype(P, /obj/item/photo)) )
			user.put_in_hands_or_store_or_drop(P)
			if(P == toppaper)
				toppaper = null
				var/obj/item/paper/newtop = locate(/obj/item/paper) in src
				if(newtop && (newtop != P))
					toppaper = newtop
				else
					toppaper = null

	else if(href_list["rename"])
		var/obj/item/O = locate(href_list["rename"])

		if(O && (O.loc == src))
			if(istype(O, /obj/item/paper))
				var/obj/item/paper/to_rename = O
				to_rename.rename()

			else if(istype(O, /obj/item/photo))
				var/obj/item/photo/to_rename = O
				to_rename.rename()

	else if(href_list["read"])
		var/obj/item/paper/P = locate(href_list["read"])

		if(P && (P.loc == src) && istype(P, /obj/item/paper) )

			if(!(istype(user, /mob/living/carbon/human) || isghost(user) || istype(user, /mob/living/silicon)))
				show_browser(user, "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[stars(P.info)][P.stamps]</BODY></HTML>", "window=[P.name]")
				onclose(user, "[P.name]")
			else
				show_browser(user, "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.info][P.stamps]</BODY></HTML>", "window=[P.name]")
				onclose(user, "[P.name]")

	else if(href_list["look"])
		var/obj/item/photo/P = locate(href_list["look"])
		if(P && (P.loc == src) && istype(P, /obj/item/photo) )
			P.show(user)

	else if(href_list["top"]) // currently unused
		var/obj/item/P = locate(href_list["top"])
		if(P && (P.loc == src) && istype(P, /obj/item/paper) )
			toppaper = P
			to_chat(user, "<span class='notice'>You move [P.name] to the top.</span>")

	//Update everything
	attack_self(user)
	update_icon()

/obj/item/clipboard/ebony
	material = /decl/material/solid/wood/ebony

/obj/item/clipboard/steel
	material = /decl/material/solid/metal/steel
	material = /decl/material/solid/metal/steel

/obj/item/clipboard/aluminium
	material = /decl/material/solid/metal/aluminium
	material = /decl/material/solid/metal/aluminium

/obj/item/clipboard/glass
	material = /decl/material/solid/glass
	material = /decl/material/solid/glass

/obj/item/clipboard/plastic
	material = /decl/material/solid/plastic
	material = /decl/material/solid/plastic