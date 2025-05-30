/// Represents an NPC which the crew (or others) can trade with.
/datum/merchant
	abstract_type = /datum/merchant

	// UI vars.
	var/name = null										//! The merchant's name, shown in the UI to players. If blank, a random name will be generated.
	var/origin = null									//! Where the merchant is trading from, or in other words, the store's name. Shown in the UI.
	var/list/possible_origins = null					//! If set, `origin` is replaced by one of these randomly at init.
	var/decl/background_detail/name_background = null	//! Background decl which will generate a random name for the merchant, overwriting it, if it is set.
	var/list/merchant_languages = list(/decl/language/human/common) /*! List of languages which the merchant communicates with. Players who do not possess at least one of these
																	cannot easily interact with the merchant, and the text will be scrambled in the UI. */
	var/decl/merchant_speech/speech = /decl/merchant_speech	//! Decl which contains dialogue shown to players interacting with this merchant.

	// Opinion vars.
	var/list/remembered_identities = list()		//! List of character names (on their IDs) the merchant remembers from prior interactions, along with their individual disposition values.
	var/positive_disposition_multiplier = 1.0	//! Multiplies how easy it is to raise disposition with this merchant.
	var/negative_disposition_multiplier = 1.0	//! Multiplies how easy it is to lower disposition with this merchant.
	var/times_complimented = 0					//! How many times this merchant received a compliment. Used to punish compliment spam.
	var/refuse_anonymous_comms = FALSE			//! If true, the merchant won't respond to hails if the user lacks an ID.
	var/comms_refusal_threshold = -HIGH_DISPOSITION_THRESHOLD //! Merchants will refuse to interact with anyone who has this amount of disposition, or lower.
	var/const/HIGH_DISPOSITION_THRESHOLD = 50	//! Disposition values at or above this value are considered to be 'high' for certain purposes.
	var/const/MAX_DISPOSITION_THRESHOLD = 100	//! Disposition values above this value cease to have any additional effect for certain purposes.

	// Supply (or, what merchants sell to players).
	var/accepts_money_as_payment = TRUE			//! Whether or not the merchant accepts money as payment.
	var/accepts_goods_as_payment = FALSE		//! Whether or not the merchant accepts items as payment. This must be TRUE for barter to be possible.
	var/list/supply_potential = null			//! List containing one or more `/decl/merchant_potential_commodities`, which are used to determine what the merchant could sell to players.
	var/list/active_supply = list()				//! List of commodities that are presently being offered for sale.
	var/list/inactive_supply = list()			//! List of commodities that didn't make the cut for `active_supply`.
	var/list/supply_price_modifiers = list(		//! Contains `/decl/merchant_price_modifier`s that determine how to scale the price of goods they sell to players.
		/decl/merchant_price_modifier/percentage = 1.2,
		/decl/merchant_price_modifier/disposition = 0.8,
		/decl/merchant_price_modifier/legacy_skill_disparity/supply = 1.2
	)
	var/list/supply_tax_modifiers = list( //! A list of `/decl/merchant_price_modifiers` which are added on top of the final price. The merchant doesn't receive any money from this portion.
//		/decl/merchant_price_modifier/percentage/tax = 1.1
	)

	var/decl/merchant_inventory_strategy/supply_strategy = /decl/merchant_inventory_strategy/legacy //! Determines how supply is initially stocked and how it rotates over time, if at all.

	// Demand (or, what merchants buy from players).
	var/will_pay_with_money = TRUE				//! If false, the merchant cannot give money for items, and players must barter to trade with them.
	var/list/demand_potential = null			//! List containing one or more `/decl/merchant_potential_commodities`, which are used to determine what the merchant wants to buy from players.
	var/list/active_demand = list()				//! List of commodities that the merchant wants to buy from players.
	var/list/inactive_demand = list()			//! List of commodities that didn't make the cut for `active_demand`.
	var/list/demand_price_modifiers = list(		//! Contains `/decl/merchant_price_modifier`s that determine how much to offer players selling things the merchant wants.
		/decl/merchant_price_modifier/percentage = 2.0,
		/decl/merchant_price_modifier/disposition = 1.2,
		/decl/merchant_price_modifier/legacy_skill_disparity/demand = 1.2
	)
	var/list/demand_tax_modifiers = list(
//		/decl/merchant_price_modifier/percentage/tax = 1.1
	)
	var/list/forbidden_objects = list(/mob/living/human, /obj/item/disk/nuclear)	//! List of type paths the merchant refuses to buy, with a unique dialogue compared to regular junk.
	var/decl/merchant_inventory_strategy/demand_strategy = /decl/merchant_inventory_strategy/legacy //! Determines how demand is initially stocked and how it rotates over time, if at all.

	// Both buying and selling.
	var/skill_level = SKILL_ADEPT			//! How good the merchant is at trading, and is compared against players' Finance skills to determine whether the merchant or player has an advantage in negotiations.
	var/price_variance = 1.1				//! Object values can randomly vary based on this. Values higher than 1.0 make potential prices 'swingier'. A value of 1.0 causes prices to be consistent.
	var/current_cash = null					//! How much cash the merchant currently has. If set to null, the merchant has unlimited funds.
	var/starting_cash_lower_bound = null	//! Upper bound for how much cash a merchant can start with.
	var/starting_cash_upper_bound = null	//! Lower bound for how much cash a merchant can start with.
	var/refuse_haggling = FALSE				//! If TRUE, the merchant refuses all attempts to haggle buying or selling prices.
	var/haggling_refusal_threshold = 0.1	//! Determines how far away from the merchant's perferred price players can haggle for. The actual threshold is randomized to be between 0 and this value.
	var/haggle_disposition_penalty = 50		//! Scales how far disposition drops when players try to offer bad deals to this merchant. Higher numbers make the merchants get fed up faster.
	var/decl/currency/currency_used = null	//! The currency used by the merchant. If unset, the map's default currency is used instead.
	var/const/TRANSACTION_SELLING = 1		//! Indicates a transaction where the merchant is selling to players.
	var/const/TRANSACTION_BUYING = -1		//! Indicates a transaction where the merchant is buying from players.

	// Bribes.
	var/refuse_bribes = TRUE				//! If TRUE, the merchant cannot be bribed with cash under any circumstances.
	var/refuse_gifts = FALSE				//! If TRUE, the merchant will not accept receiving wanted items for free.
	var/bribe_disposition_divisor = 10		//! Determines how much disposition goes up when bribed, by dividing the bribe amount by this value.
	var/bribe_duration_divisor = 100		//! Determines how much longer, in minutes, merchants will stay when bribed (if they are temporary), by dividing the bribe amount by this value.

	// Trade hub stuff.
	var/datum/trade_hub/hub = null			//! The trade hub which this merchant is located at.
	var/is_temporary_merchant = FALSE		//! If true, the merchant will eventually leave their hub, and players won't be able to interact with them anymore. This can be changed in-round to make temp. merchants stay.
	var/typical_duration_lower_bound = 20	//! Lower bound for how long this merchant stays, in minutes.
	var/typical_duration_upper_bound = 40	//! Upper bound for how long this merchant stays, in minutes.
	var/duration_of_stay = null				//! How long the merchant is planning to stay, in minutes. Set automatically on init if `is_temporary_merchant` is true.


