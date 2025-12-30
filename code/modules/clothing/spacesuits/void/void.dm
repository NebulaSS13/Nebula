//NASA Voidsuit
/obj/item/clothing/head/helmet/space/void
	name = "void helmet"
	desc = "A high-tech dark red space suit helmet. Used for AI satellite maintenance."
	icon = 'icons/clothing/spacesuit/void/nasa/helmet.dmi'
	bodytype_equip_flags = BODY_EQUIP_FLAG_HUMANOID
	heat_protection = SLOT_HEAD
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = VOIDSUIT_MAX_PRESSURE
	min_pressure_protection = 0
	siemens_coefficient = 0.4

/obj/item/clothing/suit/space/void
	name = "voidsuit"
	icon = 'icons/clothing/spacesuit/void/nasa/suit.dmi'
	bodytype_equip_flags = BODY_EQUIP_FLAG_HUMANOID
	w_class = ITEM_SIZE_HUGE//bulky item
	desc = "A high-tech dark red space suit. Used for AI satellite maintenance."
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit)
	heat_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS|SLOT_TAIL
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = VOIDSUIT_MAX_PRESSURE
	siemens_coefficient = 0.4

	//Breach thresholds, should ideally be inherited by most (if not all) voidsuits.
	//With 0.2 resiliance, will reach 10 breach damage after 3 laser carbine blasts or 8 smg hits.
	breach_threshold = 15
	can_breach = 1

	_base_attack_force = 5

	//Inbuilt devices.
	var/obj/item/clothing/shoes/magboots/boots = null // Deployable boots, if any.
	var/obj/item/clothing/head/helmet/helmet = null   // Deployable helmet, if any.
	var/obj/item/tank/tank = null              // Deployable tank, if any.

	action_button_name = "Toggle Helmet"
	var/helmet_deploy_sound = 'sound/items/helmet_close.ogg'
	var/helmet_retract_sound = 'sound/items/helmet_open.ogg'

/obj/item/clothing/suit/space/void/get_stored_inventory()
	. = ..()
	if(length(.))
		for(var/obj/thing in list(boots, helmet, tank))
			. -= thing

