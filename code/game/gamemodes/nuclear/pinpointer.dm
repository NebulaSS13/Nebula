//Nuke ops locator
/obj/item/pinpointer/nukeop
	var/locate_shuttle = 0

/obj/item/pinpointer/nukeop/Process()
	var/new_mode
	if(!locate_shuttle && bomb_set)
		locate_shuttle = 1
		new_mode = "Shuttle Locator"
	else if (locate_shuttle && !bomb_set)
		locate_shuttle = 0
		new_mode = "Authentication Disk Locator"
	if(new_mode)
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
		visible_message("<span class='notice'>[new_mode] active.</span>")
		target = acquire_target()
	..()

/obj/item/pinpointer/nukeop/acquire_target()
	if(locate_shuttle)
		var/obj/machinery/computer/shuttle_control/multi/mercenary/home = locate()
		return weakref(home)
	else
		return ..()