/// Subtype for merchants which appear randomly at trade hubs as the round goes on, and disappear after enough time has passed.
/datum/merchant/transient
	abstract_type = /datum/merchant/transient
	is_temporary_merchant = TRUE
	refuse_bribes = FALSE


/// Subtype for merchants which should only show up at trade hubs rarely, and disappear after enough time has passed.
/datum/merchant/transient/rare
	abstract_type = /datum/merchant/transient/rare
	typical_duration_lower_bound = 40
	typical_duration_upper_bound = 60


/datum/merchant/New(datum/trade_hub/new_hub)
	..()
	if(istype(new_hub))
		hub = new_hub

	currency_used = currency_used ? GET_DECL(currency_used) : GET_DECL(global.using_map.default_currency)

	if(name_background)
		var/decl/background_detail/background = GET_DECL(name_background)
		name = background.get_random_cultural_name(gender = pick(MALE, FEMALE))
	if(!name)
		name = capitalize(pick(global.using_map.first_names_female + global.using_map.first_names_male)) + " " + capitalize(pick(global.using_map.last_names))

	if(length(possible_origins))
		origin = pick(possible_origins)

	if(length(merchant_languages))
		var/list/language_types = merchant_languages.Copy()
		merchant_languages.Cut()
		for(var/language_type in language_types)
			merchant_languages += GET_DECL(language_type)

	if(is_temporary_merchant)
		duration_of_stay = rand(typical_duration_lower_bound, typical_duration_upper_bound)

	if(starting_cash_lower_bound && starting_cash_upper_bound)
		current_cash = rand(starting_cash_lower_bound, starting_cash_upper_bound)

	haggling_refusal_threshold = rand(0, haggling_refusal_threshold * 100) / 100

	supply_strategy = GET_DECL(supply_strategy)
	demand_strategy = GET_DECL(demand_strategy)
	pre_inventory_generation()
	generate_inventory()