#define VOIDSUIT_INIT_EQUIPMENT(equipment_var, expected_path) \
if(ispath(##equipment_var, ##expected_path )){\
	##equipment_var = new equipment_var (src);\
}\
else if(##equipment_var) {\
	CRASH("[log_info_line(src)] has an invalid [#equipment_var] type: [log_info_line(##equipment_var)]");\
}

/obj/item/clothing/suit/space/void/Initialize()
	. = ..()
	VOIDSUIT_INIT_EQUIPMENT(boots,  /obj/item/clothing/shoes/magboots)
	VOIDSUIT_INIT_EQUIPMENT(helmet, /obj/item/clothing/head/helmet)
	VOIDSUIT_INIT_EQUIPMENT(tank,   /obj/item/tank)

#undef VOIDSUIT_INIT_EQUIPMENT

/obj/item/clothing/suit/space/void/Destroy()
	. = ..()
	QDEL_NULL(boots)
	QDEL_NULL(helmet)
	QDEL_NULL(tank)

/obj/item/clothing/suit/space/void/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/list/part_list = list()
	for(var/obj/item/I in list(helmet,boots,tank))
		part_list += "\a [I]"
	. += "\The [src] has [english_list(part_list)] installed."
	if(tank && distance <= 1)
		. += SPAN_NOTICE("The wrist-mounted pressure gauge reads [max(round(tank.air_contents.return_pressure()),0)] kPa remaining in \the [tank].")

/obj/item/clothing/suit/space/void/refit_for_bodytype(target_bodytype, skip_rename = FALSE)
	..()
	if(istype(helmet))
		helmet.refit_for_bodytype(target_bodytype, skip_rename)
	if(istype(boots))
		boots.refit_for_bodytype(target_bodytype, skip_rename)

/obj/item/clothing/suit/space/void/equipped(mob/M)
	..()

	var/mob/living/human/H = M

	if(!istype(H)) return

	if(H.get_equipped_item(slot_wear_suit_str) != src)
		return

	if(boots)
		if (H.equip_to_slot_if_possible(boots, slot_shoes_str))
			boots.canremove = 0

	if(helmet)
		var/obj/item/head = H.get_equipped_item(slot_head_str)
		if(head)
			to_chat(M, "You are unable to deploy your suit's helmet as \the [head] is in the way.")
		else if (H.equip_to_slot_if_possible(helmet, slot_head_str))
			to_chat(M, "Your suit's helmet deploys with a hiss.")
			playsound(loc, helmet_deploy_sound, 30)
			helmet.canremove = 0

	if(tank)
		if(H.get_equipped_item(slot_s_store_str)) //In case someone finds a way.
			to_chat(M, "Alarmingly, the valve on your suit's installed tank fails to engage.")
		else if (H.equip_to_slot_if_possible(tank, slot_s_store_str))
			to_chat(M, "The valve on your suit's installed tank safely engages.")
			tank.canremove = 0


/obj/item/clothing/suit/space/void/dropped()
	..()

	var/mob/living/human/H

	if(helmet)
		helmet.canremove = 1
		H = helmet.loc
		if(istype(H))
			if(helmet && H.get_equipped_item(slot_head_str) == helmet)
				H.drop_from_inventory(helmet, src)

	if(boots)
		boots.canremove = 1
		H = boots.loc
		if(istype(H))
			if(boots && H.get_equipped_item(slot_shoes_str) == boots)
				H.drop_from_inventory(boots, src)

	if(tank)
		tank.canremove = 1
		tank.forceMove(src)

/obj/item/clothing/suit/space/void/verb/toggle_helmet()

	set name = "Toggle Helmet"
	set category = "Object"
	set src in usr

	if(!isliving(src.loc)) return

	if(!helmet)
		to_chat(usr, "There is no helmet installed.")
		return

	var/mob/living/human/H = usr

	if(!istype(H)) return
	if(H.incapacitated()) return
	if(H.get_equipped_item(slot_wear_suit_str) != src) return

	var/obj/item/head = H.get_equipped_item(slot_head_str)
	if(head == helmet)
		to_chat(H, "<span class='notice'>You retract your suit helmet.</span>")
		helmet.canremove = 1
		playsound(loc, helmet_retract_sound, 30)
		H.drop_from_inventory(helmet, src)
	else
		if(head)
			to_chat(H, "<span class='danger'>You cannot deploy your helmet while wearing \the [head].</span>")
			return
		if(H.equip_to_slot_if_possible(helmet, slot_head_str))
			helmet.on_picked_up(H, src)
			helmet.canremove = 0
			playsound(loc, helmet_deploy_sound, 30)
			to_chat(H, "<span class='info'>You deploy your suit helmet, sealing you off from the world.</span>")
	helmet.update_light(H)

/obj/item/clothing/suit/space/void/verb/eject_tank()

	set name = "Eject Voidsuit Tank"
	set category = "Object"
	set src in usr

	if(!isliving(src.loc)) return

	if(!tank)
		to_chat(usr, "There is no tank inserted.")
		return

	var/mob/living/human/H = usr

	if(!istype(H)) return
	if(H.incapacitated()) return
	var/slot = H.get_equipped_slot_for_item(src)
	if(slot != slot_wear_suit_str && !(slot in H.get_held_item_slots()))
		return// let them eject those tanks when they're in hand or stuff for ease of use

	to_chat(H, "<span class='info'>You press the emergency release, ejecting \the [tank] from your suit.</span>")
	tank.canremove = 1
	H.drop_from_inventory(tank, src)
	H.put_in_hands(tank)
	src.tank = null
	playsound(loc, 'sound/effects/spray3.ogg', 50)

/obj/item/clothing/suit/space/void/attackby(obj/item/used_item, mob/user)

	if(IS_SCREWDRIVER(used_item))
		if(user.get_equipped_slot_for_item(src) == slot_wear_suit_str)//maybe I should make this into a proc?
			to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
		else if(helmet || boots || tank)
			var/choice = input("What component would you like to remove?") as null|anything in list(helmet,boots,tank)
			if(choice)
				playsound(loc, 'sound/items/Screwdriver.ogg', 50)
				if(choice == tank)	//No, a switch doesn't work here. Sorry. ~Techhead
					to_chat(user, "You pop \the [tank] out of \the [src]'s storage compartment.")
					user.put_in_hands(tank)
					src.tank = null
				else if(choice == helmet)
					to_chat(user, "You detach \the [helmet] from \the [src]'s helmet mount.")
					user.put_in_hands(helmet)
					src.helmet = null
				else if(choice == boots)
					to_chat(user, "You detach \the [boots] from \the [src]'s boot mounts.")
					user.put_in_hands(boots)
					src.boots = null
		else
			to_chat(user, "\The [src] does not have anything installed.")
		return TRUE

	if(istype(used_item,/obj/item/clothing/head/helmet/space))
		if(user.get_equipped_slot_for_item(src) == slot_wear_suit_str)
			to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
		else if(helmet)
			to_chat(user, "\The [src] already has a helmet installed.")
		else if(user.try_unequip(used_item, src))
			to_chat(user, "You attach \the [used_item] to \the [src]'s helmet mount.")
			src.helmet = used_item
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		return TRUE

	if(istype(used_item,/obj/item/clothing/shoes/magboots))
		if(user.get_equipped_slot_for_item(src) == slot_wear_suit_str)
			to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
		else if(boots)
			to_chat(user, "\The [src] already has magboots installed.")
		else if(user.try_unequip(used_item, src))
			to_chat(user, "You attach \the [used_item] to \the [src]'s boot mounts.")
			boots = used_item
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		return TRUE

	if(istype(used_item,/obj/item/tank))
		if(user.get_equipped_slot_for_item(src) == slot_wear_suit_str)
			to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
		else if(tank)
			to_chat(user, "\The [src] already has an airtank installed.")
		else if(user.try_unequip(used_item, src))
			to_chat(user, "You insert \the [used_item] into \the [src]'s storage compartment.")
			tank = used_item
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		return TRUE

	return ..()

/obj/item/clothing/suit/space/void/attack_self() //sole purpose of existence is to toggle the helmet
	toggle_helmet()
	return TRUE

/obj/item/clothing/suit/space/void/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	overlay = ..() // Apply tank last so it doesn't get offset twice.
	if(overlay && tank && slot == slot_back_str)
		overlay.overlays += tank.get_mob_overlay(user_mob, slot_back_str)
	return overlay