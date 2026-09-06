/obj/structure/sign/double/barsign
	name = "barsign"
	desc = "A jumbo-sized LED sign. This one seems to be showing its age."
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "empty"
	appearance_flags = 0
	anchored = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":-32}, "WEST":{"x":32}}'
	var/cult = 0

/obj/structure/sign/double/barsign/proc/get_valid_states(initial=1)
	. = icon_states(icon)
	. -= "on"
	. -= "narsiebistro"
	. -= "empty"
	if(initial)
		. -= "Off"

/obj/structure/sign/double/barsign/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	switch(icon_state)
		if("Off")
			. += "It appears to be switched off."
		if("narsiebistro")
			. += "It shows a picture of a large black and red being. Spooky!"
		if("on", "empty")
			. += "The lights are on, but there's no picture."
		else
			. += "It says '[icon_state]'."

/obj/structure/sign/double/barsign/Initialize()
	. = ..()
	icon_state = pick(get_valid_states())

/obj/structure/sign/double/barsign/attackby(obj/item/used_item, mob/user)
	if(cult)
		return ..()

	var/obj/item/card/id/card = used_item.GetIdCard()
	if(istype(card))
		if(access_bar in card.GetAccess())
			var/sign_type = input(user, "What would you like to change the barsign to?") as null|anything in get_valid_states(0)
			if(!sign_type)
				return TRUE
			icon_state = sign_type
			to_chat(user, "<span class='notice'>You change the barsign.</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return TRUE

	return ..()
