/// Controls the behavior of merchant stock availability and rotation.
/decl/merchant_inventory_strategy
	abstract_type = /decl/merchant_inventory_strategy

/**
Called once on merchant initialization.
- `list/active_list`: The 'active' supply or demand list, contianing things merchants are currently wanting to buy or sell. On init, this is probably empty.
- `list/inactive_list`: The 'inactive' supply or demand list, containing things not available currently, but potentially could be later on. On init, this is probably where everything is.
*/
/decl/merchant_inventory_strategy/proc/setup_inventory(list/active_list, list/inactive_list)
	return

/**
Called once every minute.
- `list/active_list`: The 'active' supply or demand list, contianing things merchants are currently wanting to buy or sell.
- `list/inactive_list`: The 'inactive' supply or demand list, containing things not available currently, but potentially could be later on.
- `tick_count`: How many times the Trade subsystem has fired in the current round. The modulo operator can be used along with this to only manipulate the lists every X minutes.
*/
/decl/merchant_inventory_strategy/proc/manage_inventory(list/active_list, list/inactive_list, tick_count)
	return


/// Makes everything be on the active list unconditionally, i.e. they will always sell (or buy) everything they could.
/// Use with care for merchants that offer or want a lot of different things.
/decl/merchant_inventory_strategy/offer_everything

/decl/merchant_inventory_strategy/offer_everything/setup_inventory(list/active_list, list/inactive_list)
	active_list += inactive_list
	inactive_list.Cut()


/// Attempts to mimic the old merchant inventory behavior, but reaches the terminal state instantly instead of over time.
/decl/merchant_inventory_strategy/legacy
	var/starting_selection_lower_bround = 3
	var/starting_selection_upper_bound = 6
	var/base_chance = 200

/decl/merchant_inventory_strategy/legacy/setup_inventory(list/active_list, list/inactive_list)
	// First, there's always a 'guaranteed' number of items offered.
	// After that, there is an increasing chance for further items to not make it to the active list.
	var/freebie_limit = rand(starting_selection_lower_bround, starting_selection_upper_bound)
	var/i = 0
	for(var/key, value in inactive_list)
		i++
		var/chance = base_chance / max(1, length(active_list))
		if(i <= freebie_limit || prob(chance))
			active_list[key] = value
			inactive_list -= key

/// Shifts a number of items between the two lists every so often.
/// If the merchant is allowed to exist for long enough, they will eventually complete a full cycle and bring back things they 'put away', and vice versa.
/decl/merchant_inventory_strategy/rotate_over_time
	var/ticks_between_rotations = 1 /// How often should things be rotated, in minutes.
	var/rotated_percentage = 0.1 /// Percentage of total items which are moved between lists every rotation.
	var/initial_percentage = 0.3 /// Percentage of total items which are initially available. If `rotated_percentage` is lower than this, some items will remain available every time the inventory rotates.

/decl/merchant_inventory_strategy/rotate_over_time/setup_inventory(list/active_list, list/inactive_list)
	ASSERT(initial_percentage <= 1.0)
	var/max_starting_amount = ceil(length(inactive_list) * initial_percentage)
	var/i = 0
	for(var/key, value in inactive_list)
		if(i >= max_starting_amount)
			return
		active_list[key] = value
		inactive_list -= key
		i++

/decl/merchant_inventory_strategy/rotate_over_time/manage_inventory(list/active_list, list/inactive_list, tick_count)
	if(tick_count % ticks_between_rotations != 0)
		return

	var/total_length = length(active_list) + length(inactive_list)
	var/amount_to_active = min(ceil(total_length * rotated_percentage), length(inactive_list))
	var/amount_to_inactive = min(ceil(total_length * rotated_percentage), length(active_list))

	var/i = 0
	for(var/key, value in active_list)
		if(i >= amount_to_inactive)
			break
		inactive_list[key] = value
		active_list -= key
		i++

	i = 0
	for(var/key, value in inactive_list)
		if(i >= amount_to_active)
			break
		active_list[key] = value
		inactive_list -= key
		i++


/// Moves a certain percentage of items to the active list on merchant init, permanently.
/decl/merchant_inventory_strategy/percentage
	var/active_ratio = 0.5 /// Determines how much of the inactive list is placed into the active list. 0.5 results in half, 1 results in everything going in, and 0 results in nothing making it.

/decl/merchant_inventory_strategy/percentage/setup_inventory(list/active_list, list/inactive_list)
	if(!length(inactive_list))
		return

	var/amount_to_active = ceil(length(inactive_list) * active_ratio)
	var/i = 0
	for(var/key, value in inactive_list)
		if(i >= amount_to_active)
			return
		active_list[key] = value
		inactive_list -= key
		i++

/decl/merchant_inventory_strategy/percentage/zero
	active_ratio = 0