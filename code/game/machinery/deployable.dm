//Deployable machinery stuff
/obj/machinery/deployable
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
	var/locked = 0.0

/obj/machinery/deployable/barrier/Initialize()
	. = ..()
	icon_state = "barrier[src.locked]"

/obj/machinery/deployable/barrier/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/card/id))
		if (src.allowed(user))
			if	(src.emagged < 2.0)
				src.locked = !src.locked
				src.anchored = !src.anchored
				src.icon_state = "barrier[src.locked]"
				if ((src.locked == 1.0) && (src.emagged < 2.0))
					to_chat(user, "Barrier lock toggled on.")
					return
				else if ((src.locked == 0.0) && (src.emagged < 2.0))
					to_chat(user, "Barrier lock toggled off.")
					return
			else
				spark_at(src, amount=2, cardinal_only = TRUE)
				visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
				return
		return
	else if(IS_WRENCH(W))
		var/current_max_health = get_max_health()
		if (current_health < current_max_health)
			current_health = current_max_health
			emagged = 0
			req_access = list(access_security)
			visible_message("<span class='warning'>[user] repairs \the [src]!</span>")
			return
		else if (src.emagged > 0)
			src.emagged = 0
			src.req_access = list(access_security)
			visible_message("<span class='warning'>[user] repairs \the [src]!</span>")
			return
		return
	else
		switch(W.atom_damage_type)
			if(BURN)
				current_health -= W.get_attack_force(user) * 0.75
			if(BRUTE)
				current_health -= W.get_attack_force(user) * 0.5
		if (current_health <= 0)
			explode()
		..()

/obj/machinery/deployable/barrier/explosion_act(severity)
	. = ..()
	if(. && !QDELETED(src))
		if(severity == 1)
			current_health = 0
		else if(severity == 2)
			current_health -= 25
		if(current_health <= 0)
			explode()

/obj/machinery/deployable/barrier/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(prob(50/severity))
		locked = !locked
		anchored = !anchored
		icon_state = "barrier[src.locked]"

/obj/machinery/deployable/barrier/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	else
		return 0

/obj/machinery/deployable/barrier/physically_destroyed(skip_qdel)
	SSmaterials.create_object(/decl/material/solid/metal/steel, get_turf(src), 1, /obj/item/stack/material/rods)
	. = ..()

/obj/machinery/deployable/barrier/proc/explode()
	visible_message("<span class='danger'>[src] blows apart!</span>")
	spark_at(src, cardinal_only = TRUE)
	explosion(src.loc,-1,-1,0)
	if(!QDELETED(src))
		physically_destroyed()

/obj/machinery/deployable/barrier/emag_act(var/remaining_charges, var/mob/user)
	if (src.emagged == 0)
		src.emagged = 1
		src.req_access.Cut()
		to_chat(user, "You break the ID authentication lock on \the [src].")
		spark_at(src, amount=2, cardinal_only = TRUE)
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return 1
	else if (src.emagged == 1)
		src.emagged = 2
		to_chat(user, "You short out the anchoring mechanism on \the [src].")
		spark_at(src, amount=2, cardinal_only = TRUE)
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return 1
