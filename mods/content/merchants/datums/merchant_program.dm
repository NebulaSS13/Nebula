// Computer program used to interact with merchant NPCs. Acts as the 'front end' for the merchant system.
/datum/computer_file/program/merchant
	filename = "mlist"
	filedesc = "Merchant's List"
	extended_desc = "Allows communication and trade between vessels and trade hubs."
	program_icon_state = "comm"
	program_menu_icon = "cart"
	nanomodule_path = /datum/nano_module/program/merchant
	size = 12
	usage_flags = PROGRAM_CONSOLE
	read_access = list(access_merchant)
	VAR_PRIVATE/weakref/_hub_ref = null			//! A weakref to the currently connected trade hub, if any.
	VAR_PRIVATE/weakref/_merchant_ref = null	//! A weakref to the merchant that is currently being interacted with, if any.
	VAR_PRIVATE/weakref/_pad_ref = null			//! A weakref to the merchant pad next to the console, if any.
	var/show_items_for_sale = FALSE
	var/hailed_merchant = FALSE
	var/last_comms = null			//! Holds a string containing the most recent 'message' sent to the player from the merchant.
	var/prompt_message = null		//! If not null, the UI window will show the message inside this var, until the player clicks the 'Continue' button.
	var/list/stored_cash = list()	//! Holds cash used to trade with merchants, in the format of `/decl/currency/foo = 5000`.
	var/static/list/bribe_amounts = list(100, 500, 1000)

/datum/computer_file/program/merchant/New()
	. = ..()
	events_repository.register_global(/decl/observ/merchant_arrived, src, PROC_REF(on_merchant_arrival))
	events_repository.register_global(/decl/observ/merchant_departed, src, PROC_REF(on_merchant_departure))

/datum/computer_file/program/merchant/Destroy()
	_hub_ref = null
	_merchant_ref = null
	_pad_ref = null
	events_repository.unregister_global(/decl/observ/merchant_arrived, src, PROC_REF(on_merchant_arrival))
	events_repository.unregister_global(/decl/observ/merchant_departed, src, PROC_REF(on_merchant_departure))
	return ..()

/datum/computer_file/program/merchant/proc/on_merchant_arrival(datum/merchant/arrival, datum/trade_hub/hub)
	if(!(src in computer?.running_programs))
		return

	if(!hub.is_accessible_from(holder?.resolve()))
		return

	var/atom/movable/thing = computer.holder
	if(!istype(thing))
		return

	playsound(thing, 'sound/machines/sensors/newcontact.ogg', 50, TRUE)
	var/line = "\The [thing] states, \"New signal detected: [arrival.origin], at [hub.name].\""
	thing.visible_message(SPAN_NOTICE(line), blind_message = SPAN_NOTICE("You hear some excited beeping."), range = 3)

/datum/computer_file/program/merchant/proc/on_merchant_departure(datum/merchant/departure, datum/trade_hub/hub)
	if(!(src in computer?.running_programs))
		return

	if(!hub.is_accessible_from(holder?.resolve()))
		return

	var/atom/movable/thing = computer.holder
	if(!istype(thing))
		return

	playsound(thing, 'sound/machines/sensors/contact_lost.ogg', 50, TRUE)
	var/line = "\The [thing] states, \"The signal for [departure.origin], at [hub.name], was lost.\""
	thing.visible_message(SPAN_NOTICE(line), blind_message = SPAN_WARNING("You hear some concerned beeping."), range = 3)

/// Checks whether the inputted trade hub is valid to trade with.
/datum/computer_file/program/merchant/proc/check_hub(datum/trade_hub/supplied_hub)
	var/obj/item/stock_parts/computer/hard_drive/hard_drive = holder?.resolve()
	if(!istype(supplied_hub) || QDELETED(supplied_hub) || !hard_drive || !supplied_hub.is_accessible_from(get_turf(hard_drive)))
		return FALSE
	return TRUE

/datum/computer_file/program/merchant/proc/set_current_hub(datum/trade_hub/supplied_hub)
	if(check_hub(supplied_hub))
		_hub_ref = weakref(supplied_hub)
		return TRUE
	return FALSE

/datum/computer_file/program/merchant/proc/get_current_hub()
	var/datum/trade_hub/actual_hub = _hub_ref?.resolve()
	if(check_hub(actual_hub))
		return actual_hub
	_hub_ref = null
	return null

/datum/computer_file/program/merchant/proc/check_merchant(datum/merchant/supplied_merchant)
	var/datum/trade_hub/actual_hub = get_current_hub()
	if(QDELETED(actual_hub) || QDELETED(supplied_merchant) || (supplied_merchant && !(supplied_merchant in actual_hub.merchants)))
		return FALSE
	return TRUE

/datum/computer_file/program/merchant/proc/get_current_merchant()
	var/datum/merchant/actual_merchant = _merchant_ref?.resolve()
	if(check_merchant(actual_merchant))
		return actual_merchant
	_merchant_ref = null
	return null

