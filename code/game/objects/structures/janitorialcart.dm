/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "The ultimate in janitorial carts! Has space for water, mops, signs, trash bags, and more!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"
	anchored = FALSE
	density = TRUE
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_CLIMBABLE
	movable_flags = MOVABLE_FLAG_WHEELED
	chem_volume = 180

	var/obj/item/bag/trash/mybag	= null
	var/obj/item/mop/mymop = null
	var/obj/item/chems/spray/myspray = null
	var/obj/item/lightreplacer/myreplacer = null
	var/signs = 0	//maximum capacity hardcoded below

/obj/structure/janitorialcart/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "\The [src] [html_icon(src)] contains [REAGENT_TOTAL_VOLUME(reagents)] unit\s of liquid!"

/obj/structure/janitorialcart/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/bag/trash) && !mybag)
		if(!user.try_unequip(used_item, src))
			return TRUE
		mybag = used_item
		update_icon()
		updateUsrDialog()
		to_chat(user, "<span class='notice'>You put [used_item] into [src].</span>")
		return TRUE

	else if(istype(used_item, /obj/item/mop))
		if(REAGENT_TOTAL_VOLUME(used_item.reagents) < REAGENT_MAXIMUM_VOLUME(used_item.reagents))	//if it's not completely soaked we assume they want to wet it, otherwise store it
			if(REAGENT_TOTAL_VOLUME(reagents) < 1)
				to_chat(user, "<span class='warning'>[src] is out of water!</span>")
			else
				reagents.trans_to_obj(used_item, REAGENT_MAXIMUM_VOLUME(used_item.reagents))
				to_chat(user, "<span class='notice'>You wet [used_item] in [src].</span>")
				playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
			return TRUE
		if(!mymop)
			if(!user.try_unequip(used_item, src))
				return TRUE
			mymop = used_item
			update_icon()
			updateUsrDialog()
			to_chat(user, "<span class='notice'>You put [used_item] into [src].</span>")
			return TRUE

	else if(istype(used_item, /obj/item/chems/spray) && !myspray)
		if(!user.try_unequip(used_item, src))
			return TRUE
		myspray = used_item
		update_icon()
		updateUsrDialog()
		to_chat(user, "<span class='notice'>You put [used_item] into [src].</span>")
		return TRUE

	else if(istype(used_item, /obj/item/lightreplacer) && !myreplacer)
		if(!user.try_unequip(used_item, src))
			return TRUE
		myreplacer = used_item
		update_icon()
		updateUsrDialog()
		to_chat(user, "<span class='notice'>You put [used_item] into [src].</span>")
		return TRUE

	else if(istype(used_item, /obj/item/caution))
		if(signs < 4)
			if(!user.try_unequip(used_item, src))
				return TRUE
			signs++
			update_icon()
			updateUsrDialog()
			to_chat(user, "<span class='notice'>You put [used_item] into [src].</span>")
		else
			to_chat(user, "<span class='notice'>[src] can't hold any more signs.</span>")
		return TRUE

	else if(istype(used_item, /obj/item/chems/glass))
		return FALSE // So we do not put them in the trash bag as we mean to fill the mop bucket; FALSE means run afterattack

	else if(mybag)
		return mybag.attackby(used_item, user)
	return ..()


/obj/structure/janitorialcart/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	ui_interact(user)
	return TRUE

/obj/structure/janitorialcart/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["name"] = capitalize(name)
	data["bag"] = mybag ? capitalize(mybag.name) : null
	data["mop"] = mymop ? capitalize(mymop.name) : null
	data["spray"] = myspray ? capitalize(myspray.name) : null
	data["replacer"] = myreplacer ? capitalize(myreplacer.name) : null
	data["signs"] = signs ? "[signs] sign\s" : null

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "janitorcart.tmpl", "Janitorial cart", 240, 160)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/janitorialcart/OnTopic(mob/user, href_list)
	switch(href_list["take"])
		if("garbage")
			if(mybag)
				user.put_in_hands(mybag)
				to_chat(user, "<span class='notice'>You take [mybag] from [src].</span>")
				mybag = null
				return TOPIC_REFRESH
			return TOPIC_HANDLED
		if("mop")
			if(mymop)
				user.put_in_hands(mymop)
				to_chat(user, "<span class='notice'>You take [mymop] from [src].</span>")
				mymop = null
				return TOPIC_REFRESH
			return TOPIC_HANDLED
		if("spray")
			if(myspray)
				user.put_in_hands(myspray)
				to_chat(user, "<span class='notice'>You take [myspray] from [src].</span>")
				myspray = null
				return TOPIC_REFRESH
			return TOPIC_HANDLED
		if("replacer")
			if(myreplacer)
				user.put_in_hands(myreplacer)
				to_chat(user, "<span class='notice'>You take [myreplacer] from [src].</span>")
				myreplacer = null
				return TOPIC_REFRESH
			return TOPIC_HANDLED
		if("sign")
			if(signs)
				var/obj/item/caution/Sign = locate() in src
				if(Sign)
					user.put_in_hands(Sign)
					to_chat(user, "<span class='notice'>You take \a [Sign] from [src].</span>")
					signs--
				else
					warning("[src] signs ([signs]) didn't match contents")
					signs = 0
				return TOPIC_REFRESH
			return TOPIC_HANDLED
		else
			return TOPIC_NOACTION

/obj/structure/janitorialcart/on_update_icon()
	..()
	if(mybag)
		add_overlay("cart_garbage")
	if(mymop)
		add_overlay("cart_mop")
	if(myspray)
		add_overlay("cart_spray")
	if(myreplacer)
		add_overlay("cart_replacer")
	if(signs)
		add_overlay("cart_sign[signs]")
