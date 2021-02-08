/obj/item/firearm_component/receiver
	name = "receiver"
	desc = "A complicated bit of machinery used to feed ammunition into the barrel of a firearm."
	icon_state = "world-receiver"
	firearm_component_category = FIREARM_COMPONENT_RECEIVER

/obj/item/firearm_component/receiver/holder_attackby(obj/item/W, mob/user)
	return load_ammo(user, W) || ..()

/obj/item/firearm_component/receiver/holder_attack_hand(mob/user)
	return unload_ammo(user) || ..()

/obj/item/firearm_component/receiver/proc/get_relative_projectile_size(var/obj/item/projectile/projectile)
	return 1

/obj/item/firearm_component/receiver/proc/get_caliber()
	return

/obj/item/firearm_component/receiver/proc/set_caliber(var/_caliber)
	return

/obj/item/firearm_component/receiver/proc/get_next_projectile()
	return

/obj/item/firearm_component/receiver/proc/can_accept_ammo(var/obj/item/ammo)
	return FALSE

/obj/item/firearm_component/receiver/proc/process_point_blank(obj/projectile, mob/user, atom/target)
	return

/obj/item/firearm_component/receiver/proc/handle_post_holder_fire()
	return

/obj/item/firearm_component/receiver/proc/process_chambered()
	return

/obj/item/firearm_component/receiver/proc/special_check(var/mob/user)
	return TRUE

/obj/item/firearm_component/receiver/proc/handle_click_empty()
	var/obj/item/gun/holder = loc
	if(istype(holder) && holder.check_fire_message_spam("click"))
		visible_message("*click click*", "<span class='danger'>*click*</span>")
	playsound(get_turf(src), 'sound/weapons/empty.ogg', 100, 1)

/obj/item/firearm_component/receiver/proc/load_ammo(var/mob/user, var/obj/item/loading)
	return

/obj/item/firearm_component/receiver/proc/unload_ammo(var/mob/user)
	return