/datum/computer_file/program/merchant/proc/get_available_hubs()
	. = list()
	var/turf/T = get_turf(holder.resolve())
	for(var/datum/trade_hub/hub in SStrade.trade_hubs)
		if(hub.is_accessible_from(T))
			. |= hub

/datum/computer_file/program/merchant/proc/connect_pad()
	for(var/obj/machinery/merchant_pad/P in orange(1, get_turf(holder?.resolve())))
		_pad_ref = weakref(P)
		return TRUE
	prompt_message = "No merchant pads within range were found."
	return FALSE

/datum/computer_file/program/merchant/proc/get_pad()
	return _pad_ref?.resolve()

/// Connects to the targeted hub.
/datum/computer_file/program/merchant/proc/connect_to_hub(datum/trade_hub/target_hub)
	if(!check_hub(target_hub))
		return FALSE
	_merchant_ref = null
	_hub_ref = weakref(target_hub)
	if(length(target_hub.merchants))
		_merchant_ref = weakref(target_hub.merchants[1])
		last_comms = null
		hailed_merchant = FALSE
		return TRUE
	else
		prompt_message = "There are no available merchants at the target hub, or the target hub has moved out of range."
		return FALSE

/datum/computer_file/program/merchant/proc/set_last_comms(mob/user, datum/merchant/merchant, response_text)
	// I hate this.
	response_text = replacetext(response_text, /decl/merchant_speech::MERCHANT_TOKEN_MERCHANT_NAME,	merchant.name)
	response_text = replacetext(response_text, /decl/merchant_speech::MERCHANT_TOKEN_CURRENCY, merchant.currency_used.name)
	response_text = replacetext(response_text, /decl/merchant_speech::MERCHANT_TOKEN_CURRENCY_SINGULAR, merchant.currency_used.name_singular)
	response_text = replacetext(response_text, /decl/merchant_speech::MERCHANT_TOKEN_ORIGIN, merchant.origin)
	response_text = replacetext(response_text, /decl/merchant_speech::MERCHANT_TOKEN_PLAYER_NAME, user.name)

	var/decl/pronouns/pronouns = user.get_pronouns() || GET_DECL(/decl/pronouns)
	response_text = replacetext(response_text, /decl/merchant_speech::MERCHANT_TOKEN_PLAYER_HONORIFIC, pronouns.honorific)

	last_comms = response_text
	playsound(holder?.resolve(), 'sound/machines/sensors/contactgeneric.ogg', 50, TRUE)


/// Attempts to hail the target merchant.
/datum/computer_file/program/merchant/proc/hail_merchant(mob/user, datum/merchant/target_merchant)
	var/success = target_merchant.hail(user)
	set_last_comms(user, target_merchant, select_hail_response(user, target_merchant))
	playsound(holder?.resolve(), 'sound/effects/ping.ogg', 50, TRUE)
	if(success)
		hailed_merchant = TRUE
		show_items_for_sale = FALSE
	return success

/datum/computer_file/program/merchant/proc/select_hail_response(mob/user, datum/merchant/target_merchant)
	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)

	if(!target_merchant.can_hail(user))
		if(target_merchant.denying_anonymous_comms(user) && speech.no_anonymous)
			return speech.no_anonymous
		return speech.denied_hail

	if(length(speech.hailed_by_species))
		var/decl/species/species = user.get_species(user)
		if(species)
			var/response = speech.hailed_by_species[species.uid]
			if(response)
				return response

	if(user.isSynthetic() && speech.hailed_by_synth)
		return speech.hailed_by_synth
	return speech.hailed


#define SCROLL_RIGHT 1
/// Called when the user clicks one of the two arrows in the UI to 'scroll' to different available merchants.
/datum/computer_file/program/merchant/proc/scroll_merchant_selection(scroll_direction)
	var/datum/trade_hub/hub = get_current_hub()
	var/datum/merchant/current_merchant = get_current_merchant()
	if(!istype(hub) || !istype(current_merchant))
		return
	var/datum/merchant/new_merchant = scroll_direction == SCROLL_RIGHT ? next_in_list(current_merchant, hub.merchants) : previous_in_list(current_merchant, hub.merchants)
	if(new_merchant != current_merchant)
		hailed_merchant = FALSE
		last_comms = null
		_merchant_ref = weakref(new_merchant)
#undef SCROLL_RIGHT


/// Called when the user clicks the compliment button in the UI.
/datum/computer_file/program/merchant/proc/compliment_merchant(mob/user, datum/merchant/target_merchant)
	if(!target_merchant.can_be_understood(user))
		handle_no_common_language(user, target_merchant)
		return FALSE

	var/success = target_merchant.compliment(user)
	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	if(success)
		set_last_comms(user, target_merchant, speech.compliment_success)
		return TRUE
	set_last_comms(user, target_merchant, speech.compliment_failure)
	return FALSE


