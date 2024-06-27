/datum/trader
	abstract_type = /datum/trader
	var/name = "unsuspicious trader"         // The name of the trader in question
	var/origin = "some place"                // The place that they are trading from
	var/list/possible_origins                // Possible names of the trader origin
	var/disposition = 0                      // The current disposition of them to us.
	var/trade_flags = TRADER_MONEY           // Various flags for allowing or denying offers/interactions.
	var/name_language                        // Language decl to use for trader name. If null, will use the generic name generator.
	var/icon/portrait                        // The icon that shows up in the menu TODO: IMPLEMENT OR REMOVE
	var/trader_currency                      // Currency decl to use. If blank, defaults to map.
	var/datum/trade_hub/hub                  // Current associated trade hub, if any.

	var/list/wanted_items = list()           // What items they enjoy trading for. Structure is (type = known/unknown)
	var/list/possible_wanted_items           // List of all possible wanted items. Structure is (type = mode)
	var/list/possible_trading_items          // List of all possible trading items. Structure is (type = mode)
	var/list/trading_items = list()          // What items they are currently trading away.

	// The list of all their replies and messages.
	// Structure is (id = talk). Check __trading_defines.dm for specific tokens.
	var/list/speech = list()

	var/want_multiplier = 2                  // How much wanted items are multiplied by when traded for
	var/margin = 1.2                         // Multiplier to price when selling to player
	var/price_rng = 10                       // Percentage max variance in sell prices.
	var/insult_drop = 5                      // How far disposition drops on insult
	var/compliment_increase = 5              // How far compliments increase disposition
	var/refuse_comms = 0                     // Whether they refuse further communication

	// What message gets sent to mobs that get sold.
	var/mob_transfer_message = "You are transported to " + TRADER_TOKEN_ORIGIN + "."

	// Things they will automatically refuse
	var/list/blacklisted_trade_items = list(
		/mob/living/human
	)

/datum/trader/New()
	..()
	if(!ispath(trader_currency, /decl/currency))
		trader_currency = global.using_map.default_currency
	if(ispath(name_language, /decl/language))
		var/decl/language/L = GET_DECL(name_language)
		if(istype(L))
			name = L.get_random_name(pick(MALE,FEMALE))
	if(!name)
		name = capitalize(pick(global.using_map.first_names_female + global.using_map.first_names_male)) + " " + capitalize(pick(global.using_map.last_names))

	if(length(possible_origins))
		origin = pick(possible_origins)

	for(var/i in 3 to 6)
		add_to_pool(trading_items, possible_trading_items, force = 1)
		add_to_pool(wanted_items, possible_wanted_items, force = 1)

//If this hits 0 then they decide to up and leave.
/datum/trader/proc/tick()
	add_to_pool(trading_items, possible_trading_items, 200)
	add_to_pool(wanted_items, possible_wanted_items, 50)
	remove_from_pool(possible_trading_items, 9) //We want the stock to change every so often, so we make it so that they have roughly 10~11 ish items max
	return 1

/datum/trader/proc/remove_from_pool(var/list/pool, var/chance_per_item)
	if(pool && prob(chance_per_item * pool.len))
		var/i = rand(1,pool.len)
		pool[pool[i]] = null
		pool -= pool[i]

/datum/trader/proc/add_to_pool(var/list/pool, var/list/possible, var/base_chance = 100, var/force = 0)
	var/divisor = 1
	if(pool && pool.len)
		divisor = pool.len
	if(force || prob(base_chance/divisor))
		var/new_item = get_possible_item(possible)
		if(new_item)
			pool |= new_item

// This is horrendous. TODO: cache all of this shit.
// May be possible to mutate trading_pool as this is passed in from the lists defined on the datum.
/datum/trader/proc/get_possible_item(var/list/trading_pool)
	if(!length(trading_pool))
		return
	var/list/possible = list()
	for(var/trade_type in trading_pool)
		var/status = trading_pool[trade_type]
		if(status & TRADER_THIS_TYPE)
			possible += trade_type
		if(status & TRADER_SUBTYPES_ONLY)
			possible += subtypesof(trade_type)
		if(status & TRADER_BLACKLIST)
			possible -= trade_type
		if(status & TRADER_BLACKLIST_SUB)
			possible -= subtypesof(trade_type)
	for(var/trade_type in possible)
		var/atom/check_type = trade_type
		if(!TYPE_IS_SPAWNABLE(check_type))
			possible -= check_type
	if(length(possible))
		return pick(possible)