/datum/merchant/Destroy()
	if(hub && (src in hub.merchants))
		hub.remove_merchant(src)
	return ..()


/// Called by the trade hub once a minute.
/datum/merchant/proc/process(tick_count)
	supply_strategy.manage_inventory(active_supply, inactive_supply, tick_count)
	demand_strategy.manage_inventory(active_demand, inactive_demand, tick_count)

	if(is_temporary_merchant)
		duration_of_stay -= 1
		if(duration_of_stay <= 0)
			qdel(src)


/// Called just before merchant inventory is built.
/// This exists mostly for cross-modpack interactions to inject their items into a particular merchant type.
/datum/merchant/proc/pre_inventory_generation()
	SHOULD_CALL_PARENT(TRUE)
	return

/// Creates commodity datums out of `/decl/merchant_potential_commodity` types inside of the relevant `[supply|demand]_potential` lists.
/datum/merchant/proc/generate_inventory()
	for(var/type_path in supply_potential)
		var/decl/merchant_potential_commodities/potential = GET_DECL(type_path)
		inactive_supply += potential.get_commodities(TRANSACTION_SELLING, src)

	for(var/type_path in demand_potential)
		var/decl/merchant_potential_commodities/potential = GET_DECL(type_path)
		inactive_demand += potential.get_commodities(TRANSACTION_BUYING, src)

	setup_inventory()

/// Determines which items are put into active and inactive 'supply' and 'demand' lists, based on the
/// merchant's `[supply|demand]_strategy` decls.
/datum/merchant/proc/setup_inventory()
	inactive_supply = shuffle(inactive_supply)
	supply_strategy.setup_inventory(active_supply, inactive_supply)

	inactive_demand = shuffle(inactive_demand)
	demand_strategy.setup_inventory(active_demand, inactive_demand)


/**
Returns how much the merchant values a particular item.
- `atom/movable/item`: Instance or typepath of the item to evaluate.
- `transaction_direction`: Determines which price modifiers to use for determining the price of something. Note that the direction is from the perspective of the merchant.
	- `TRANSACTION_SELLING` gives the price of an item the merchant is selling to players.
	- `TRANSACTION_BUYING` gives how much the merchant would buy a particular item from players.
- `mob/user`: The user which initiated the item's evaluation.
*/
/datum/merchant/proc/get_item_value(atom/movable/item, transaction_direction, mob/user)
	// Get the base value.
	if(ispath(item, /atom/movable))
		. = atom_info_repository.get_combined_worth_for(item)
	else if(istype(item))
		. = item.get_combined_monetary_worth()

	// Apply relevant price modifiers.
	switch(transaction_direction)
		if(TRANSACTION_SELLING) // Merchant is selling to players.
			var/datum/merchant_commodity/commodity = find_supply_commodity(item)
			if(commodity)
				. *= commodity.price_variance
			. = calculate_price_modifiers(., supply_price_modifiers, user)
		if(TRANSACTION_BUYING) // Merchant is buying from players.
			var/datum/merchant_commodity/commodity = find_demand_commodity(item)
			if(commodity)
				. *= commodity.price_variance
			. = calculate_price_modifiers(., demand_price_modifiers, user)

			// Special case: if the merchant both buys and sells the same item, cap the buy price to the sell price.
			// This prevents someone from being able to buy and then sell the same thing back and forth to make a profit.
			var/item_typepath = istype(item) ? item.type : item
			if(find_supply_commodity(item_typepath))
				var/sell_price = get_item_value(item, TRANSACTION_SELLING, user)
				. = min(., sell_price)

	// Convert value to the merchant's currency.
	. = floor(. / currency_used.absolute_value)

	// Round to the nearest whole number, and enforcing a minimum value of one.
	return max(round(.), 1)


