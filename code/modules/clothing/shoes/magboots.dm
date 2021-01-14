//Note that despite the use of the NOSLIP flag, magboots are still hardcoded to prevent spaceslipping in Check_Shoegrip().
/obj/item/clothing/shoes/magboots
	name = "magboots"
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle. They're large enough to be worn over other footwear."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/feet/magboots.dmi'
	bodytype_restricted = null
	force = 3
	overshoes = 1
	action_button_name = "Toggle Magboots"
	center_of_mass = null
	randpixel = 0
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = "{'materials':2,'engineering':2,'magnets':3}"
	var/magpulse = 0
	var/obj/item/clothing/shoes/shoes = null	//Undershoes
	var/mob/living/carbon/human/wearer = null	//For shoe procs
	var/online_slowdown = 3

/obj/item/clothing/shoes/magboots/proc/set_slowdown()
	LAZYSET(slowdown_per_slot, slot_shoes_str, (shoes? max(0, LAZYACCESS(shoes.slowdown_per_slot, slot_shoes_str)) : 0))	//So you can't put on magboots to make you walk faster.
	if(magpulse)
		if(slot_shoes_str in slowdown_per_slot)
			slowdown_per_slot[slot_shoes_str] += online_slowdown
		else
			LAZYSET(slowdown_per_slot, slot_shoes_str, online_slowdown)

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		item_flags &= ~ITEM_FLAG_NOSLIP
		magpulse = 0
		set_slowdown()
		force = 3
		to_chat(user, "You disable the mag-pulse traction system.")
	else
		item_flags |= ITEM_FLAG_NOSLIP
		magpulse = 1
		set_slowdown()
		force = 5
		playsound(get_turf(src), 'sound/effects/magnetclamp.ogg', 20)
		to_chat(user, "You enable the mag-pulse traction system.")
	update_icon()
	user.update_action_buttons()
	user.update_floating()

/obj/item/clothing/shoes/magboots/on_update_icon()
	. = ..()
	var/new_state = get_world_inventory_state()
	if(magpulse)
		new_state = "[new_state]-on"
	if(check_state_in_icon(new_state, icon))
		icon_state = new_state
	update_clothing_icon()
	
/obj/item/clothing/shoes/magboots/experimental_mob_overlay(var/mob/user_mob, var/slot)
	var/image/ret = ..()
	var/new_state = ret.icon_state
	if(magpulse)
		new_state = "[new_state]-on"
	if(check_state_in_icon(new_state, ret.icon))
		ret.icon_state = new_state
	return ret

/obj/item/clothing/shoes/magboots/mob_can_equip(mob/user)
	var/mob/living/carbon/human/H = user

	if(H.shoes)
		shoes = H.shoes
		if(shoes.overshoes)
			to_chat(user, "You are unable to wear \the [src] as \the [H.shoes] are in the way.")
			shoes = null
			return 0
		if(!H.unEquip(shoes, src))//Remove the old shoes so you can put on the magboots.
			shoes = null
			return 0

	if(!..())
		if(shoes) 	//Put the old shoes back on if the check fails.
			if(H.equip_to_slot_if_possible(shoes, slot_shoes_str))
				src.shoes = null
		return 0

	if (shoes)
		to_chat(user, "You slip \the [src] on over \the [shoes].")
	set_slowdown()
	wearer = H //TODO clean this up
	return 1

/obj/item/clothing/shoes/magboots/equipped()
	..()
	var/mob/M = src.loc
	if(istype(M))
		M.update_floating()

/obj/item/clothing/shoes/magboots/dropped()
	..()
	if(!wearer)
		return

	var/mob/living/carbon/human/H = wearer
	if(shoes && istype(H))
		if(!H.equip_to_slot_if_possible(shoes, slot_shoes_str))
			shoes.dropInto(loc)
		src.shoes = null
	wearer.update_floating()
	wearer = null

/obj/item/clothing/shoes/magboots/examine(mob/user)
	. = ..()
	var/state = "disabled"
	if(item_flags & ITEM_FLAG_NOSLIP)
		state = "enabled"
	to_chat(user, "Its mag-pulse traction system appears to be [state].")
