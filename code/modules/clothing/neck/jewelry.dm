/obj/item/clothing/neck/necklace
	name = "necklace"
	desc = "A simple necklace."
	icon = 'icons/clothing/accessories/jewelry/necklace.dmi'
	material = /decl/material/solid/metal/silver

/obj/item/clothing/neck/necklace/locket
	name = "silver locket"
	desc = "A silver locket that seems to have space for a photo within."
	icon = 'icons/clothing/accessories/jewelry/locket.dmi'
	var/open
	var/obj/item/held

/obj/item/clothing/neck/necklace/locket/attack_self(mob/user)
	if(!("[get_world_inventory_state()]-open" in icon_states(icon)))
		to_chat(user, SPAN_WARNING("\The [src] doesn't seem to open."))
		return TRUE
	open = !open
	to_chat(user, SPAN_NOTICE("You flip \the [src] [open ? "open" : "closed"]."))
	if(open && held)
		to_chat(user, SPAN_DANGER("\The [held] falls out!"))
		held.dropInto(user.loc)
		held = null
	update_icon()
	return TRUE

/obj/item/clothing/neck/necklace/locket/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(open && check_state_in_icon("[icon_state]-open", icon))
		icon_state = "[icon_state]-open"

/obj/item/clothing/neck/necklace/locket/attackby(var/obj/item/O, mob/user)
	if(!open)
		to_chat(user, SPAN_WARNING("You have to open it first."))
		return TRUE
	if(istype(O,/obj/item/paper) || istype(O, /obj/item/photo))
		if(held)
			to_chat(usr, SPAN_WARNING("\The [src] already has something inside it."))
		else if(user.try_unequip(O, src))
			to_chat(usr, SPAN_NOTICE("You slip \the [O] into \the [src]."))
			held = O
		return TRUE
	return ..()
