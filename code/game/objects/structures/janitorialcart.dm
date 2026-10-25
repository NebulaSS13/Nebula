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
		if(user.try_unequip(used_item, src))
			mybag = used_item
			update_icon()
			updateUsrDialog()
			to_chat(user, SPAN_NOTICE("You put \the [used_item] into \the [src]."))
		return TRUE

	if(istype(used_item, /obj/item/mop))
		//if it's not completely soaked we assume they want to wet it
		if(REAGENT_TOTAL_VOLUME(used_item.reagents) < REAGENT_MAXIMUM_VOLUME(used_item.reagents) && REAGENT_TOTAL_VOLUME(reagents) >= 1)
			reagents.trans_to_obj(used_item, REAGENT_MAXIMUM_VOLUME(used_item.reagents))
			to_chat(user, SPAN_NOTICE("You wet \the [used_item] in \the [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		//otherwise store it
		else if(!mymop && user.try_unequip(used_item, src))
			mymop = used_item
			update_icon()
			updateUsrDialog()
			to_chat(user, SPAN_NOTICE("You put \the [used_item] into \the [src]."))
		return TRUE

	if(istype(used_item, /obj/item/chems/spray) && !myspray)
		if(user.try_unequip(used_item, src))
			myspray = used_item
			update_icon()
			updateUsrDialog()
			to_chat(user, SPAN_NOTICE("You put [used_item] into [src]."))
		return TRUE

	if(istype(used_item, /obj/item/lightreplacer) && !myreplacer)
		if(user.try_unequip(used_item, src))
			myreplacer = used_item
			update_icon()
			updateUsrDialog()
			to_chat(user, SPAN_NOTICE("You put \the [used_item] into \the [src]."))
		return TRUE

	else if(istype(used_item, /obj/item/caution))
		if(signs < 4)
			if(!user.try_unequip(used_item, src))
				return TRUE
			signs++
			update_icon()
			updateUsrDialog()
			to_chat(user, SPAN_NOTICE("You put \the [used_item] into \the [src]."))
		else
			to_chat(user, SPAN_NOTICE("\The [src] can't hold any more signs."))
		return TRUE

	if(istype(used_item, /obj/item/chems/glass))
		return FALSE // So we do not put them in the trash bag as we mean to fill the mop bucket; FALSE means run afterattack

	if(mybag)
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
				to_chat(user, SPAN_NOTICE("You take \the [mybag] from \the [src]."))
				mybag = null
				update_icon()
				return TOPIC_REFRESH
			return TOPIC_HANDLED
		if("mop")
			if(mymop)
				user.put_in_hands(mymop)
				to_chat(user, SPAN_NOTICE("You take \the [mymop] from \the [src]."))
				mymop = null
				update_icon()
				return TOPIC_REFRESH
			return TOPIC_HANDLED
		if("spray")
			if(myspray)
				user.put_in_hands(myspray)
				to_chat(user, SPAN_NOTICE("You take \the [myspray] from \the [src]."))
				myspray = null
				update_icon()
				return TOPIC_REFRESH
			return TOPIC_HANDLED
		if("replacer")
			if(myreplacer)
				user.put_in_hands(myreplacer)
				to_chat(user, SPAN_NOTICE("You take \the [myreplacer] from \the [src]."))
				myreplacer = null
				update_icon()
				return TOPIC_REFRESH
			return TOPIC_HANDLED
		if("sign")
			if(signs)
				var/obj/item/caution/Sign = locate() in src
				if(Sign)
					user.put_in_hands(Sign)
					to_chat(user, SPAN_NOTICE("You take \a [Sign] from \the [src]."))
					signs--
				else
					warning("[src] signs ([signs]) didn't match contents")
					signs = 0
				update_icon()
				return TOPIC_REFRESH
			return TOPIC_HANDLED
	return TOPIC_NOACTION

/obj/structure/janitorialcart/on_update_icon()
	..()
	var/list/new_overlays = list("cart_bucket")
	if(REAGENT_TOTAL_LIQUID_VOLUME(reagents))
		new_overlays += "water_cart"
	if(mybag)
		new_overlays += "cart_garbage"
	if(mymop)
		new_overlays += "cart_mop"
	if(myspray)
		new_overlays += "cart_spray"
	if(myreplacer)
		new_overlays += "cart_replacer"
	if(signs)
		new_overlays += "cart_sign[signs]"
	set_overlays(new_overlays)