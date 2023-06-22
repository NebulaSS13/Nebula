/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "The ultimate in janitorial carts! Has space for water, mops, signs, trash bags, and more!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"
	anchored = 0
	density = 1
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_CLIMBABLE
	movable_flags = MOVABLE_FLAG_WHEELED
	var/obj/item/storage/bag/trash/mybag	= null
	var/obj/item/mop/mymop = null
	var/obj/item/chems/spray/myspray = null
	var/obj/item/lightreplacer/myreplacer = null
	var/signs = 0	//maximum capacity hardcoded below


/obj/structure/janitorialcart/Initialize()
	. = ..()
	create_reagents(180)

/obj/structure/janitorialcart/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "[src] [html_icon(src)] contains [reagents.total_volume] unit\s of liquid!")


/obj/structure/janitorialcart/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/storage/bag/trash) && !mybag)
		if(!user.try_unequip(I, src))
			return
		mybag = I
		update_icon()
		updateUsrDialog()
		to_chat(user, "<span class='notice'>You put [I] into [src].</span>")

	else if(istype(I, /obj/item/mop))
		if(I.reagents.total_volume < I.reagents.maximum_volume)	//if it's not completely soaked we assume they want to wet it, otherwise store it
			if(reagents.total_volume < 1)
				to_chat(user, "<span class='warning'>[src] is out of water!</span>")
			else
				reagents.trans_to_obj(I, I.reagents.maximum_volume)
				to_chat(user, "<span class='notice'>You wet [I] in [src].</span>")
				playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
				return
		if(!mymop)
			if(!user.try_unequip(I, src))
				return
			mymop = I
			update_icon()
			updateUsrDialog()
			to_chat(user, "<span class='notice'>You put [I] into [src].</span>")

	else if(istype(I, /obj/item/chems/spray) && !myspray)
		if(!user.try_unequip(I, src))
			return
		myspray = I
		update_icon()
		updateUsrDialog()
		to_chat(user, "<span class='notice'>You put [I] into [src].</span>")

	else if(istype(I, /obj/item/lightreplacer) && !myreplacer)
		if(!user.try_unequip(I, src))
			return
		myreplacer = I
		update_icon()
		updateUsrDialog()
		to_chat(user, "<span class='notice'>You put [I] into [src].</span>")

	else if(istype(I, /obj/item/caution))
		if(signs < 4)
			if(!user.try_unequip(I, src))
				return
			signs++
			update_icon()
			updateUsrDialog()
			to_chat(user, "<span class='notice'>You put [I] into [src].</span>")
		else
			to_chat(user, "<span class='notice'>[src] can't hold any more signs.</span>")

	else if(istype(I, /obj/item/chems/glass))
		return // So we do not put them in the trash bag as we mean to fill the mop bucket

	else if(mybag)
		mybag.attackby(I, user)


/obj/structure/janitorialcart/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_GRIP, TRUE))
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

/obj/structure/janitorialcart/Topic(href, href_list)
	if(!in_range(src, usr))
		return
	if(!isliving(usr))
		return
	var/mob/living/user = usr

	if(href_list["take"])
		switch(href_list["take"])
			if("garbage")
				if(mybag)
					user.put_in_hands(mybag)
					to_chat(user, "<span class='notice'>You take [mybag] from [src].</span>")
					mybag = null
			if("mop")
				if(mymop)
					user.put_in_hands(mymop)
					to_chat(user, "<span class='notice'>You take [mymop] from [src].</span>")
					mymop = null
			if("spray")
				if(myspray)
					user.put_in_hands(myspray)
					to_chat(user, "<span class='notice'>You take [myspray] from [src].</span>")
					myspray = null
			if("replacer")
				if(myreplacer)
					user.put_in_hands(myreplacer)
					to_chat(user, "<span class='notice'>You take [myreplacer] from [src].</span>")
					myreplacer = null
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

	update_icon()
	updateUsrDialog()


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
		var/obj/structure/bed/chair/janicart/janicart = host
		to_chat(mover, SPAN_WARNING("You'll need the keys in one of your hands to drive this [istype(janicart) ? janicart.callme : host.name]."))
		return MOVEMENT_STOP

//old style cart
/obj/structure/bed/chair/janicart
	name = "janicart"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "pussywagon"
	anchored = FALSE
	density =  TRUE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
	buckle_layer_above = TRUE
	buckle_movable = TRUE
	movement_handlers = list(
		/datum/movement_handler/deny_multiz,
		/datum/movement_handler/delay = list(1),
		/datum/movement_handler/move_relay_self/janicart
	)

	var/obj/item/storage/bag/trash/mybag = null
	var/callme = "pimpin' ride"	//how do people refer to it?

/obj/structure/bed/chair/janicart/Initialize()
	// Handled in init due to dirs needing to be stringified
	buckle_pixel_shift = list(
		"[NORTH]" = list("x" =   0, "y" = 4, "z" = 0),
		"[SOUTH]" = list("x" =   0, "y" = 7, "z" = 0),
		"[EAST]"  = list("x" = -13, "y" = 7, "z" = 0),
		"[WEST]"  = list("x" =  13, "y" = 7, "z" = 0)
	)
	. = ..()
	create_reagents(100)

/obj/structure/bed/chair/janicart/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "[html_icon(src)] This [callme] contains [reagents.total_volume] unit\s of water!")
		if(mybag)
			to_chat(user, "\A [mybag] is hanging on the [callme].")

/obj/structure/bed/chair/janicart/attackby(obj/item/I, mob/user)

	if(istype(I, /obj/item/mop))
		if(reagents.total_volume > 1)
			reagents.trans_to_obj(I, 2)
			to_chat(user, SPAN_NOTICE("You wet [I] in the [callme]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, SPAN_NOTICE("This [callme] is out of water!"))
		return TRUE

	if(istype(I, /obj/item/janicart_key))
		to_chat(user, SPAN_NOTICE("Hold \the [I] in one of your hands while you drive this [callme]."))
		return TRUE

	if(istype(I, /obj/item/storage/bag/trash))
		if(!user.try_unequip(I, src))
			return
		to_chat(user, SPAN_NOTICE("You hook \the [I] onto the [callme]."))
		mybag = I
		return TRUE

	. = ..()

/obj/structure/bed/chair/janicart/attack_hand(mob/user)
	if(!mybag || !user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	user.put_in_hands(mybag)
	mybag = null
	return TRUE

/obj/structure/bed/chair/janicart/handle_buckled_relaymove(var/datum/movement_handler/mh, var/mob/mob, var/direction, var/mover)
	if(isspaceturf(loc))
		return
	. = MOVEMENT_HANDLED
	DoMove(mob.AdjustMovementDirection(direction, mover), mob)

/obj/structure/bed/chair/janicart/relaymove(mob/user, direction)
	if(user.incapacitated(INCAPACITATION_DISRUPTED))
		unbuckle_mob()
	user.glide_size = glide_size
	step(src, direction)
	set_dir(direction)

/obj/structure/bed/chair/janicart/bullet_act(var/obj/item/projectile/Proj)
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
	matter = list(/decl/material/solid/plastic = MATTER_AMOUNT_TRACE)
