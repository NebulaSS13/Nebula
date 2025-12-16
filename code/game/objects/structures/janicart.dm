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

/datum/movement_handler/move_relay_self/janicart/MayMove(mob/mover, is_external)
	. = ..()
	if(. == MOVEMENT_PROCEED && !is_external && !(locate(/obj/item/janicart_key) in mover.get_held_items()))
		var/obj/structure/janicart/janicart = host
		to_chat(mover, SPAN_WARNING("You'll need the keys in one of your hands to drive this [istype(janicart) ? janicart.callme : host.name]."))
		return MOVEMENT_STOP

//old style cart
/obj/structure/janicart
	name = "janicart"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "pussywagon"
	can_buckle = TRUE
	buckle_lying = FALSE // force people to sit up when buckled to it
	buckle_sound = 'sound/effects/buckle.ogg'
	buckle_layer_above = TRUE
	buckle_movable = TRUE
	color = null
	anchored = FALSE
	density =  TRUE
	material_alteration = MAT_FLAG_ALTERATION_NONE
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	chem_volume = 100
	movement_handlers = list(
		/datum/movement_handler/deny_multiz,
		/datum/movement_handler/delay = list(1),
		/datum/movement_handler/move_relay_self/janicart
	)
	var/obj/item/bag/trash/mybag = null
	var/callme = "pimpin' ride"	//how do people refer to it?

/obj/structure/janicart/Initialize()
	// Handled in init due to dirs needing to be stringified
	buckle_pixel_shift = list(
		"[NORTH]" = list("x" =   0, "y" = 4, "z" = 0),
		"[SOUTH]" = list("x" =   0, "y" = 7, "z" = 0),
		"[EAST]"  = list("x" = -13, "y" = 7, "z" = 0),
		"[WEST]"  = list("x" =  13, "y" = 7, "z" = 0)
	)
	. = ..()

/obj/structure/janicart/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "[html_icon(src)] This [callme] contains [REAGENT_TOTAL_VOLUME(reagents)] unit\s of water!"
		if(mybag)
			. += "\A [mybag] is hanging on the [callme]."

/obj/structure/janicart/attackby(obj/item/used_item, mob/user)

	if(istype(used_item, /obj/item/mop))
		if(REAGENT_TOTAL_VOLUME(reagents) > 1)
			reagents.trans_to_obj(used_item, 2)
			to_chat(user, SPAN_NOTICE("You wet [used_item] in the [callme]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, SPAN_NOTICE("This [callme] is out of water!"))
		return TRUE

	if(istype(used_item, /obj/item/janicart_key))
		to_chat(user, SPAN_NOTICE("Hold \the [used_item] in one of your hands while you drive this [callme]."))
		return TRUE

	if(istype(used_item, /obj/item/bag/trash))
		if(!user.try_unequip(used_item, src))
			return TRUE
		to_chat(user, SPAN_NOTICE("You hook \the [used_item] onto the [callme]."))
		mybag = used_item
		return TRUE

	. = ..()

/obj/structure/janicart/attack_hand(mob/user)
	if(!mybag || !user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	user.put_in_hands(mybag)
	mybag = null
	return TRUE

/obj/structure/janicart/handle_buckled_relaymove(var/datum/movement_handler/mh, var/mob/mob, var/direction, var/mover)
	if(isspaceturf(loc))
		return
	. = MOVEMENT_HANDLED
	DoMove(mob.AdjustMovementDirection(direction, mover), mob)

/obj/structure/janicart/relaymove(mob/user, direction)
	if(user.incapacitated(INCAPACITATION_DISRUPTED))
		unbuckle_mob()
	user.glide_size = glide_size
	step(src, direction)
	set_dir(direction)

/obj/structure/janicart/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob)
		if(prob(85))
			return buckled_mob.bullet_act(Proj)
	visible_message(SPAN_WARNING("\The [Proj] ricochets off the [callme]!"))

/obj/item/janicart_key
	name = "key"
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE)
