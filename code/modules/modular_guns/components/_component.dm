/obj/item/firearm_component
	var/bulk =             0
	var/one_hand_penalty = 0
	var/screen_shake =     0
	var/space_recoil =     0
	var/combustion =       0
	var/accuracy =         0 // accuracy is measured in tiles. +1 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -1 means the opposite. launchers are not supported, at the moment.
	var/accuracy_power =   0 // increase of to-hit chance per 1 point of accuracy
	var/obj/item/gun/holder
	var/firearm_component_category = FIREARM_CATEGORY_NONE

/obj/item/firearm_component/Initialize(ml, material_key)
	. = ..()
	update_icon()
	if(istype(loc, /obj/item/gun))
		installed(loc, FALSE)

/obj/item/firearm_component/Destroy()
	if(holder)
		uninstalled()
	. = ..()

/obj/item/firearm_component/proc/installed(var/obj/item/gun/_holder, var/update_holder = TRUE)
	if(holder == _holder || !istype(_holder))
		return
	if(!isnull(holder))
		uninstalled()
	holder = _holder
	var/obj/item/firearm_component/replacing
	switch(firearm_component_category)
		if(FIREARM_COMPONENT_BARREL)
			replacing = holder.barrel
			holder.barrel = src
		if(FIREARM_COMPONENT_RECEIVER)
			replacing = holder.receiver
			holder.receiver = src
		if(FIREARM_COMPONENT_GRIP)
			replacing = holder.grip
			holder.grip = src
		if(FIREARM_COMPONENT_STOCK)
			replacing = holder.stock
			holder.stock = src
	if(istype(replacing))
		replacing.uninstalled()
		replacing.dropInto(holder.loc)

	queue_icon_update()
	if(update_holder)
		holder.update_from_components()

/obj/item/firearm_component/proc/uninstalled()
	var/obj/item/gun/last_holder = holder
	holder = null
	queue_icon_update()
	if(istype(last_holder))
		switch(firearm_component_category)
			if(FIREARM_COMPONENT_BARREL)
				if(last_holder.barrel == src)
					last_holder.barrel = null
			if(FIREARM_COMPONENT_RECEIVER)
				if(last_holder.receiver == src)
					last_holder.receiver = null
			if(FIREARM_COMPONENT_GRIP)
				if(last_holder.grip == src)
					last_holder.grip = null
			if(FIREARM_COMPONENT_STOCK)
				if(last_holder.stock == src)
					last_holder.stock = null
		last_holder.update_from_components()

/obj/item/firearm_component/proc/show_examine_info(var/mob/user)
	return

/obj/item/firearm_component/on_update_icon()
	icon = holder?.icon || initial(icon)
	icon_state = "[get_world_inventory_state()]-[firearm_component_category || FIREARM_CATEGORY_NONE]"
	if(holder)
		holder.queue_icon_update()

/obj/item/firearm_component/proc/get_holder_overlay(var/holder_state = ICON_STATE_WORLD)
	return image(icon, "[holder_state]-[firearm_component_category || FIREARM_CATEGORY_NONE]")

/obj/item/firearm_component/proc/holder_attack_self(var/mob/user)
	return

/obj/item/firearm_component/proc/holder_attackby(var/obj/item/W, var/mob/user)
	return

/obj/item/firearm_component/proc/holder_attack_hand(var/mob/user)
	return

/obj/item/firearm_component/proc/holder_emag_act(var/charges, var/mob/user)
	return NO_EMAG_ACT

/obj/item/firearm_component/proc/get_projectile_type()
	return

/obj/item/firearm_component/proc/apply_additional_firearm_tweaks(var/obj/item/gun/firearm)
	return