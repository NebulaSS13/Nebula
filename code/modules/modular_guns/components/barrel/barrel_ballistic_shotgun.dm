/obj/item/firearm_component/barrel/ballistic/shotgun
	caliber = CALIBER_SHOTGUN
	one_hand_penalty = 4
	bulk = 6

/obj/item/firearm_component/barrel/ballistic/shotgun/double
	w_class = ITEM_SIZE_HUGE
	force = 10
	one_hand_penalty = 8

/obj/item/firearm_component/barrel/ballistic/shotgun/double/on_update_icon()
	. = ..()
	if(w_class < ITEM_SIZE_HUGE)
		icon_state = "[icon_state]-sawn"

/obj/item/firearm_component/barrel/ballistic/shotgun/double/get_holder_overlay(var/holder_state = ICON_STATE_WORLD)
	var/image/ret = ..()
	if(ret && w_class < ITEM_SIZE_HUGE)
		ret.icon_state = "[ret.icon_state]-sawn"
	return ret

/obj/item/firearm_component/barrel/ballistic/shotgun/double/sawn
	w_class = ITEM_SIZE_NORMAL
	force = 5
	bulk = 2
	one_hand_penalty = 2

/obj/item/firearm_component/barrel/ballistic/shotgun/double/holder_attackby(obj/item/W, mob/user)
	if(w_class >= ITEM_SIZE_HUGE)
		if(istype(W, /obj/item/gun/plasmacutter))
			var/obj/item/gun/plasmacutter/cutter = W
			if(cutter.slice(user))
				return shorten(W, user)
		if(istype(W, /obj/item/circular_saw) || istype(W, /obj/item/energy_blade))
			return shorten(W, user)
	. = ..()

/obj/item/firearm_component/barrel/ballistic/shotgun/double/proc/shorten(var/obj/item/cutting, var/mob/user)
	to_chat(user, SPAN_NOTICE("You begin to shorten \the [holder || src]."))
	if(istype(holder?.receiver, /obj/item/firearm_component/receiver/ballistic))
		var/obj/item/firearm_component/receiver/ballistic/proj_receiver = holder.receiver
		if(length(proj_receiver.loaded))
			for(var/i in 1 to proj_receiver.max_shells)
				holder.Fire(user, user)
			user.visible_message(SPAN_DANGER("\The [holder] goes off!"))
	if(do_after(user, 30, holder || src) && w_class > ITEM_SIZE_NORMAL)
		w_class = ITEM_SIZE_NORMAL
		bulk = 2
		one_hand_penalty = 2
		force = 5
		to_chat(user, SPAN_NOTICE("You shorten \the [holder || src]!"))
		update_icon()
		holder?.update_from_components()
		return TRUE
	return FALSE