/// Called when the user clicks the insult button in the UI, or rarely if they don't speak any of the merchant's languages.
/datum/computer_file/program/merchant/proc/insult_merchant(mob/user, datum/merchant/target_merchant)
	target_merchant.insult(user)
	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	if(target_merchant.get_disposition(user) >= target_merchant.HIGH_DISPOSITION_THRESHOLD)
		set_last_comms(user, target_merchant, speech.insult_high_opinion)
	else
		set_last_comms(user, target_merchant, speech.insult_low_opinion)


/// Returns TRUE if the merchant is fed up and cuts the connection.
/datum/computer_file/program/merchant/proc/check_merchant_disconnection(mob/user, datum/merchant/target_merchant)
	if(hailed_merchant && !target_merchant.can_hail(user))
		var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
		hailed_merchant = FALSE
		set_last_comms(user, target_merchant, speech.denied_hail)
		return TRUE
	return FALSE


/// Called when the merchant receives a question from the user, when the user doesn't speak any of their languages.
/datum/computer_file/program/merchant/proc/handle_no_common_language(mob/user, datum/merchant/target_merchant)
	if(prob(20))
		insult_merchant(user, target_merchant)
		return
	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	set_last_comms(user, target_merchant, speech.no_common_language)


/// Called when the user clicks one of the bribe buttons in the UI.
/datum/computer_file/program/merchant/proc/bribe_merchant(mob/user, datum/merchant/target_merchant, index)
	var/amount = bribe_amounts[index]
	if(amount > get_cash(target_merchant.currency_used))
		prompt_message = "There was not enough [target_merchant.currency_used.name] to perform that action."
		return FALSE

	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	var/success = target_merchant.bribe(amount, user)
	if(success)
		var/response = replacetext(speech.bribe_success, /decl/merchant_speech::MERCHANT_TOKEN_TIME, target_merchant.is_temporary_merchant ? target_merchant.duration_of_stay : "a lot")
		set_last_comms(user, target_merchant, response)
		adjust_cash(target_merchant.currency_used, -amount)
		return TRUE

	set_last_comms(user, target_merchant, speech.bribe_failure)
	return FALSE


/// Called when the user clicks on the button to ask for an item's price on the UI.
/datum/computer_file/program/merchant/proc/ask_price(mob/user, datum/merchant/target_merchant, index)
	if(!target_merchant.can_be_understood(user))
		handle_no_common_language(user, target_merchant)
		return FALSE

	var/datum/merchant_commodity/commodity = target_merchant.active_supply[index]
	var/item_type = commodity.spawn_path

	var/price = target_merchant.get_item_value(item_type, target_merchant.TRANSACTION_SELLING, user) // TODO: Maybe optimize this by passing in the commodity datum to avoid extra work later for getting price variance?

	if(LAZYLEN(target_merchant.supply_tax_modifiers))
		price = target_merchant.get_taxes(price, target_merchant.TRANSACTION_SELLING, user)

	var/item_name = atom_info_repository.get_name_for(item_type)
	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	var/response = speech.how_much
	response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_VALUE, price)
	response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_CURRENCY, price > 1 ? target_merchant.currency_used.name : target_merchant.currency_used.name_singular)
	response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_CURRENCY_SINGULAR, target_merchant.currency_used.name_singular)
	response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_ITEM, item_name)

	set_last_comms(user, target_merchant, response)
	return TRUE


/// Attempts to purchase a specific item from the merchant, using money.
/datum/computer_file/program/merchant/proc/attempt_purchase(mob/user, datum/merchant/target_merchant, index, offered_price)
	var/obj/machinery/merchant_pad/actual_pad = get_pad()
	if(!actual_pad)
		prompt_message = "No merchant pad detected."
		return FALSE // No pad found.

	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	if(!target_merchant.accepts_money_as_payment)
		set_last_comms(user, target_merchant, speech.money_not_accepted)
		return FALSE // They don't want money.

	var/datum/merchant_commodity/commodity = target_merchant.active_supply[index]
	var/item_type = commodity.spawn_path

	if(!commodity.check_requirements(item_type))
		var/response = replacetext(speech.refused_purchase, /decl/merchant_speech::MERCHANT_TOKEN_ITEM, atom_info_repository.get_name_for(item_type))
		set_last_comms(user, target_merchant, response)
		return FALSE // Failed a requirement.

	if(commodity.quantity <= 0)
		var/response = replacetext(speech.sold_out, /decl/merchant_speech::MERCHANT_TOKEN_ITEM, atom_info_repository.get_name_for(item_type))
		set_last_comms(user, target_merchant, response)
		return FALSE // Out of stock.

	var/merchant_price = target_merchant.get_item_value(item_type, target_merchant.TRANSACTION_SELLING, user)
	if(!offered_price)
		offered_price = merchant_price

	var/with_tax = offered_price
	if(LAZYLEN(target_merchant.supply_tax_modifiers))
		with_tax = target_merchant.get_taxes(offered_price, target_merchant.TRANSACTION_SELLING, user)

	if(get_cash(target_merchant.currency_used) < with_tax)
		set_last_comms(user, target_merchant, speech.not_enough_value)
		return FALSE // Not enough money.

	if(!target_merchant.evaluate_offer(list(item_type), offered_price, target_merchant.TRANSACTION_SELLING, user))
		var/response = speech.haggle_too_low
		response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_VALUE, offered_price)
		response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_ITEM, atom_info_repository.get_name_for(item_type))
		set_last_comms(user, target_merchant, response)
		return FALSE // The merchant said no.

	adjust_cash(target_merchant.currency_used, -with_tax)
	target_merchant.adjust_cash(offered_price)

	var/response = replacetext(speech.trade_complete, /decl/merchant_speech::MERCHANT_TOKEN_ORIGIN, target_merchant.origin)
	response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_ITEM, atom_info_repository.get_name_for(item_type))
	set_last_comms(user, target_merchant, response)

	var/turf/T = get_turf(actual_pad)
	var/atom/movable/item = new item_type(T)
	commodity.quantity -= 1
	target_merchant.on_completed_transaction(user, list(item), target_merchant.TRANSACTION_SELLING, merchant_price, offered_price, T)
	playsound(T, 'sound/effects/teleport.ogg', 50, TRUE)
	return TRUE