/datum/trader/proc/get_response(var/key, var/default)
	if(speech && speech[key])
		. = speech[key]
	else
		. = default
	. = replacetext(., TRADER_TOKEN_MERCHANT, name)
	. = replacetext(., TRADER_TOKEN_ORIGIN, origin)

	var/decl/currency/cur = GET_DECL(trader_currency)
	. = replacetext(.,TRADER_TOKEN_CUR_SINGLE, cur.name_singular)
	. = replacetext(.,TRADER_TOKEN_CURRENCY, cur.name)

/datum/trader/proc/print_trading_items(var/num)
	num = clamp(num,1,trading_items.len)
	var/item_type = trading_items[num]
	if(!item_type)
		return
	. = atom_info_repository.get_name_for(item_type)
	if(ispath(item_type, /obj/item/stack))
		var/obj/item/stack/stack = item_type
		. = "[initial(stack.amount)]x [.]"
	. = "<b>[.]</b>"

/datum/trader/proc/skill_curve(skill)
	switch(skill)
		if(SKILL_EXPERT)
			. = 1
		if(SKILL_EXPERT to SKILL_MAX)
			. = 1 + (SKILL_EXPERT - skill) * 0.2
		else
			. = 1 + (SKILL_EXPERT - skill) ** 2
	//This condition ensures that the buy price is higher than the sell price on generic goods, i.e. the merchant can't be exploited
	. = max(., price_rng/((margin - 1)*(200 - price_rng)))

/datum/trader/proc/get_item_value(var/trading_num, skill = SKILL_MAX)
	if(!trading_items[trading_items[trading_num]])
		var/item_type = trading_items[trading_num]
		var/value = atom_info_repository.get_combined_worth_for(item_type)
		value = round(rand(100 - price_rng,100 + price_rng)/100 * value) //For some reason rand doesn't like decimals.
		trading_items[item_type] = value
	. = trading_items[trading_items[trading_num]]
	. *= 1 + (margin - 1) * skill_curve(skill) //Trader will overcharge at lower skill.
	. = max(1, round(.))

/datum/trader/proc/get_buy_price(var/atom/movable/item, is_wanted, skill = SKILL_MAX)
	if(ispath(item, /atom/movable))
		. = atom_info_repository.get_combined_worth_for(item)
	else if(istype(item))
		. = item.get_combined_monetary_worth()
	if(is_wanted)
		. *= want_multiplier
	. *= max(1 - (margin - 1) * skill_curve(skill), 0.1) //Trader will underpay at lower skill.
	. = max(1, round(.))

/datum/trader/proc/offer_money_for_trade(var/trade_num, var/money_amount, skill = SKILL_MAX)
	if(!(trade_flags & TRADER_MONEY))
		return TRADER_NO_MONEY
	var/value = get_item_value(trade_num, skill)
	if(money_amount < value)
		return TRADER_NOT_ENOUGH
	return value

/datum/trader/proc/offer_items_for_trade(var/list/offers, var/num, var/turf/location, skill = SKILL_MAX)
	if(!offers || !offers.len)
		return TRADER_NOT_ENOUGH
	num = clamp(num, 1, trading_items.len)
	var/offer_worth = 0
	for(var/item in offers)
		var/atom/movable/offer = item
		var/is_wanted = 0
		if((trade_flags & TRADER_WANTED_ONLY) && is_type_in_list(offer, wanted_items))
			is_wanted = 2
		if((trade_flags & TRADER_WANTED_ALL) && is_type_in_list(offer, possible_wanted_items))
			is_wanted = 1
		if(length(blacklisted_trade_items) && is_type_in_list(offer, blacklisted_trade_items))
			return TRADER_NO_BLACKLISTED

		if(istype(offer,/obj/item/cash))
			if(!(trade_flags & TRADER_MONEY))
				return TRADER_NO_MONEY
		else
			if(!(trade_flags & TRADER_GOODS))
				return TRADER_NO_GOODS
			else if((trade_flags & (TRADER_WANTED_ONLY|TRADER_WANTED_ALL)) && !is_wanted)
				return TRADER_FOUND_UNWANTED

		offer_worth += get_buy_price(offer, is_wanted - 1, skill)
	if(!offer_worth)
		return TRADER_NOT_ENOUGH
	var/trading_worth = get_item_value(num, skill)
	if(!trading_worth)
		return TRADER_NOT_ENOUGH
	var/percent = offer_worth/trading_worth
	if(percent > max(0.9,0.9-disposition/100))
		return trade(offers, num, location)
	return TRADER_NOT_ENOUGH

