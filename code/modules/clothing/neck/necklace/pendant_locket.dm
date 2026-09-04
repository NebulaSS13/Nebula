/obj/item/pendant/locket
	name = "locket"
	desc = "A locket that seems to have space for a photo within."
	icon = 'icons/clothing/accessories/jewelry/pendants/locket.dmi'
	var/open
	var/obj/item/held

/obj/item/pendant/locket/attack_self(mob/user)
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

/obj/item/pendant/locket/on_update_icon()
	. = ..()
	icon_state = get_pendant_base_state(get_world_inventory_state())
	if(istype(loc, /obj/item))
		loc.update_icon()

/obj/item/pendant/locket/get_pendant_base_state(base_state)
	. = ..()
	if(open)
		. = "[.]-open"

/obj/item/pendant/locket/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	if(overlay && open)
		var/pendant_state = get_pendant_base_state(overlay.icon_state)
		if(check_state_in_icon(pendant_state, overlay.icon))
			overlay.icon_state = pendant_state
	return ..()

/obj/item/pendant/locket/attackby(obj/item/used_item, mob/user)
	if(!open)
		to_chat(user, SPAN_WARNING("You have to open it first."))
		return TRUE
	if(istype(used_item, /obj/item/paper) || istype(used_item, /obj/item/photo))
		if(held)
			to_chat(user, SPAN_WARNING("\The [src] already has something inside it."))
		else if(user.try_unequip(used_item, src))
			to_chat(user, SPAN_NOTICE("You slip \the [used_item] into \the [src]."))
			held = used_item
		return TRUE
	return ..()