/// Attempts to buy a specific item from the merchant, at a price defined by the user, using money.
/datum/computer_file/program/merchant/proc/haggle_buy(mob/user, datum/merchant/target_merchant, index)
	if(!target_merchant.can_be_understood(user))
		handle_no_common_language(user, target_merchant)
		return FALSE

	if(target_merchant.refuse_haggling)
		var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
		set_last_comms(user, target_merchant, speech.no_haggling)
		return FALSE

	var/player_offer = input(user, "Set how much you want to offer for that item. \
	Be aware that asking for less money may offend the merchant.", "Haggling") as null|num
	if(isnull(player_offer))
		return FALSE

	if(player_offer < 1)
		prompt_message = "Offer must be at least one unit of currency."
		return FALSE

	player_offer = floor(player_offer)

	return attempt_purchase(user, target_merchant, index, player_offer)


/// Asks the merchant to say how much they would pay for everything on the merchant pad, assuming they want it.
/datum/computer_file/program/merchant/proc/ask_appraisal(mob/user, datum/merchant/target_merchant)
	var/obj/machinery/merchant_pad/actual_pad = get_pad()
	if(!actual_pad)
		prompt_message = "No merchant pad detected."
		return FALSE

	if(!target_merchant.can_be_understood(user))
		handle_no_common_language(user, target_merchant)
		return FALSE

	var/list/items_on_pad = actual_pad.get_targets()
	if(!check_items_on_pad(items_on_pad, user, target_merchant))
		return FALSE

	var/value = target_merchant.get_value_of_items(items_on_pad, target_merchant.TRANSACTION_BUYING, user)
	if(!value)
		return FALSE

	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	var/response = replacetext(speech.appraise_offer, /decl/merchant_speech::MERCHANT_TOKEN_VALUE, value)
	response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_CURRENCY, value > 1 ? target_merchant.currency_used.name : target_merchant.currency_used.name_singular)
	set_last_comms(user, target_merchant, response)
	return TRUE


/// Attempts to trade for a specific item from the merchant, in exchange for all of the items on the pad.
/datum/computer_file/program/merchant/proc/attempt_barter(mob/user, datum/merchant/target_merchant, index)
	var/obj/machinery/merchant_pad/actual_pad = get_pad()
	if(!actual_pad)
		prompt_message = "No merchant pad detected."
		return FALSE // No pad found.

	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	if(!target_merchant.accepts_goods_as_payment)
		set_last_comms(user, target_merchant, speech.goods_not_accepted)
		return FALSE // They don't want barter.

	var/list/items_on_pad = actual_pad.get_targets()
	if(!check_items_on_pad(items_on_pad, user, target_merchant))
		return FALSE // They don't want what is being offered.


	var/datum/merchant_commodity/commodity = target_merchant.active_supply[index]
	var/item_type = commodity.spawn_path

	if(commodity.quantity <= 0)
		var/response = replacetext(speech.sold_out, /decl/merchant_speech::MERCHANT_TOKEN_ITEM, atom_info_repository.get_name_for(item_type))
		set_last_comms(user, target_merchant, response)
		return FALSE // Out of stock.

	var/merchant_price = target_merchant.get_item_value(item_type, target_merchant.TRANSACTION_SELLING, user)
	var/barter_value = target_merchant.get_value_of_items(items_on_pad, target_merchant.TRANSACTION_BUYING, user)

	// It seems weird to try to assess taxes when bartering, so we won't do that here. Plus, it gives a loophole that players can use.

	if(!target_merchant.evaluate_offer(list(item_type), barter_value, target_merchant.TRANSACTION_SELLING, user))
		set_last_comms(user, target_merchant, speech.not_enough_value)
		return FALSE // Merchant said no.

	for(var/atom/movable/thing in items_on_pad)
		var/datum/merchant_commodity/demand = target_merchant.find_demand_commodity(thing)
		if(demand && demand.quantity != INFINITY)
			demand.quantity -= demand.get_quantity_of_instance(thing)

	set_last_comms(user, target_merchant, speech.trade_complete)
	var/turf/T = get_turf(actual_pad)

	// Tell the merchant that the user sold everything on the pad for their worth.
	target_merchant.on_completed_transaction(user, items_on_pad, target_merchant.TRANSACTION_BUYING, barter_value, merchant_price, T) // TODO: Make this not be weird.
	delete_items_on_pad(user, target_merchant)

	var/atom/movable/item = new item_type(T)
	commodity.quantity -= 1

	// Now tell them that the user bought the item
	target_merchant.on_completed_transaction(user, list(item), target_merchant.TRANSACTION_SELLING, merchant_price, barter_value, T) // TODO: Make this not be weird.
	return TRUE


