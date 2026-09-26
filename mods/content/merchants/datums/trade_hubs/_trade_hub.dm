/// Essentially a container for merchants.
/datum/trade_hub
	abstract_type = /datum/trade_hub
	var/name = "Trading Hub"							//! The name of this particular hub, shown in UIs to players.
	var/max_merchants = 3								//! Max cap for how many merchants should occupy this hub. This is more of a soft cap, since admin verbs don't respect this limit.
	var/merchant_attraction_multiplier = 2				//! Modifies how likely it is for a merchant to show up, based on how empty the merchant list is.
	var/rare_merchant_chance = 5						//! The chance that a 'rare' temporary merchant can be chosen instead of one of the regular ones.
	var/list/merchants = list()							//! Instances of merchants currently present at this trade hub.
	var/list/merchant_types_in_use = list()				//! List of types currently in use, used to avoid duplicate merchants existing concurrently.
	var/list/initial_merchant_types = null				//! Merchant types which will, in the order defined, be added to the merchant list on init, if space permits.
	var/list/extra_initial_merchant_types = null		//! Merchant types which can potentially be chosen to be added randomly on init, after `initial_merchant_types`, up to a specified number.
	var/list/post_roundstart_merchant_types = null		//! Merchant types which could show up randomly as the round goes on, if space permits.
	var/list/post_roundstart_rare_merchant_types = null //! Merchant types which rarely show up randomly as the round goes on, based on `rare_merchant_chance`, if space permits.
	var/auto_populate_merchant_lists = TRUE				//! If TRUE, and if the initial or post roundstart merchant lists are empty, they will be populated by the relevent procs.
	var/initial_merchant_ratio = 0.5					//! Determines the target ratio of initial to post-roundstart merchants. 0.5 results in half of each, 1 gives all initials, and 0 gives no initals.

/datum/trade_hub/New()
	..()
	SStrade.trade_hubs += src
	populate_merchant_types()
	generate_initial_merchants()

/datum/trade_hub/Destroy(force)
	SStrade.trade_hubs -= src
	QDEL_NULL_LIST(merchants)
	return ..()

/datum/trade_hub/Process(wait, times_fired)
	for(var/datum/merchant/merchant as anything in merchants)
		merchant.process(times_fired)
	attract_merchants()

/// Fills out various lists that will be looked at later to determine what merchants can exist at this trade hub.
/// This can be disabled with `auto_populate_merchant_lists`, in order to allow someone to manually define specific types in order to fit a certain theme,
/// e.g. it might be weird for a mining-focused trade hub to have a bakery.
/datum/trade_hub/proc/populate_merchant_types()
	if(auto_populate_merchant_lists)
		// `initial_merchant_types` is intended to be filled out manually or left empty, to take priority over the 'extra' list.
		if(!length(extra_initial_merchant_types))
			extra_initial_merchant_types = get_permanent_merchant_types()
		if(!length(post_roundstart_merchant_types))
			post_roundstart_merchant_types = get_transient_merchant_types()
		if(!length(post_roundstart_rare_merchant_types))
			post_roundstart_rare_merchant_types = get_rare_transient_merchant_types()

/// Places the starting merchants onto the trade hub, prioritizing those in the `initial_merchant_types` list,
/// then padding out the rest with randomly selected ones afterwards, up to the limit given by `get_initial_merchant_count()`.
/datum/trade_hub/proc/generate_initial_merchants()
	var/maximum = get_initial_merchant_count()
	// First, add the guarenteed ones.
	for(var/merchant_type in initial_merchant_types)
		if(merchant_type in merchant_types_in_use)
			continue // Don't add duplicate merchants.
		if(length(merchants) >= maximum)
			return
		add_merchant(merchant_type)

	// Afterwards, add extra merchants, if desired and if they would fit.
	var/extra_space = maximum - length(merchants)
	if(length(extra_initial_merchant_types) && extra_space > 0)
		var/list/candidate_types = extra_initial_merchant_types.Copy()
		candidate_types = shuffle(candidate_types)

		for(var/i = 1 to extra_space)
			if(!length(candidate_types))
				return // We ran out of merchant types.
			var/candidate = pick_n_take(candidate_types)
			if(candidate in merchant_types_in_use)
				continue // Don't add duplicate merchants.
			add_merchant(candidate)

/// Called once a minute after the round starts, to slowly fill the trade hub with (by default) temporary merchants, up to `max_merchants`.
/datum/trade_hub/proc/attract_merchants()
	var/extra_space = max_merchants - length(merchants)
	// The more extra space there is, the faster new merchants will show up to fill it.
	if(extra_space > 0 && prob(extra_space * merchant_attraction_multiplier))
		var/list/possible_incoming_merchants = post_roundstart_merchant_types?.Copy() || list()
		if(length(post_roundstart_rare_merchant_types) && prob(rare_merchant_chance))
			possible_incoming_merchants = post_roundstart_rare_merchant_types.Copy()

		var/new_merchant_type = null
		possible_incoming_merchants = shuffle(possible_incoming_merchants)
		for(var/candidate in possible_incoming_merchants)
			if(candidate in merchant_types_in_use)
				continue // Don't add duplicate merchants.
			new_merchant_type = candidate
			break

		if(new_merchant_type)
			add_merchant(new_merchant_type)

/// Returns the target number of merchants this trade hub should have when initialized.
/// This exists to allow overriding it elsewhere for special behavior, such as randomizing the number.
/datum/trade_hub/proc/get_initial_merchant_count()
	return floor(max_merchants * initial_merchant_ratio)

/datum/trade_hub/proc/get_permanent_merchant_types()
	return get_non_abstract_types(/datum/merchant) - get_transient_merchant_types() - get_forbidden_merchant_types()

/datum/trade_hub/proc/get_transient_merchant_types()
	return get_non_abstract_types(/datum/merchant/transient) - get_rare_transient_merchant_types() - get_forbidden_merchant_types()

/datum/trade_hub/proc/get_rare_transient_merchant_types()
	return get_non_abstract_types(/datum/merchant/transient/rare) - get_forbidden_merchant_types()

/datum/trade_hub/proc/get_forbidden_merchant_types()
	return get_non_abstract_types(/datum/merchant/test)

/// Adds a merchant to the trade hub.
/datum/trade_hub/proc/add_merchant(merchant_type)
	var/datum/merchant/new_merchant = new merchant_type(src)
	merchants += new_merchant
	merchant_types_in_use += merchant_type
	RAISE_EVENT(/decl/observ/merchant_arrived, new_merchant, src)

/// Removes a merchant from the trade hub.
/datum/trade_hub/proc/remove_merchant(datum/merchant/merchant_instance)
	merchants -= merchant_instance
	merchant_types_in_use -= merchant_instance.type
	RAISE_EVENT(/decl/observ/merchant_departed, merchant_instance, src)

/// Determines if a trade hub is considered accessible, which is required for the crew to be able to interact with it and the merchants there.
/datum/trade_hub/proc/is_accessible_from(turf/checked_turf)
	return FALSE