/datum/trader/proc/hail(var/mob/user)
	var/specific
	if(ishuman(user))
		var/mob/living/human/H = user
		if(H.species)
			specific = H.species.name
	else if(issilicon(user))
		specific = TRADER_HAIL_SILICON_END
	if(!speech["[TRADER_HAIL_START][specific]"])
		specific = TRADER_HAIL_GENERIC_END
	. = get_response("[TRADER_HAIL_START][specific]", "Greetings, " + TRADER_TOKEN_MOB + "!")
	. = replacetext(., TRADER_TOKEN_MOB, user.name)

/datum/trader/proc/can_hail()
	if(!refuse_comms && prob(-disposition))
		refuse_comms = 1
	return !refuse_comms

/datum/trader/proc/insult()
	disposition -= rand(insult_drop, insult_drop * 2)
	if(prob(-disposition/10))
		refuse_comms = 1
	if(disposition > 50)
		return get_response(TRADER_INSULT_GOOD,"What? I thought we were cool!")
	else
		return get_response(TRADER_INSULT_BAD, "Right back at you asshole!")

/datum/trader/proc/compliment()
	if(prob(-disposition))
		return get_response(TRADER_COMPLIMENT_DENY, "Fuck you!")
	if(prob(100-disposition))
		disposition += rand(compliment_increase, compliment_increase * 2)
	return get_response(TRADER_COMPLIMENT_ACCEPT, "Thank you!")

/datum/trader/proc/trade(var/list/offers, var/num, var/turf/location)
	if(offers && offers.len)
		for(var/offer in offers)
			if(ismob(offer))
				var/text = mob_transfer_message
				to_chat(offer, replacetext(text, TRADER_TOKEN_ORIGIN, origin))
			qdel(offer)

	var/type = trading_items[num]

	var/atom/movable/M = new type(location)
	playsound(location, 'sound/effects/teleport.ogg', 50, 1)

	disposition += rand(compliment_increase,compliment_increase*3) //Traders like it when you trade with them

	return M

/datum/trader/proc/how_much_do_you_want(var/num, skill = SKILL_MAX)
	. = get_response(TRADER_HOW_MUCH, "Hmm.... how about " + TRADER_TOKEN_VALUE + " " + TRADER_TOKEN_CURRENCY + "?")
	. = replacetext(.,TRADER_TOKEN_VALUE,get_item_value(num, skill))
	. = replacetext(.,TRADER_TOKEN_ITEM, atom_info_repository.get_name_for(trading_items[num]))

/datum/trader/proc/what_do_you_want()
	if(!(trade_flags & TRADER_GOODS))
		return get_response(TRADER_NO_GOODS, "I don't deal in goods.")
	. = get_response(TRADER_WHAT_WANT, "Hm, I want")
	var/list/want_english = list()
	for(var/wtype in wanted_items)
		var/item_name = atom_info_repository.get_name_for(wtype)
		want_english += item_name
	. += " [english_list(want_english)]"

/datum/trader/proc/sell_items(var/list/offers, skill = SKILL_MAX)
	if(!(trade_flags & TRADER_GOODS))
		return TRADER_NO_GOODS
	if(!offers || !offers.len)
		return TRADER_NOT_ENOUGH

	var/wanted
	. = 0
	for(var/offer in offers)
		if((trade_flags & TRADER_WANTED_ONLY) && is_type_in_list(offer,wanted_items))
			wanted = 1
		else if((trade_flags & TRADER_WANTED_ALL) && is_type_in_list(offer,possible_wanted_items))
			wanted = 0
		else
			return TRADER_FOUND_UNWANTED
		. += get_buy_price(offer, wanted, skill)

	playsound(get_turf(offers[1]), 'sound/effects/teleport.ogg', 50, 1)
	for(var/offer in offers)
		qdel(offer)


/datum/trader/proc/is_bribable()
	SHOULD_CALL_PARENT(TRUE)
	return (trade_flags & TRADER_BRIBABLE)

/datum/trader/proc/is_bribed(var/staylength)
	return get_response(TRADER_BRIBE_REFUSAL, "How about... no?")

/datum/trader/proc/bribe_to_stay_longer(var/amt)
	if(is_bribable())
		return is_bribed(round(amt/100))
	return get_response(TRADER_BRIBE_REFUSAL, "How about... no?")

/datum/trader/Destroy(force)
	if(hub)
		hub.traders -= src
	. = ..()
