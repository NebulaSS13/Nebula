/obj/item/storage/messenger
	name = "messenger bag"
	desc = "A small green-grey messenger bag with a blue Corvid Couriers logo on it."
	icon = 'icons/obj/items/messenger_bag.dmi'
	icon_state = ICON_STATE_WORLD
	storage_slots = 7
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BACK
	material = /decl/material/solid/cloth

/obj/item/storage/messenger/mob_can_equip(mob/M, slot, disable_warning, force)
	return istype(M, /mob/living/simple_animal/crow) && ..()

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

	var/static/list/slots_to_names = list(
		slot_wear_id_str = "cuff",
		slot_back_str =    "back"
	)

/obj/item/natural_weapon/crow_claws
	name = "claws"
	gender = PLURAL
	attack_verb = list("clawed")
	sharp = TRUE
	force = 7

/mob/living/simple_animal/crow/can_equip_anything_to_slot(slot)
	return slot && slots_to_names[slot]

/mob/living/simple_animal/crow/get_inventory_slots()
	for(var/slot in slots_to_names)
		LAZYADD(., slot)

/mob/living/simple_animal/crow/Initialize()
	. = ..()
	equip_to_slot_or_del(new /obj/item/storage/messenger(src), slot_back_str)
	update_icon()

/mob/living/simple_animal/crow/GetIdCards()
	. = ..()
	var/obj/item/card/id/access_card = get_equipped_item(slot_wear_id_str)
	if(istype(access_card))
		LAZYDISTINCTADD(., access_card)

/mob/living/simple_animal/crow/DefaultTopicState()
	return global.physical_topic_state

/mob/living/simple_animal/crow/on_update_icon()
	..()
	if(get_equipped_item(slot_back_str))
		add_overlay("[icon_state]-bag")

/mob/living/simple_animal/crow/cyber
	name = "cybercrow"
	desc = "A large cybercrow. k4w k4w."
	speak_emote = list("beeps")

/mob/living/simple_animal/crow/cyber/on_update_icon()
	..()
	add_overlay("[icon_state]-cyber")