/**
Returns how much the merchant values a group of items, provided for convenience.
- `list/items`: List containing instances or typepaths of items to evaluate.
- `transaction_direction`: Determines which list to use for determining the price of something. Note that the direction is from the perspective of the merchant.
	- `TRANSACTION_SELLING` gives the price of each item in the list the merchant would use to sell to players.
	- `TRANSACTION_BUYING` gives how much the merchant would pay to buy all of the items from players.
- `mob/user`: The user which initiated the calculation.
*/
/datum/merchant/proc/get_value_of_items(list/items, transaction_direction, mob/user)
	. = 0
	for(var/item in items)
		. += get_item_value(item, transaction_direction, user)


/datum/merchant/proc/get_taxes(subtotal, transaction_direction, mob/user)
	. = subtotal
	switch(transaction_direction)
		if(TRANSACTION_SELLING)
			. = calculate_price_modifiers(., supply_tax_modifiers, user)
		if(TRANSACTION_BUYING)
			. = calculate_price_modifiers(., demand_tax_modifiers, user)
	return max(ceil(.), 1)


/datum/merchant/proc/calculate_price_modifiers(value, list/price_modifiers, mob/user)
	for(var/type_path in price_modifiers)
		var/decl/merchant_price_modifier/modifier = GET_DECL(type_path)
		value = modifier.calculate(value, price_modifiers[type_path], user, src)
	return value


/**
Returns TRUE if the merchant would agree to an offer to buy or sell at the inputted price.
- `list/items`: List containing object instances, or type paths that the user is attempting to sell to, or buy from, the merchant. Used to obtain the merchant's preferred price.
- `user_offer`: The amount of value that the user is offering for `items`. If the user isn't haggling, this is automatically filled in with what the merchant would've offered and should always succeed.
- `transaction_direction`: Determines whether the merchant is buying or selling to the user. Note that the direction is from the perspective of the merchant.
	- `TRANSACTION_SELLING`: Merchant is selling to the user. Merchant wants a higher price, user presumably wants a lower one.
	- `TRANSACTION_BUYING`: Merchant is buying from the user. Merchant wants a lower price, user presumably wants a higher one.
- `mob/user`: The user who initiated the trade.
*/
/datum/merchant/proc/evaluate_offer(list/items, user_offer, transaction_direction, mob/user)
	ASSERT(sign(transaction_direction) != 0)
	. = FALSE

	var/merchant_offer = 0
	var/refusal_threshold = 0
	for(var/thing in items)
		merchant_offer += get_item_value(thing, transaction_direction, user)
		refusal_threshold += calculate_haggle_limit(thing, transaction_direction, user)

	switch(transaction_direction)
		if(TRANSACTION_BUYING)
			if(user_offer <= merchant_offer)
				. = TRUE // Always accept if the player offers to match or makes a mistake.
			if(user_offer <= refusal_threshold)
				. = TRUE // Accept if it's close enough.

		if(TRANSACTION_SELLING)
			if(user_offer >= merchant_offer)
				. = TRUE
			if(user_offer >= refusal_threshold)
				. = TRUE


