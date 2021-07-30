/obj/structure/fuel_port
	name = "fuel port"
	desc = "The fuel input port of the shuttle. Holds one fuel tank. Use a crowbar to open and close it."
	icon = 'icons/obj/structures/fuel_port.dmi'
	icon_state = "base"

	density = FALSE
	anchored = TRUE

	var/open = FALSE
	var/parent_shuttle

	var/sound_open = 'sound/effects/locker_open.ogg'
	var/sound_close = 'sound/effects/locker_close.ogg'

	/// Used to create a prepared tank on initialization.
	var/start_tank_type

/obj/structure/fuel_port/Initialize()
	. = ..()
	if(start_tank_type)
		new start_tank_type(src)

/obj/structure/fuel_port/proc/locate_tank()
	return locate(/obj/item/tank) in contents

/obj/structure/fuel_port/attack_hand(mob/user)
	if(!open)
		to_chat(user, SPAN_WARNING("The door is secured tightly. You'll need a crowbar to open it."))
		return
	else
		var/obj/item/tank/tank = locate_tank()
		if(tank)
			user.put_in_hands(tank)

	update_icon()

/obj/structure/fuel_port/on_update_icon()
	cut_overlays()

	if(open)
		add_overlay("[icon_state]_open")
		var/obj/item/tank/tank = locate_tank()
		if(tank)
			if(tank.color)
				add_overlay(mutable_appearance(icon, "[icon_state]_tank", tank.color))
			else
				add_overlay("[icon_state]_tank_orange")
	else
		add_overlay("[icon_state]_closed")

/obj/structure/fuel_port/attackby(obj/item/W, mob/user)
	if(W.do_tool_interaction(TOOL_CROWBAR, user, src, 1 SECOND))
		if(open)
			playsound(src, sound_open, 25, 0, -3)
			open = FALSE
		else
			playsound(src, sound_close, 15, 1, -3)
			open = TRUE

	else if(istype(W, /obj/item/tank))
		if(!open)
			to_chat(user, SPAN_WARNING("\The [src] door is still closed!"))
			return

		if(locate_tank())
			to_chat(user, SPAN_WARNING("\The [src] already has a tank inside!"))
			return
		else
			user.unEquip(W, src)

	update_icon()

// Walls hide stuff inside them, but we want to be visible.
/obj/structure/fuel_port/hide()
	return

// And here subtype with inserted tank.
/obj/structure/fuel_port/hydrogen
	start_tank_type = /obj/item/tank/hydrogen
