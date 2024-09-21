//#TODO: card reader should have its own includable tmpl, and override ui_data so machines don't have to reimplemnt the id card stuff a million time.
/**
 * Stock part for accessing/holding the subtypes of /obj/item/card.
 */
/obj/item/stock_parts/item_holder/card_reader
	name       = "RFID card reader"
	desc       = "A RFID card reader for various authentication or data sharing usages."
	icon       = 'icons/obj/items/stock_parts/modular_components.dmi'
	icon_state = "cardreader"
	material   = /decl/material/solid/organic/plastic
	matter     = list(
		/decl/material/solid/metal/steel  = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_TRACE,
		/decl/material/solid/fiberglass   = MATTER_AMOUNT_TRACE,
	)
	max_health = ITEM_HEALTH_NO_DAMAGE
	var/should_swipe = FALSE            //Whether the card should only be swiped instead of being inserted
	var/obj/item/card/inserted_card     //Card currently in the slot

/obj/item/stock_parts/item_holder/card_reader/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	max_health = 56

/obj/item/stock_parts/item_holder/card_reader/Destroy()
	QDEL_NULL(inserted_card)
	. = ..()

/obj/item/stock_parts/item_holder/card_reader/is_item_inserted()
	return !isnull(inserted_card)

/obj/item/stock_parts/item_holder/card_reader/is_accepted_type(obj/O)
	return istype(O, /obj/item/card)

/obj/item/stock_parts/item_holder/card_reader/get_inserted()
	return inserted_card

/obj/item/stock_parts/item_holder/card_reader/set_inserted(obj/O)
	inserted_card = O

/obj/item/stock_parts/item_holder/card_reader/get_description_insertable()
	return "card"

/obj/item/stock_parts/item_holder/card_reader/insert_item(obj/item/card/O, mob/user)
	if(should_swipe && is_accepted_type(O))
		return swipe_card(O, user)
	. = ..()

/obj/item/stock_parts/item_holder/card_reader/attackby(obj/item/W, mob/user)
	if(IS_SCREWDRIVER(W) && !istype(loc, /obj/machinery)) //Only if not in the machine, to prevent hijacking tool interactions with the machine
		should_swipe = !should_swipe
		to_chat(user, SPAN_NOTICE("You toggle \the [src] into [should_swipe? "swipe" : "insert"] card mode."))
		return TRUE
	. = ..()

/obj/item/stock_parts/item_holder/card_reader/proc/swipe_card(var/obj/item/card/C, var/mob/user)
	if(user)
		to_chat(user, SPAN_NOTICE("You swipe \the [C] in \the [src]."))
	if(on_insert_target)
		on_insert_target.InvokeAsync(C, user)
	return TRUE

/obj/item/stock_parts/item_holder/card_reader/proc/get_id_card()
	return istype(inserted_card, /obj/item/card/id) ? inserted_card : null

/obj/item/stock_parts/item_holder/card_reader/proc/get_data_card()
	return istype(inserted_card, /obj/item/card/data) ? inserted_card : null

/obj/item/stock_parts/item_holder/card_reader/proc/get_emag_card()
	return istype(inserted_card, /obj/item/card/emag) ? inserted_card : null
