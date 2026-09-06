/obj/item/lock_construct
	name = "lock"
	desc = "A simple tumbler lock and bolt, suitable for affixing to a door or closet."
	icon = 'icons/obj/items/doorlock.dmi'
	icon_state = "lock_construct"
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/metal/steel
	var/lock_data

/obj/item/lock_construct/Initialize()
	. = ..()
	lock_data = generateRandomString(round(material.integrity/50))

/obj/item/lock_construct/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(user && distance <= 1)
		if(lock_data)
			. += SPAN_NOTICE("\The [src] is unlocked with '[lock_data]'.")
		else
			. += SPAN_NOTICE("\The [src] is blank. Use a key on the lock to pair the two items.")

/obj/item/lock_construct/attackby(var/obj/item/used_item, var/mob/user)
	if(istype(used_item, /obj/item/key))
		var/obj/item/key/K = used_item
		if(!K.key_data)
			to_chat(user, SPAN_NOTICE("You fashion \the [used_item] to unlock \the [src]."))
			K.key_data = lock_data
		else
			to_chat(user, SPAN_WARNING("\The [used_item] already unlocks something..."))
		return TRUE
	if(istype(used_item,/obj/item/lock_construct))
		var/obj/item/lock_construct/L = used_item
		src.lock_data = L.lock_data
		to_chat(user, SPAN_NOTICE("You copy the lock from \the [L] to \the [src], making them identical."))
		return TRUE
	return ..()

/obj/item/lock_construct/proc/create_lock(var/atom/target, var/mob/user)
	. = new /datum/lock(target, lock_data, material?.type)
	user.visible_message(SPAN_NOTICE("\The [user] attaches \the [src] to \the [target]."))
	qdel(src)