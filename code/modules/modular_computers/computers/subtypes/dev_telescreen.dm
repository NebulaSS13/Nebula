/obj/item/modular_computer/telescreen
	name = "telescreen"
	desc = "A wall-mounted touchscreen computer."
	icon = 'icons/obj/modular_computers/modular_telescreen.dmi'
	icon_state = "telescreen"
	anchored = TRUE
	density = 0
	light_strength = 4
	w_class = ITEM_SIZE_HUGE
	computer_type = /datum/extension/assembly/modular_computer/telescreen

/obj/item/modular_computer/telescreen/Initialize()
	. = ..()
	// Allows us to create "north bump" "south bump" etc. named objects, for more comfortable mapping.
	name = "telescreen"

/obj/item/modular_computer/telescreen/attackby(var/obj/item/W, var/mob/user)
	var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly/modular_computer)
	if(isCrowbar(W))
		if(anchored)
			shutdown_computer()
			anchored = FALSE
			assembly.screen_on = FALSE
			pixel_x = 0
			pixel_y = 0
			to_chat(user, "You unsecure \the [src].")
		else
			var/choice = input(user, "Where do you want to place \the [src]?", "Offset selection") in list("North", "South", "West", "East", "This tile", "Cancel")
			var/valid = FALSE
			switch(choice)
				if("North")
					valid = TRUE
					pixel_y = 32
				if("South")
					valid = TRUE
					pixel_y = -32
				if("West")
					valid = TRUE
					pixel_x = -32
				if("East")
					valid = TRUE
					pixel_x = 32
				if("This tile")
					valid = TRUE

			if(valid)
				anchored = 1
				assembly.screen_on = TRUE
				to_chat(user, "You secure \the [src].")
			return
	..()