/**
Returns the 'price' of an item that the merchant will still accept, even if it's slightly off from their regular price.
- `atom/movable/item`: Instance or typepath of an item that will be evaluated.
- `transaction_direction`: Determines whether the haggling limit is for buying or selling `item`. This is from the perspective of the merchant.
	- `TRANSACTION_SELLING`: Merchant is selling to the user. Merchant wants a higher price, user presumably wants a lower one.
	- `TRANSACTION_BUYING`: Merchant is buying from the user. Merchant wants a lower price, user presumably wants a higher one.
- `mob/user`: The user who is trying to haggle with the merchant.
*/
/datum/merchant/proc/calculate_haggle_limit(atom/movable/item, transaction_direction, mob/user)
	var/value = get_item_value(item, transaction_direction, user)
	if(refuse_haggling) // This probably won't be called if this is true, but just in case...
		return value

	// The haggle limit is closely tied to how much value the merchant thinks the item should be worth.
	// For example, if `haggling_refusal_threshold` happens to be `0.1`, and they think the item is worth 100 value, the haggle limit will be 110 value when the merchant is buying,
	// and 90 value when the merchant is selling.
	// `haggling_refusal_threshold` is randomized between 0 and the compile time value assigned to it when the merchant is created.
	. = value * (1 + (transaction_direction * -haggling_refusal_threshold))

	// A potential exploit can exist if someone creates a merchant who buys and sells the same item, and the item has the same (or a very close) price.
	// Players could haggle the price to be slightly higher when selling, and slightly lower when buying, and obtain money without losing anything.
	// To fix that, the haggle limit is capped if this merchant buys and sells the same item.
	var/item_typepath = ispath(item) ? item : item.type
	var/inverse_direction_value = get_item_value(item_typepath, -transaction_direction, user)

	switch(transaction_direction)
		if(TRANSACTION_BUYING) // Merchant is buying from players.
			if(find_supply_commodity(item_typepath))
				. = min(., inverse_direction_value)
		if(TRANSACTION_SELLING) // Merchant is selling to players.
			if(find_demand_commodity(item_typepath))
				. = max(., inverse_direction_value)


/// Returns TRUE if one or more items in the list are inside of the merchant's list of forbidden types.
/datum/merchant/proc/offer_contains_forbidden_items(list/items)
	for(var/thing in items)
		var/atom/movable/item = thing
		if(is_type_in_list(item, forbidden_objects))
			return TRUE
		// This is to stop somebody from being able to sell a container full of forbidden objects, especially mob holders.
		for(var/forbidden_type in forbidden_objects)
			if(length(item.search_contents_for(forbidden_type)))
				return TRUE
	return FALSE

/// Returns TRUE if all items in the list are in demand by the merchant.
/datum/merchant/proc/offer_contains_wanted_items(list/items)
	for(var/thing in items)
		if(!find_demand_commodity(thing))
			return FALSE
	return TRUE

/**
Returns a commodity instance representing an item being sold, that matches the inputted item instance or type path, if one exists.
- `atom/movable/item`: Instance or type path to find a matching commodity instance for.
*/
/datum/merchant/proc/find_supply_commodity(atom/movable/item)
	var/type_path = item
	if(istype(item))
		type_path = item.type

	for(var/datum/merchant_commodity/commodity as anything in active_supply)
		if(type_path == commodity.spawn_path)
			return commodity
	return null

/**
Returns a commodity instance representing an item in demand, that matches the inputted item instance, if one exists.
- `atom/movable/item`: Instance to find a matching commodity instance for.
*/
/datum/merchant/proc/find_demand_commodity(atom/movable/item)
	for(var/datum/merchant_commodity/commodity as anything in active_demand)
		if(commodity.check_requirements(item))
			return commodity
	return null

/**
Called after a successful trade, either buying or selling something. Bribes are not considered transactions for that purpose.
Override for custom behavior.
- `mob/user`: The user who initiated the trade.
- `list/items`: The object instances which were traded for. Note that items sold to a merchant are about to be deleted.
- `transaction_direction`: Whether the merchant was buying from, or selling to, the user.
	- `TRANSACTION_SELLING`: The merchant sold the contents of `items` to `user`.
	- `TRANSACTION_BUYING`: The merchant bought the contents of `items` from `user`.
- `wanted_value`: How much value the merchant wanted for the trade, which might not be equal to `actual_value`.
- `actual_value`: How much value the merchant received from the trade, either in cash or the worth of items received for if bartering.
- `turf/location`: The turf containing the merchant pad that was used for the transaction. This can be used to derive further location-based information, like the merchant pad's z-level.
*/
/datum/merchant/proc/on_completed_transaction(mob/user, list/items, transaction_direction, wanted_value, actual_value, turf/location)
	SHOULD_CALL_PARENT(TRUE)
	transaction_disposition_shift(items, transaction_direction, user)


