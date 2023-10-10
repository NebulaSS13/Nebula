/obj/structure/firedoor_assembly
	name = "emergency shutter assembly"
	desc = "The frame and panelling for an emergency shutter. It can save lives."
	icon = 'icons/obj/doors/hazard/door.dmi'
	icon_state = "construction"
	anchored = FALSE
	opacity =  FALSE
	density =  TRUE
	tool_interaction_flags = TOOL_INTERACTION_ALL

	var/result = /obj/machinery/door/firedoor

/obj/structure/firedoor_assembly/attackby(var/obj/item/C, var/mob/user)
	. = ..()
	if(!. && istype(C, /obj/item/stock_parts/circuitboard/airlock_electronics/firedoor) && wired)
		if(!anchored)
			to_chat(user, SPAN_WARNING("You must secure \the [src] first!"))
		else
			if(!user.try_unequip(C, src))
				return
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			visible_message(SPAN_NOTICE("\The [user] inserts a circuit into \the [src]."))
			var/obj/machinery/door/firedoor/D = new result(get_turf(src), dir, FALSE)
			var/obj/item/stock_parts/circuitboard/airlock_electronics/firedoor/electronics = C
			D.install_component(C)
			electronics.construct(D)
			D.construct_state.post_construct(D)
			D.close()
			qdel(src)
		. = TRUE

/obj/structure/firedoor_assembly/border
	name = "unidirectional emergency shutter assembly"
	icon = 'icons/obj/doors/hazard/door_border.dmi'
	result = /obj/machinery/door/firedoor/border

/obj/structure/firedoor_assembly/border/verb/rotate_clock()
	set category = "Object"
	set name = "Rotate Assembly (Clockwise)"
	set src in view(1)

	if (usr.incapacitated() || anchored)
		return

	set_dir(turn(dir, -90))

/obj/structure/firedoor_assembly/border/verb/rotate_anticlock()
	set category = "Object"
	set name = "Rotate Assembly (Counter-clockwise)"
	set src in view(1)

	if (usr.incapacitated() || anchored)
		return

	set_dir(turn(dir, 90))
