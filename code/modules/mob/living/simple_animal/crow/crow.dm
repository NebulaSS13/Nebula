/obj/item/storage/backpack/messenger/corvid_couriers
	name = "corvid messenger bag"
	desc = "A small green-grey messenger bag with a blue Corvid Couriers logo on it."
	icon = 'icons/obj/items/storage/backpack/corvid.dmi'
	icon_state = ICON_STATE_WORLD
	storage_slots = 7
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/cloth

/mob/living/simple_animal/crow
	name = "crow"
	desc = "A large crow. Caw caw."
	icon = 'icons/mob/simple_animal/crow.dmi'
	pass_flags = PASS_FLAG_TABLE
	mob_size = MOB_SIZE_SMALL

	speak = list("Caw.", "Caw?", "Caw!", "CAW.")
	speak_emote = list("caws")
	emote_hear = list("caws")
	emote_see = list("hops")

	natural_weapon = /obj/item/natural_weapon/crow_claws

	stop_automated_movement = TRUE
	universal_speak = TRUE
	pass_flags = PASS_FLAG_TABLE


/mob/living/simple_animal/crow/get_overlay_state_modifier()
	return (stat == DEAD) ? "-dead" : null

/decl/bodytype/animal/crow
	name = "crow"
	bodytype_category = "crow body"

/mob/living/simple_animal/crow/get_bodytype()
	return GET_DECL(/decl/bodytype/animal/crow)

/obj/item/natural_weapon/crow_claws
	name = "claws"
	gender = PLURAL
	attack_verb = list("clawed")
	sharp = TRUE
	force = 7

/mob/living/simple_animal/crow/Initialize()
	. = ..()
	add_inventory_slot(new /datum/inventory_slot/back/simple)
	add_inventory_slot(new /datum/inventory_slot/id)
	add_held_item_slot(new /datum/inventory_slot/gripper/mouth/simple)
	equip_to_slot_or_del(new /obj/item/storage/backpack/messenger/corvid_couriers(src), slot_back_str)
	update_icon()

/mob/living/simple_animal/crow/get_dexterity(var/silent)
	return (DEXTERITY_EQUIP_ITEM|DEXTERITY_HOLD_ITEM)

/mob/living/simple_animal/crow/DefaultTopicState()
	return global.physical_topic_state

// Let people interact with the Bird Storage.
/mob/living/simple_animal/crow/attack_hand(mob/user)
	if(user.a_intent == I_HELP)
		var/obj/item/backpack = get_equipped_item(slot_back_str)
		if(backpack)
			return backpack.attack_hand(user)
	return ..()

/mob/living/simple_animal/crow/attackby(obj/item/I, mob/user)
	if(user.a_intent == I_HELP)
		var/obj/item/backpack = get_equipped_item(slot_back_str)
		if(backpack)
			return backpack.attackby(I, user)
	return ..()

/mob/living/simple_animal/crow/on_update_icon()
	..()
	var/obj/item/backpack = get_equipped_item(slot_back_str)
	if(backpack)
		var/overlay_state = "crow-[icon_state]-bag"
		if(check_state_in_icon(overlay_state, backpack.icon))
			add_overlay(image(backpack.icon, overlay_state))

/mob/living/simple_animal/crow/cyber
	name = "cybercrow"
	desc = "A large cybercrow. k4w k4w."
	speak_emote = list("beeps")

/mob/living/simple_animal/crow/cyber/on_update_icon()
	..()
	add_overlay("[icon_state]-cyber")