/**
Called after a successful trade, awarding disposition based on how much value the merchant bought or sold.
- `list/items`: Objects which were just bought or sold to the merchant. Note that items sold to a merchant are about to be deleted.
- `transaction_direction`: Whether the merchant was buying from, or selling to, the user.
	- `TRANSACTION_SELLING`: The merchant sold the contents of `items` to `user`.
	- `TRANSACTION_BUYING`: The merchant bought the contents of `items` from `user`.
- `mob/user`: The user who initiated the trade.
*/
/datum/merchant/proc/transaction_disposition_shift(list/items, transaction_direction, mob/user)
	var/value_moved = 0

	for(var/thing in items)
		var/atom/movable/item = thing
		var/item_typepath = istype(item) ? item.type : item
		var/value = get_item_value(item, transaction_direction, user)
		var/inverse_direction_value = get_item_value(item_typepath, -transaction_direction, user)

		// Yet another special case:
		// If the merchant buys and sells the same thing, it would be possible to do a buy/sell cycle and get cheap or even free disposition out of it.
		// To fix this, the disposition gained is reduced based on how close the buy and sell prices are.
		// More specifically, the amount is based on how much money the merchant would've gained if a player bought and then immediately sold the same item.
		// For example, if the merchant sells widgets for 200 value, and buys them for 100, then a player buying a widget will get an amount of disposition as if the player bought something for 100 value.
		// If instead the merchant sells and buys widgets for 200, the player will get zero disposition from the transaction.
		switch(transaction_direction)
			if(TRANSACTION_SELLING)
				if(find_demand_commodity(item_typepath))
					value = value - inverse_direction_value
			if(TRANSACTION_BUYING)
				if(find_supply_commodity(item_typepath))
					value = inverse_direction_value - value
		value_moved += value

	// Trading something is half as effective as a straight up bribe, since the merchant presumably still needs to replace what was sold or sell off what was bought.
	var/disposition_shift = (value_moved / bribe_disposition_divisor) * 0.5
	adjust_dispositon(disposition_shift, user)


/// Returns whether the merchant has a specific quantity of cash.
/datum/merchant/proc/has_cash(amount)
	if(isnull(current_cash)) // If unset, the merchant has infinite cash.
		return TRUE
	return current_cash >= amount

/// Adds or subtracts a specific quantity from the merchant's cash reserves.
/datum/merchant/proc/adjust_cash(amount)
	if(isnull(current_cash)) // Functionally infinite.
		return
	current_cash += amount

/// Determines if the user can understand what this merchant says. Users who cannot understand merchants will be greatly hindered in interacting with them.
/datum/merchant/proc/can_be_understood(mob/user)
	// It'd be great to piggyback off of saycode or language decls but that requires two actual mobs and merchants aren't mobs.
	// Plus Neb languages don't seem to have a concept of the written word.
	// So instead it's just a simple language intersection check.
	if(!isliving(user))
		return TRUE // For ghosts.
	var/list/common_languages = user.languages & merchant_languages
	return length(common_languages) ? TRUE : FALSE

/// Garbles the text based on the merchant's languages.
/// Generally you want to check and then scramble just before serving the text to each player, so that different players will see what they're supposed to see.
/datum/merchant/proc/scramble_response(mob/user, response_text)
	var/decl/language/primary_language = merchant_languages[1] // The first language on the list is presumed to be the merchant's primary tongue.
	return primary_language.scramble(null, response_text, user.languages)

