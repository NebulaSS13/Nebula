/obj/machinery/self_destruct
	name = "\improper Nuclear Cylinder Inserter"
	desc = "A hollow space used to insert nuclear cylinders for arming the self destruct."
	icon = 'icons/obj/machines/self_destruct.dmi'
	icon_state = "empty"
	density = 0
	anchored = 1
	var/obj/item/nuclear_cylinder/cylinder
	var/armed = 0
	var/damaged = 0

/obj/machinery/self_destruct/attackby(obj/item/W, mob/user)
	if(IS_WELDER(W))
		if(damaged)
			user.visible_message("[user] begins to repair [src].", "You begin repairing [src].")
			if(do_after(usr, 100, src))
				var/obj/item/weldingtool/w = W
				if(w.weld(10))
					damaged = 0
					user.visible_message("[user] repairs [src].", "You repair [src].")
				else
					to_chat(user, "<span class='warning'>There is not enough fuel to repair [src].</span>")
				return
	if(istype(W, /obj/item/nuclear_cylinder))
		if(damaged)
			to_chat(user, "<span class='warning'>[src] is damaged, you cannot place the cylinder.</span>")
			return
		if(cylinder)
			to_chat(user, "There is already a cylinder here.")
			return
		user.visible_message("[user] begins to carefully place [W] onto the Inserter.", "You begin to carefully place [W] onto the Inserter.")
		if(do_after(user, 80, src) && user.try_unequip(W, src))
			cylinder = W
			density = 1
			user.visible_message("[user] places [W] onto the Inserter.", "You place [W] onto the Inserter.")
			update_icon()
			return
	..()

/obj/machinery/self_destruct/physical_attack_hand(mob/user)
	if(cylinder)
		. = TRUE
		if(armed)
			if(damaged)
				to_chat(user, "<span class='warning'>The inserter has been damaged, unable to disarm.</span>")
				return
			var/obj/machinery/nuclearbomb/nuke = locate(/obj/machinery/nuclearbomb/station) in get_area(src)
			if(!nuke)
				to_chat(user, "<span class='warning'>Unable to interface with the self destruct terminal, unable to disarm.</span>")
				return
			if(nuke.timing)
				to_chat(user, "<span class='warning'>The self destruct sequence is in progress, unable to disarm.</span>")
				return
			user.visible_message("[user] begins extracting [cylinder].", "You begin extracting [cylinder].")
			if(do_after(user, 40, src))
				user.visible_message("[user] extracts [cylinder].", "You extract [cylinder].")
				armed = 0
				density = 1
				flick("unloading", src)
		else if(!damaged)
			user.visible_message("[user] begins to arm [cylinder].", "You begin to arm [cylinder].")
			if(do_after(user, 40, src))
				armed = 1
				density = 0
				user.visible_message("[user] arms [cylinder].", "You arm [cylinder].")
				flick("loading", src)
				playsound(src.loc,'sound/effects/caution.ogg',50,1,5)
		update_icon()
		src.add_fingerprint(user)

/obj/machinery/self_destruct/handle_mouse_drop(var/atom/over, var/mob/user)
	if(over == user && cylinder)
		if(armed)
			to_chat(user, SPAN_WARNING("Disarm the cylinder first."))
			return TRUE
		user.visible_message( \
			SPAN_NOTICE("\The [user] beings to carefully pick up \the [cylinder]."), \
			SPAN_NOTICE("You begin to carefully pick up \the [cylinder]."))
		if(!do_after(user, 70, src) || !cylinder)
			return TRUE
		user.put_in_hands(cylinder)
		user.visible_message( \
			SPAN_NOTICE("\The [user] picks up \the [cylinder]."), \
			SPAN_NOTICE("You pick up \the [cylinder]."))
		density = FALSE
		cylinder = null
		update_icon()
		add_fingerprint(user)
		return TRUE
	. = ..()

/obj/machinery/self_destruct/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity == 1 || (prob(100 - (25 * severity)))))
		set_damaged()

/obj/machinery/self_destruct/proc/set_damaged()
	if(!damaged)
		visible_message(SPAN_DANGER("\The [src] dents and chars."))
		damaged = 1

/obj/machinery/self_destruct/examine(mob/user)
	. = ..()
	if(damaged)
		to_chat(user, "<span class='warning'>[src] is damaged, it needs repairs.</span>")
		return
	if(armed)
		to_chat(user, "[src] is armed and ready.")
		return
	if(cylinder)
		to_chat(user, "[src] is loaded and ready to be armed.")

/obj/machinery/self_destruct/on_update_icon()
	if(armed)
		icon_state = "armed"
	else if(cylinder)
		icon_state = "loaded"
	else
		icon_state = "empty"