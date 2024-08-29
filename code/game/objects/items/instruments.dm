/obj/item/guitar
	name = "guitar"
	desc = "An antique musical instrument made of wood, originating from Earth. It has six metal strings of different girth and tension. When moved, they vibrate and the waves resonate in the guitar's open body, producing sounds. Obtained notes can be altered by pressing the strings to the neck, affecting the vibration's frequency."
	icon = 'icons/obj/items/guitar.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/organic/wood
	slot_flags = SLOT_BACK
	throw_speed = 3
	throw_range = 6

/obj/item/guitar/attack_self(mob/user)
	. = ..()
	if(!.)
		user.visible_message(
			SPAN_NOTICE("\The [user] strums \the [src]!"),
			SPAN_NOTICE("You strum \the [src]!"))
		return TRUE