/// Determines if the merchant will refuse hails or not. Override for custom hailing rules.
/// Despite the name, interaction will cease if this returns FALSE in the middle of interacting with a merchant, not just the beginning.
/datum/merchant/proc/can_hail(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if(denying_anonymous_comms(user))
		return FALSE
	return get_disposition(user) > comms_refusal_threshold

/// Returns TRUE if the merchant doesn't want to interact with scary nameless people.
/datum/merchant/proc/denying_anonymous_comms(mob/user)
	return refuse_anonymous_comms && isliving(user) && get_identity(user) == "Unknown"  // Non-living types are allowed so that ghosts pass through.

/// Called just before the hail actually happens.
/datum/merchant/proc/pre_hail(mob/user)
	SHOULD_CALL_PARENT(TRUE)

/// Determines if hailing the merchant succeeded or not.
/datum/merchant/proc/hail(mob/user)
	pre_hail(user)
	if(!can_hail(user))
		return FALSE
	return TRUE

/// Retrieves the disposition value for a particular mob instance with an associated 'identity', which is just their name as stated on their ID, if one exists.
/// Merchants will treat mobs with the same identity as being the same person for opinion purposes.
/// This will likely be most common in the case of people without IDs being remembered as 'Unknown'.
/datum/merchant/proc/get_disposition(mob/user)
	var/identity = get_identity(user)
	if(isnull(remembered_identities[identity]))
		remember_identity(user)
	return remembered_identities[identity]

/// Determines the default disposition value for a new identity.
/// This can be overriden to conditionally have merchants have different starting disposition values.
/// One example could be to simulate certain merchants already having a vague opinion on certain kinds of characters, perhaps by pulling from a character's background details.
/datum/merchant/proc/default_disposition(mob/user)
	return 0

/// Retrieves a string to be used as a particular mob's 'identity'.
/// Generally it will just be what their ID says, or Unknown if they lack one, as presumably the trading computer reads it off the ID.
/// Using name strings instead of weakrefs to actual mobs opens the door to impersonation as well as letting players have a second chance if they accidentally offended the merchant,
/// by showing up as "Unknown" (assuming nobody else burned that identity as well).
/datum/merchant/proc/get_identity(mob/user)
	var/name_to_use = user.name
	if(isliving(user))
		var/mob/living/L = user
		name_to_use = L.get_authentification_name(if_no_id = "Unknown")
	return name_to_use

/// Commits a newly encountered identity to the merchant's memory, giving it a default opinion value.
/// Called automatically if the merchant fails to pull an already existing identity from `remembered_identities`.
/datum/merchant/proc/remember_identity(mob/user)
	var/identity = get_identity(user)
	if(!isnull(remembered_identities[identity]))
		return
	remembered_identities[identity] = default_disposition(user)

/// Increases or decreases the merchant's opinion of a mob's associated identity by a set amount.
/// Due to disposition multipliers, the actual result may be different or may not actually change anything.
/// Returns the actual change in disposition.
/datum/merchant/proc/adjust_dispositon(amount, mob/user)
	amount *= amount >= 0 ? positive_disposition_multiplier : negative_disposition_multiplier
	var/old_disposition = get_disposition(user)
	remembered_identities[get_identity(user)] += amount
	on_disposition_changed(old_disposition, get_disposition(user), user)
	return amount

/// Sets the merchant's opinion of a mob's associated identity to a specific value, no matter what.
/datum/merchant/proc/set_disposition(amount, mob/user)
	var/old_disposition = get_disposition(user)
	remembered_identities[get_identity(user)] = amount
	on_disposition_changed(old_disposition, get_disposition(user), user)

/**
Called whenever the merchant's disposition changes.
Override for custom behavior when that happens.
- `old_disposition`: What the merchant's disposition was prior to whatever changed it.
- `new_disposition`: What the merchant's disposition is currently.
- `mob/user`: The mob who caused a disposition change associated with their identity.
*/
/datum/merchant/proc/on_disposition_changed(old_disposition, new_disposition, mob/user)
	SHOULD_CALL_PARENT(TRUE)

/// Attempts to raise the merchant's disposition with flattery.
/// Note that this returns TRUE even if no disposition is gained, but merely that the merchant took it well.
/datum/merchant/proc/compliment(mob/user)
	if(prob(times_complimented++ * 10) || prob(-get_disposition(user)))
		adjust_dispositon(-rand(2.5, 5), user) //TODO: Make this not hardcoded?
		return FALSE
	if(prob(MAX_DISPOSITION_THRESHOLD - get_disposition(user)))
		adjust_dispositon(rand(5, 10), user) //TODO: ditto
	return TRUE

/// Deliberately worsens the relationship between the merchant and a mob's associated identity, for whatever reason.
/datum/merchant/proc/insult(mob/user)
	adjust_dispositon(-rand(5, 10), user)

/// Determines if the merchant is bribable.
/datum/merchant/proc/can_bribe()
	SHOULD_CALL_PARENT(TRUE)
	return !refuse_bribes

/// Attempts to bribe the merchant with `amount` units of value, which will generally increase their disposition and make them stay longer, if applicable.
/// Override for extra behavior when bribed.
/datum/merchant/proc/bribe(amount, mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_bribe())
		return FALSE
	adjust_cash(amount)
	if(bribe_duration_divisor && is_temporary_merchant)
		duration_of_stay += floor(amount / bribe_duration_divisor)
	if(bribe_disposition_divisor)
		adjust_dispositon(floor(amount / bribe_disposition_divisor), user)
	return TRUE

