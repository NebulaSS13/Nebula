// Cheap, shitty, hacky means of draining water without a proper pipe system.
// TODO: water pipes.
/obj/structure/hygiene/drain
	name = "gutter"
	desc = "You probably can't get sucked down the plughole."
	icon = 'icons/obj/drain.dmi'
	icon_state = "drain"
	anchored = 1
	density = 0
	layer = TURF_LAYER+0.1
	can_drain = 1
	var/welded

/obj/structure/hygiene/drain/examine(mob/user)
	. = ..()
	if(welded)
		to_chat(user, "It is welded shut.")

/obj/structure/hygiene/drain/attackby(var/obj/item/thing, var/mob/user)
	..()
	if(IS_WELDER(thing))
		var/obj/item/weldingtool/WT = thing
		if(WT.isOn())
			welded = !welded
			to_chat(user, "<span class='notice'>You weld \the [src] [welded ? "closed" : "open"].</span>")
		else
			to_chat(user, "<span class='warning'>Turn \the [thing] on, first.</span>")
		update_icon()
		return
	if(IS_WRENCH(thing))
		new /obj/item/drain(src.loc)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, "<span class='warning'>[user] unwrenches the [src].</span>")
		qdel(src)
		return
	return ..()

/obj/structure/hygiene/drain/on_update_icon()
	..()
	icon_state = "[initial(icon_state)][welded ? "-welded" : ""]"

/obj/structure/hygiene/drain/Process()
	if(welded)
		return
	..()

//for construction.
/obj/item/drain
	name = "gutter"
	desc = "You probably can't get sucked down the plughole."
	icon = 'icons/obj/drain.dmi'
	icon_state = "drain"
	material = /decl/material/solid/metal/brass
	var/constructed_type = /obj/structure/hygiene/drain

/obj/item/drain/attackby(var/obj/item/thing, var/mob/user)
	if(IS_WRENCH(thing))
		new constructed_type(get_turf(src))
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [user] wrenches the [src] down."))
		qdel(src)
		return
	return ..()

/obj/structure/hygiene/drain/bath
	name = "sealable drain"
	desc = "You probably can't get sucked down the plughole. Specially not when it's closed!"
	icon_state = "drain_bath"

	var/closed = FALSE

/obj/structure/hygiene/drain/bath/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return ..()
	if(welded)
		return ..()
	closed = !closed
	user.visible_message(SPAN_NOTICE("\The [user] has [closed ? "closed" : "opened"] the drain."))
	update_icon()
	return TRUE

/obj/structure/hygiene/drain/bath/on_update_icon()
	..()
	if(welded)
		icon_state = "[initial(icon_state)]-welded"
	else
		icon_state = "[initial(icon_state)][closed ? "-closed" : ""]"

/obj/structure/hygiene/drain/bath/examine(mob/user)
	. = ..()
	to_chat(user, "It is [closed ? "closed" : "open"]")

/obj/structure/hygiene/drain/bath/Process()
	if(closed)
		return
	..()

/obj/item/drain/bath
	name = "sealable drain"
	desc = "You probably can't get sucked down the plughole. Specially not when it's closed!"
	icon_state = "drain_bath"
	constructed_type = /obj/structure/hygiene/drain/bath
