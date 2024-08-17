/obj/item/gun/launcher/bow/proc/can_load_arrow(obj/item/ammo)
	return istype(ammo, bow_ammo_type)

/obj/item/gun/launcher/bow/proc/load_arrow(mob/user, obj/item/ammo)
	if(initial(string) && !istype(string))
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] has no bowstring!"))
		return FALSE
	if(istype(ammo, /obj/item/stack))
		var/obj/item/stack/stack = ammo
		ammo = stack.split(1)
		if(QDELETED(ammo))
			return FALSE
		ammo.forceMove(src)
	else if(user && !user.try_unequip(ammo, src))
		return FALSE
	_loaded = ammo
	if(user)
		show_load_message(user)
	update_icon()
	return TRUE

/obj/item/gun/launcher/bow/update_release_force()
	release_force = tension * release_speed

/obj/item/gun/launcher/bow/consume_next_projectile(atom/movable/firer)
	if(tension <= 0 && isliving(firer))
		to_chat(firer, SPAN_WARNING("\The [src] is not ready to fire!"))
		return null
	return get_loaded_arrow(firer)

/obj/item/gun/launcher/bow/handle_post_fire(atom/movable/firer, atom/target)
	_loaded = null
	tension = 0
	. = ..()
	update_icon()