/// Attempts to sell everything on the merchant pad, in exchange for money.
/datum/computer_file/program/merchant/proc/attempt_sell(mob/user, datum/merchant/target_merchant, offered_price)
	var/obj/machinery/merchant_pad/actual_pad = get_pad()
	if(!actual_pad)
		prompt_message = "No merchant pad detected."
		return FALSE // No pad found.

	var/list/items_on_pad = actual_pad.get_targets()
	if(!check_items_on_pad(items_on_pad, user, target_merchant))
		return FALSE

	var/merchant_price = target_merchant.get_value_of_items(items_on_pad, target_merchant.TRANSACTION_BUYING, user)
	if(!offered_price)
		offered_price = merchant_price

	var/with_tax = offered_price
	if(LAZYLEN(target_merchant.demand_tax_modifiers))
		with_tax = target_merchant.get_taxes(offered_price, target_merchant.TRANSACTION_BUYING, user)

	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	if(!target_merchant.evaluate_offer(items_on_pad, offered_price, target_merchant.TRANSACTION_BUYING, user))
		var/response = speech.haggle_too_high
		response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_VALUE, offered_price)
		set_last_comms(user, target_merchant, response)
		return FALSE

	if(!target_merchant.will_pay_with_money || !target_merchant.has_cash(with_tax))
		set_last_comms(user, target_merchant, speech.out_of_money)
		return FALSE

	for(var/atom/movable/thing in items_on_pad)
		var/datum/merchant_commodity/demand = target_merchant.find_demand_commodity(thing)
		if(demand && demand.quantity != INFINITY)
			demand.quantity -= demand.get_quantity_of_instance(thing)

	set_last_comms(user, target_merchant, speech.trade_complete)
	target_merchant.on_completed_transaction(user, items_on_pad, target_merchant.TRANSACTION_BUYING, merchant_price, offered_price, get_turf(actual_pad))
	delete_items_on_pad(user, target_merchant)

	target_merchant.adjust_cash(-with_tax)
	adjust_cash(target_merchant.currency_used, offered_price)

	return TRUE

/// Attempts to sell everything on the merchant pad, at a price defined by the user, in exchange for money.
/datum/computer_file/program/merchant/proc/haggle_sell(mob/user, datum/merchant/target_merchant)
	if(!target_merchant.can_be_understood(user))
		handle_no_common_language(user, target_merchant)
		return FALSE

	if(target_merchant.refuse_haggling)
		var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
		set_last_comms(user, target_merchant, speech.no_haggling)
		return FALSE

	var/player_offer = input(user, "Set how much you want to charge for everything on the merchant pad. \
	Be aware that asking for more money may offend the merchant.", "Haggling") as null|num
	if(isnull(player_offer))
		return FALSE

	if(player_offer < 1)
		prompt_message = "Price must be at least one unit of currency."
		return FALSE

	player_offer = floor(player_offer)

	return attempt_sell(user, target_merchant, player_offer)

/// Attempts to give everything on the merchant pad away for free.
/datum/computer_file/program/merchant/proc/attempt_gift(mob/user, datum/merchant/target_merchant)
	var/obj/machinery/merchant_pad/actual_pad = get_pad()
	if(!actual_pad)
		prompt_message = "No merchant pad detected."
		return FALSE // No pad found.

	var/list/items_on_pad = actual_pad.get_targets()
	if(!check_items_on_pad(items_on_pad, user, target_merchant))
		return FALSE // They don't want junk, even for free.

	if(target_merchant.refuse_gifts)
		var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
		set_last_comms(user, target_merchant, speech.gift_refused)
		return FALSE // They don't accept gifts.

	var/item_value = target_merchant.get_value_of_items(items_on_pad, target_merchant.TRANSACTION_BUYING, user)

	for(var/atom/movable/thing in items_on_pad)
		var/datum/merchant_commodity/demand = target_merchant.find_demand_commodity(thing)
		if(demand && demand.quantity != INFINITY)
			demand.quantity -= demand.get_quantity_of_instance(thing)

	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	set_last_comms(user, target_merchant, speech.trade_complete)
	target_merchant.on_completed_transaction(user, items_on_pad, target_merchant.TRANSACTION_BUYING, 0, item_value, get_turf(actual_pad))
	delete_items_on_pad(user, target_merchant)


