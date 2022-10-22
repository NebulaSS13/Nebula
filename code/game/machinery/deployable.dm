//Deployable machinery stuff
/obj/machinery/deployable //#TODO: Bring this up to date with current machinery
	name = "deployable"
	desc = "Deployable."
	icon = 'icons/obj/objects.dmi'
	initial_access = list(access_security)

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = FALSE
	density = TRUE
	icon_state = "barrier0"
	max_health = 100
	var/locked = FALSE

/obj/machinery/deployable/barrier/Initialize()
	. = ..()
	update_icon()

/obj/machinery/deployable/barrier/on_update_icon()
	icon_state = "barrier[locked]"

/obj/machinery/deployable/barrier/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/card/id))
		if (allowed(user))
			if(emagged < 2)
				set_locked(!locked, user)
			else
				spark_at(src, amount=2, cardinal_only = TRUE)
				visible_message(SPAN_WARNING("BZZzZZzZZzZT"))
		return TRUE
	
	else if(IS_WRENCH(W))
		if (is_damaged())
			heal(max_health)
			emagged = FALSE
			req_access = list(access_security)
			visible_message(SPAN_WARNING("[user] repairs \the [src]!"))
		else if (emagged > 0)
			emagged = FALSE
			req_access = list(access_security)
			visible_message(SPAN_WARNING("[user] repairs \the [src]!"))
		return TRUE
	return ..()

/obj/machinery/deployable/barrier/take_damage(amount, damage_type, damage_flags, inflicter, armor_pen, target_zone, quiet)
	//#TODO: Move this to the proper place once we handle armor damage reduction.
	switch(damage_type)
		if(BURN)
			amount *= 0.75
		if(BRUTE)
			amount *= 0.5
	. = ..(amount, damage_type, damage_flags, inflicter, armor_pen, target_zone, quiet)

/obj/machinery/deployable/barrier/physically_destroyed(skip_qdel)
	explode()
	SSmaterials.create_object(/decl/material/solid/metal/steel, get_turf(src), 1, /obj/item/stack/material/rods)
	return ..()

/obj/machinery/deployable/barrier/proc/explode()
	visible_message(SPAN_DANGER("[src] blows apart!"))
	spark_at(src, cardinal_only = TRUE)
	explosion(loc, -1, -1, 0)
	if(!QDELETED(src))
		qdel(src)

/obj/machinery/deployable/barrier/emp_act(severity)
	if(!use_power || inoperable())
		return
	if(prob(50/severity))
		set_locked(!locked)
	return ..()

///Lock the barrier in place, or unlock it
/obj/machinery/deployable/barrier/proc/set_locked(var/state, var/mob/user)
	locked = state
	anchored = locked
	if(user)
		if(locked)
			to_chat(user, SPAN_NOTICE("Barrier lock toggled on."))
		else
			to_chat(user, SPAN_NOTICE("Barrier lock toggled off."))
	update_icon()

/obj/machinery/deployable/barrier/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		return TRUE
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return TRUE
	return FALSE

/obj/machinery/deployable/barrier/emag_act(remaining_charges, mob/user)
	. = ..()
	if (!emagged)
		emagged = TRUE
		to_chat(user, "You break the ID authentication lock on \the [src].")
		spark_at(src, cardinal_only = TRUE)
		visible_message(SPAN_WARNING("BZZzZZzZZzZT"))
		return TRUE

	else if (emagged && anchored)
		to_chat(user, "You short out the anchoring mechanism on \the [src].")
		spark_at(src, cardinal_only = TRUE)
		visible_message(SPAN_WARNING("BZZzZZzZZzZT"))
		return TRUE
