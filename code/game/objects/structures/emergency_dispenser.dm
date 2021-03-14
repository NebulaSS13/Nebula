
//spawns endless (3 sets) amounts of breathmask, emergency oxy tank
/obj/structure/emergency_dispenser
	name = "emergency dispenser"
	desc = "A wall mounted dispenser with emergency supplies."
	icon = 'icons/obj/structures/emergency_dispenser.dmi'
	icon_state = "world"
	anchored = TRUE
	var/static/list/spawnitems = list(/obj/item/tank/emergency/oxygen,/obj/item/clothing/mask/breath)
	var/amount = 3 // spawns each items X times.

/obj/structure/emergency_dispenser/attack_hand(mob/user)
	if(!CanPhysicallyInteract(user))	//Added by Strumpetplaya - AI shouldn't be able to  (you're both stupid, need CanPhysicallyInteract --Chinsky)
		return							//activate emergency lockers.  This fixes that.  (Does this make sense, the AI can't call attack_hand, can it? --Mloc) 
	. = TRUE
	if(!amount)
		to_chat(user, SPAN_WARNING("It's empty."))
	else
		to_chat(user, SPAN_NOTICE("You take out some items from \the [src]."))
		playsound(src, 'sound/machines/vending_machine.ogg', 25, 1)
		for(var/path in spawnitems)
			new path(src.loc)
		amount--

/obj/structure/emergency_dispenser/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/emergency_dispenser/south
	pixel_y = -32
	dir = NORTH

/obj/structure/emergency_dispenser/west
	pixel_x = -32
	dir = WEST

/obj/structure/emergency_dispenser/east
	pixel_x = 32
	dir = EAST