/// Deletes all valid objects on top of the merchant pad. Called when the user successfully sell to or barters with a merchant.
/datum/computer_file/program/merchant/proc/delete_items_on_pad(mob/user, datum/merchant/target_merchant)
	var/obj/machinery/merchant_pad/actual_pad = get_pad()
	if(!actual_pad)
		return

	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	for(var/thing in actual_pad.get_targets())
		. = TRUE
		var/list/mobs_sold = list()
		if(ismob(thing))
			mobs_sold += thing
		mobs_sold = recursive_content_check(thing, mobs_sold, client_check = FALSE, sight_check = FALSE, include_objects = FALSE)
		for(var/M in mobs_sold)
			var/mob/victim = M
			if(victim.ckey || victim.last_ckey)
				var/line = replacetext(speech.mob_transfer_message, /decl/merchant_speech::MERCHANT_TOKEN_ORIGIN, target_merchant.origin)
				to_chat(victim, SPAN_DANGER(line))
				log_and_message_admins("sold [user != victim ? key_name(victim) : "themself"] to a merchant, and was deleted.", user, get_turf(actual_pad))
		qdel(thing)
	if(.)
		playsound(get_turf(actual_pad), 'sound/effects/teleport.ogg', 50, TRUE)


/// Checks that everything on top of the pad are things the merchant won't object to receiving.
/datum/computer_file/program/merchant/proc/check_items_on_pad(list/items, mob/user, datum/merchant/target_merchant)
	if(!length(items))
		prompt_message = "No suitable items detected on pad."
		return FALSE // Nothing valid was on the pad.

	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	if(target_merchant.offer_contains_forbidden_items(items)) // This comes first so that merchants can freak out over players trying to sell scary things.
		set_last_comms(user, target_merchant, speech.forbidden_offer)
		return FALSE // Merchant doesn't want to buy forbidden things.

	if(!length(target_merchant.active_demand))
		set_last_comms(user, target_merchant, speech.goods_not_accepted)
		return FALSE // Merchant doesn't want to buy anything.

	if(!target_merchant.offer_contains_wanted_items(items))
		set_last_comms(user, target_merchant, speech.found_unwanted)
		return FALSE // Merchant doesn't want to buy junk.


	// Check if completing the trade would cause the merchant to accept more items then they actually want.
	var/list/limited_demands = list()
	for(var/item in items)
		var/datum/merchant_commodity/demand = target_merchant.find_demand_commodity(item)
		if(!demand)
			return FALSE // This shouldn't be possible but...

		if(demand.quantity == INFINITY)
			continue

		if(!(limited_demands[demand]))
			limited_demands[demand] = 0
		limited_demands[demand] += demand.get_quantity_of_instance(item)

	for(var/instance, count in limited_demands)
		var/datum/merchant_commodity/demand = instance
		if(demand.quantity <= 0)
			var/response = speech.no_more_wanted
			response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_ITEM, demand.name)
			set_last_comms(user, target_merchant, response)
			return FALSE // Merchant doesn't want anymore clams.

		if(count > demand.quantity)
			var/response = speech.too_many_items
			response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_ITEM, demand.name)
			response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_QUANTITY, demand.print_quantity())
			set_last_comms(user, target_merchant, response)
			return FALSE // Merchant doesn't want to buy a thousand clams, just a few.

	return TRUE


/// Asks the merchant what items they want to buy.
/datum/computer_file/program/merchant/proc/ask_what_they_want(mob/user, datum/merchant/target_merchant)
	if(!target_merchant.can_be_understood(user))
		handle_no_common_language(user, target_merchant)
		return FALSE

	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	if(!length(target_merchant.active_demand))
		set_last_comms(user, target_merchant, speech.goods_not_accepted)
		return FALSE // Doesn't want to buy anything.

	var/response = speech.what_wanted_beginning
	var/list/demand_names = list()
	for(var/datum/merchant_commodity/demand as anything in target_merchant.active_demand)
		if(demand.quantity <= 0)
			continue // So the merchant doesn't say they want 0 of something.
		demand_names += demand.print_offer()
	response += " [english_list(demand_names)][speech.what_wanted_ending || "."]"
	set_last_comms(user, target_merchant, response)
	return TRUE


/// Asks how long the merchant is gonna stick around for.
/datum/computer_file/program/merchant/proc/ask_duration_of_stay(mob/user, datum/merchant/target_merchant)
	if(!target_merchant.can_be_understood(user))
		handle_no_common_language(user, target_merchant)
		return FALSE

	var/decl/merchant_speech/speech = GET_DECL(target_merchant.speech)
	var/response = null
	if(target_merchant.is_temporary_merchant)
		response = speech.leaving_soon
	else
		response = speech.staying_put
	response = replacetext(response, /decl/merchant_speech::MERCHANT_TOKEN_TIME, target_merchant.duration_of_stay)
	set_last_comms(user, target_merchant, response)
	return TRUE


