/obj/structure/firedoor_assembly
	name = "emergency shutter assembly"
	desc = "The frame and panelling for an emergency shutter. It can save lives."
	icon = 'icons/obj/doors/hazard/door.dmi'
	icon_state = "construction"
	anchored = FALSE
	opacity =  FALSE
	density =  TRUE
	tool_interaction_flags = TOOL_INTERACTION_ALL

/obj/structure/firedoor_assembly/attackby(var/obj/item/C, var/mob/user)
	. = ..()
	if(!. && istype(C, /obj/item/stock_parts/circuitboard/airlock_electronics/firedoor) && wired)
		if(!anchored)
			to_chat(user, SPAN_WARNING("You must secure \the [src] first!"))
		else
			if(!user.unEquip(C, src))
				return
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			visible_message(SPAN_NOTICE("\The [user] inserts a circuit into \the [src]."))
			var/obj/machinery/door/firedoor/D = new(get_turf(src), dir, FALSE)
			var/obj/item/stock_parts/circuitboard/airlock_electronics/firedoor/electronics = C
			D.install_component(C)
			electronics.construct(D)
			D.construct_state.post_construct(D)
			D.close()
			qdel(src)
		. = TRUE
