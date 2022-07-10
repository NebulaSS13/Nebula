/obj/item/stock_parts/card_reader
	name       = "RFID card reader"
	desc       = "A RFID card reader for various authentication or data sharing usages."
	icon       = 'icons/obj/items/stock_parts/modular_components.dmi'
	icon_state = "cardreader"
	material   = /decl/material/solid/plastic
	matter     = list(
		/decl/material/solid/metal/steel  = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_TRACE,
		/decl/material/solid/fiberglass   = MATTER_AMOUNT_TRACE,
	)
	max_health = 56
	var/should_swipe = FALSE            //Whether the card should only be swiped instead of being inserted
	var/obj/item/card/inserted_card     //Card currently in the slot
	var/datum/callback/on_insert_target //Callback to call when a card is inserted or swiped
	var/datum/callback/on_eject_target  //Callback to call when the card is ejected

/obj/item/stock_parts/card_reader/buildable
	part_flags = PART_FLAG_HAND_REMOVE

/obj/item/stock_parts/card_reader/Destroy()
	QDEL_NULL(inserted_card)
	unregister_on_insert()
	unregister_on_eject()
	. = ..()

/obj/item/stock_parts/card_reader/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card))
		if(should_swipe)
			swipe_card(W, user)
		else
			insert_card(W, user)
		return TRUE
	if(IS_SCREWDRIVER(W) && !istype(loc, /obj/machinery)) //Only if not in the machine, to prevent hijacking tool interactions with the machine
		should_swipe = !should_swipe
		to_chat(user, SPAN_NOTICE("You toggle \the [src] into [should_swipe? "swipe" : "insert"] card mode"))
		return TRUE
	. = ..()

/obj/item/stock_parts/card_reader/attack_hand(mob/user)
	if(inserted_card && istype(loc, /obj/machinery))
		eject_card(user)
		return TRUE
	. = ..()

/obj/item/stock_parts/card_reader/attack_self(mob/user)
	if(inserted_card)
		eject_card(user)
		return TRUE
	. = ..()

/obj/item/stock_parts/card_reader/on_install(obj/machinery/machine)
	unregister_on_insert()
	unregister_on_eject()
	. = ..()

/obj/item/stock_parts/card_reader/on_uninstall(obj/machinery/machine, temporary)
	unregister_on_insert()
	unregister_on_eject()
	. = ..()

/obj/item/stock_parts/card_reader/proc/get_card()
	return inserted_card

/obj/item/stock_parts/card_reader/proc/get_id_card()
	return istype(inserted_card, /obj/item/card/id) ? inserted_card : null

/obj/item/stock_parts/card_reader/proc/get_data_card()
	return istype(inserted_card, /obj/item/card/data) ? inserted_card : null

/obj/item/stock_parts/card_reader/proc/get_emag_card()
	return istype(inserted_card, /obj/item/card/emag) ? inserted_card : null

/obj/item/stock_parts/card_reader/proc/swipe_card(var/obj/item/card/C, var/mob/user)
	if(user)
		to_chat(user, SPAN_NOTICE("You swipe \the [C] in \the [src]."))
	if(on_insert_target)
		on_insert_target.InvokeAsync(C, user)
	return TRUE

/obj/item/stock_parts/card_reader/proc/insert_card(var/obj/item/card/C, var/mob/user)
	if(inserted_card)
		if(user)
			to_chat(user, SPAN_WARNING("There is already a card in \the [src]!"))
		return

	if(user)
		to_chat(user, SPAN_NOTICE("You insert \the [C] into \the [src]."))
		user.unEquip(C, src)
	else
		C.forceMove(src)
	inserted_card = C
	if(on_insert_target)
		on_insert_target.InvokeAsync(inserted_card, user)
	return TRUE

/obj/item/stock_parts/card_reader/proc/eject_card(var/mob/user)
	if(!inserted_card)
		return
	if(user)
		to_chat(user, SPAN_NOTICE("You remove \the [inserted_card] from \the [src]."))
		user.put_in_hands(inserted_card)
	else
		inserted_card.dropInto(get_turf(loc))
	if(on_eject_target)
		on_eject_target.InvokeAsync(inserted_card, user)
	inserted_card = null
	return TRUE

/obj/item/stock_parts/card_reader/proc/register_on_insert(var/datum/callback/cback)
	on_insert_target = cback

/obj/item/stock_parts/card_reader/proc/register_on_eject(var/datum/callback/cback)
	on_eject_target = cback

/obj/item/stock_parts/card_reader/proc/unregister_on_insert()
	QDEL_NULL(on_insert_target)

/obj/item/stock_parts/card_reader/proc/unregister_on_eject()
	QDEL_NULL(on_eject_target)