/// Returns how much of a specific currency the computer currently contains.
/datum/computer_file/program/merchant/proc/get_cash(decl/currency/currency_type)
	if(istype(currency_type))
		currency_type = currency_type.type
	if(currency_type in stored_cash)
		// Convert from value to currency.
		var/decl/currency/currency = GET_DECL(currency_type)
		return stored_cash[currency_type] / currency.absolute_value
	return 0


/// Changes how much of a specific currency the computer contains, removing it entirely if it runs out.
/datum/computer_file/program/merchant/proc/adjust_cash(decl/currency/currency_type, amount)
	if(istype(currency_type))
		currency_type = currency_type.type
	if(!(stored_cash[currency_type]))
		stored_cash[currency_type] = 0

	// Convert from curency to value.
	var/decl/currency/currency = GET_DECL(currency_type)
	amount *= currency.absolute_value

	stored_cash[currency_type] = max(stored_cash[currency_type] + amount, 0)
	if(stored_cash[currency_type] <= 0)
		stored_cash.Remove(currency_type)


/// Places cash objects that are on top of the pad into the `stored_cash` list.
/datum/computer_file/program/merchant/proc/deposit_cash()
	var/obj/machinery/merchant_pad/actual_pad = _pad_ref?.resolve()
	if(!actual_pad)
		prompt_message = "No merchant pad detected."
		return FALSE
	var/list/things = actual_pad.get_targets()
	. = FALSE
	for(var/thing in things)
		if(istype(thing, /obj/item/cash))
			var/obj/item/cash/money = thing
			if(!(stored_cash[money.currency]))
				stored_cash[money.currency] = 0
			stored_cash[money.currency] += money.absolute_worth
			qdel(money)
			. = TRUE
	if(.)
		prompt_message = "All cash detected on merchant pad deposited."
	else
		prompt_message = "No cash was detected on the merchant pad."


/// Removes the cash held inside of `stored_cash` back onto the pad.
/datum/computer_file/program/merchant/proc/withdraw_cash()
	var/obj/machinery/merchant_pad/actual_pad = get_pad()
	if(!actual_pad)
		prompt_message = "No merchant pad detected."
		return FALSE
	if(!length(stored_cash))
		prompt_message = "Cash storage is empty."
		return FALSE
	var/turf/T = get_turf(actual_pad)
	for(var/currency_type in stored_cash)
		var/obj/item/cash/dollarydoos = new(null)
		dollarydoos.adjust_worth(stored_cash[currency_type])
		dollarydoos.set_currency(currency_type)
		dollarydoos.forceMove(T)
	stored_cash.Cut()
	prompt_message = "All cash in storage withdrawn to pad."
	return TRUE


/datum/computer_file/program/merchant/proc/test_fire()
	var/obj/machinery/merchant_pad/actual_pad = _pad_ref?.resolve()
	if(istype(actual_pad) && actual_pad.get_target())
		return TRUE
	return FALSE


/datum/computer_file/program/merchant/proc/print_item_name(type_path)
	var/item_name = atom_info_repository.get_name_for(type_path)
	if(ispath(type_path, /obj/item/stack))
		var/obj/item/stack/stack = type_path
		item_name = "[initial(stack.amount)]x [item_name]"
	return item_name

/// Returns a string describing all of the price modifiers in the inputted list.
/// You probably don't want to show `[supply|demand]_price_modifiers` to players,
/// since it might be weird to be told that a merchant is charging XX% more because the player had low finance skill.
/datum/computer_file/program/merchant/proc/print_price_modifiers(list/price_modifiers, mob/user, always_display = FALSE)
	var/list/lines = list()
	for(var/key, value in price_modifiers) // Note that `value` refers to the key-value pair meaning of value and not the normal 'worth' meaning of value, in this instance.
		var/decl/merchant_price_modifier/modifier = GET_DECL(key)
		if(!modifier.should_be_displayed && !always_display)
			continue
		lines += "[modifier.name]: [modifier.print_amount(value, user, src)]"
	return lines.Join("<br>")


/datum/nano_module/program/merchant
	name = "Merchant's List"

