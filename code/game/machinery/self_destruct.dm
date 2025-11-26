/obj/machinery/self_destruct
	name = "\improper Nuclear Cylinder Inserter"
	desc = "A hollow space used to insert nuclear cylinders for arming the self-destruct mechanism."
	icon = 'icons/obj/machines/self_destruct.dmi'
	icon_state = "empty"
	density = FALSE
	anchored = TRUE
	var/obj/item/nuclear_cylinder/cylinder
	var/armed = 0
	var/damaged = 0

/obj/machinery/self_destruct/attackby(obj/item/used_item, mob/user)
	if(IS_WELDER(used_item))
		if(!damaged)
			return FALSE
		user.visible_message("[user] begins to repair [src].", "You begin repairing [src].")
		if(do_after(user, 10 SECONDS, src))
			var/obj/item/weldingtool/w = used_item
			if(w.weld(10))
				damaged = 0
				user.visible_action_message("repair", "\the [src].")
			else
				to_chat(user, "<span class='warning'>There is not enough fuel to repair [src].</span>")
		return TRUE
	if(istype(used_item, /obj/item/nuclear_cylinder))
		if(damaged)
			to_chat(user, "<span class='warning'>[src] is damaged, you cannot place the cylinder.</span>")
			return TRUE
		if(cylinder)
			to_chat(user, "There is already a cylinder here.")
			return TRUE
		user.visible_action_message("begin", "to carefully place \the [used_item] onto \the [src].")
		if(do_after(user, 8 SECONDS, src) && user.try_unequip(used_item, src))
			cylinder = used_item
			density = TRUE
			user.visible_action_message("place", "\the [used_item] onto \the [src].")
			update_icon()
		return TRUE
	return ..()

/obj/machinery/self_destruct/physical_attack_hand(mob/user)
	. = FALSE
	if(cylinder)
		. = TRUE
		if(armed)
			if(damaged)
				to_chat(user, "<span class='warning'>The inserter has been damaged, unable to disarm.</span>")
				return
			var/obj/machinery/nuclearbomb/nuke = locate(/obj/machinery/nuclearbomb/station) in get_area(src)
			if(!nuke)
				to_chat(user, "<span class='warning'>Unable to interface with the self-destruct terminal, unable to disarm.</span>")
				return
			if(nuke.timing)
				to_chat(user, "<span class='warning'>The self-destruct sequence is in progress, unable to disarm.</span>")
				return
			user.visible_action_message("begin", "extracting \the [cylinder].")
			if(do_after(user, 4 SECONDS, src))
				user.visible_action_message("extract", "\the [cylinder].")
				armed = 0
				density = TRUE
				flick("unloading", src)
		else if(!damaged)
			user.visible_action_message("begin", "to arm \the [cylinder].")
			if(do_after(user, 4 SECONDS, src))
				armed = 1
				density = FALSE
				user.visible_action_message("arm", "\the [cylinder].")
				flick("loading", src)
				playsound(src.loc,'sound/effects/caution.ogg',50,1,5)
		update_icon()
		src.add_fingerprint(user)

/obj/machinery/self_destruct/handle_mouse_drop(atom/over, mob/user, params)
	if(over == user && cylinder)
		if(armed)
			to_chat(user, SPAN_WARNING("Disarm the cylinder first."))
			return TRUE
		user.visible_action_message("begin", "to carefully pick up \the [cylinder].")
		if(!do_after(user, 7 SECONDS, src) || !cylinder)
			return TRUE
		user.put_in_hands(cylinder)
		user.visible_action_message("pick", "up \the [cylinder].")
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

/obj/machinery/self_destruct/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(damaged)
		. += SPAN_WARNING("\The [src] is damaged and needs to be repaired.")
		return
	if(armed)
		. += SPAN_DANGER("\The [src] is armed and ready.")
		return
	if(cylinder)
		. += "\the [src] is loaded and ready to be armed."

/obj/machinery/self_destruct/on_update_icon()
	if(armed)
		icon_state = "armed"
	else if(cylinder)
		icon_state = "loaded"
	else
		icon_state = "empty"