/datum/nano_module/program/merchant/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE, datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()
	if(program)
		var/datum/computer_file/program/merchant/P = program
		var/datum/merchant/current_merchant = P.get_current_merchant()
		data["prompt_message"] = P.prompt_message
		data["pad_connected"] = !!P.get_pad()
		var/list/cash_data = list()
		for(var/currency_type in P.stored_cash)
			var/decl/currency/currency = GET_DECL(currency_type)
			var/amount = P.stored_cash[currency_type]
			cash_data += list(list(
				"name" = amount == 1 ? currency.name_singular : currency.name,
				"amount" = amount / currency.absolute_value
				))
		data["cash"] = cash_data
		var/list/hub_data = list()
		for(var/datum/trade_hub/hub in P.get_available_hubs())
			hub_data += list(list("name" = hub.name, "ref" = "\ref[hub]"))
		data["hubs"] = hub_data
		data["mode"] = !!current_merchant
		if(current_merchant)
			P.check_merchant_disconnection(user, current_merchant)
			var/merchant_is_understood = current_merchant.can_be_understood(user)
			data["merchant_hailed"] = P.hailed_merchant
			data["merchant_name"] = current_merchant.name
			data["merchant_origin"] = current_merchant.origin
			data["last_comms"] = P.last_comms
			data["merchant_is_understood"] = merchant_is_understood
			data["merchant_cash"] = current_merchant.current_cash
			data["merchant_currency"] = current_merchant.currency_used.name
			data["merchant_supply_price_modifiers"] = P.print_price_modifiers(current_merchant.supply_price_modifiers + current_merchant.supply_tax_modifiers, user)
			data["merchant_demand_price_modifiers"] = P.print_price_modifiers(current_merchant.demand_price_modifiers + current_merchant.demand_tax_modifiers, user)

			var/list/bribe_data = list()
			for(var/bribe_amount in P.bribe_amounts)
				bribe_data += current_merchant.currency_used.format_value(bribe_amount)
			data["bribe_amounts"] = bribe_data

			if(P.show_items_for_sale)
				var/list/item_data = list()
				if(length(current_merchant.active_supply))
					for(var/datum/merchant_commodity/commodity as anything in current_merchant.active_supply)
						var/displayed_name = commodity.name
						if(istype(commodity.spawn_path, /obj/item/stack))
							var/obj/item/stack/stack = commodity.spawn_path
							displayed_name = "[initial(stack.amount)]x [displayed_name]"


						var/displayed_quantity = null
						if(commodity.quantity <= 0)
							displayed_quantity = "SOLD OUT"
						else if(commodity.quantity != INFINITY)
							displayed_quantity = "[commodity.quantity] left"

						if(!merchant_is_understood)
							displayed_name = current_merchant.scramble_response(user, displayed_name)
							displayed_quantity = current_merchant.scramble_response(user, displayed_quantity)
						item_data += list(list("item_name" = displayed_name, "item_quantity" = displayed_quantity))
				data["item_data"] = item_data
			if(!merchant_is_understood)
				data["merchant_name"] = current_merchant.scramble_response(user, current_merchant.name)
				data["merchant_origin"] = current_merchant.scramble_response(user, current_merchant.origin)
				data["last_comms"] = current_merchant.scramble_response(user, P.last_comms)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "merchant_console.tmpl", "Merchant List", 575, 700, state = state)
		ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()


/datum/computer_file/program/merchant/Topic(href, href_list)
	if(..())
		return TRUE
	var/mob/user = usr
	var/datum/merchant/current_merchant = get_current_merchant()
	if(href_list["connect_pad"])
		. = TRUE
		connect_pad()
	if(href_list["deposit_cash"])
		. = TRUE
		deposit_cash()
	if(href_list["withdraw_cash"])
		. = TRUE
		withdraw_cash()
	if(href_list["main_menu"])
		. = TRUE
		_merchant_ref = null
		_hub_ref = null
	if(href_list["continue"])
		. = TRUE
		prompt_message = null
	if(href_list["connect_to_hub"])
		. = TRUE
		connect_to_hub(locate(href_list["connect_to_hub"]))
	if(href_list["telepad_test_fire"])
		. = TRUE
		if(test_fire())
			prompt_message = "Test fire successful."
		else
			prompt_message = "Test fire unsuccessful."
	if(current_merchant)
		if(href_list["hail"])
			. = TRUE
			hail_merchant(user, current_merchant)
		if(href_list["scroll"])
			. = TRUE
			scroll_merchant_selection(text2num(href_list["scroll"]))
		if(href_list["compliment"])
			. = TRUE
			compliment_merchant(user, current_merchant)
		if(href_list["insult"])
			. = TRUE
			insult_merchant(user, current_merchant)
		if(href_list["bribe"])
			. = TRUE
			bribe_merchant(user, current_merchant, text2num(href_list["bribe"]) + 1)
		if(href_list["what_do_you_want"])
			. = TRUE
			ask_what_they_want(user, current_merchant)
		if(href_list["how_long_will_you_stay"])
			. = TRUE
			ask_duration_of_stay(user, current_merchant)
		if(href_list["show_items_for_sale"])
			. = TRUE
			show_items_for_sale = !show_items_for_sale
		if(href_list["ask_price"])
			. = TRUE
			ask_price(user, current_merchant, text2num(href_list["ask_price"]) + 1)
		if(href_list["purchase"])
			. = TRUE
			attempt_purchase(user, current_merchant, text2num(href_list["purchase"]) + 1)
		if(href_list["barter"])
			. = TRUE
			attempt_barter(user, current_merchant, text2num(href_list["barter"]) + 1)
		if(href_list["gift"])
			. = TRUE
			attempt_gift(user, current_merchant)
		if(href_list["appraisal"])
			. = TRUE
			ask_appraisal(user, current_merchant)
		if(href_list["sell_items"])
			. = TRUE
			attempt_sell(user, current_merchant)
		if(href_list["haggle_sell"])
			. = TRUE
			haggle_sell(user, current_merchant)
		if(href_list["haggle_buy"])
			. = TRUE
			haggle_buy(user, current_merchant, text2num(href_list["haggle_buy"]) + 1)
