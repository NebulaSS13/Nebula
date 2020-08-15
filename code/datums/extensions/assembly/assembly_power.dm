
/datum/extension/assembly/proc/power_failure(var/malfunction = 0)
	if(enabled)
		shutdown_device(0)

/datum/extension/assembly/proc/has_power()
	return battery_power(0) || apc_power(0)

// Tries to use power from battery. Passing 0 as parameter results in this proc returning whether battery is functional or not.
/datum/extension/assembly/proc/battery_power(var/power_usage = 0)
	apc_powered = FALSE
	for(var/obj/item/stock_parts/computer/battery_module/battery_module in parts)
		if(battery_module.check_functionality() && battery_module.battery.checked_use(power_usage * CELLRATE))
			return TRUE

// Tries to use power from APC, if present.
/datum/extension/assembly/proc/apc_power(var/power_usage = 0)
	apc_powered = TRUE
	// Tesla link was originally limited to machinery only, but this probably works too, and the benefit of being able to power all devices from an APC outweights
	// the possible minor performance loss.
	var/obj/item/stock_parts/computer/tesla_link/tesla_link
	for(var/obj/item/stock_parts/computer/tesla_link/TL in parts)
		if(TL.check_functionality())
			tesla_link = TL
			break
	if(!istype(tesla_link))
		return FALSE

	var/area/A = get_area(tesla_link.loc)
	if(!istype(A) || !A.powered(EQUIP))
		return FALSE

	// At this point, we know that APC can power us for this tick. Check if we also need to charge our battery, and then actually use the power.
	for(var/obj/item/stock_parts/computer/battery_module/battery_module in parts)
		if(battery_module.check_functionality() && (battery_module.battery.charge < battery_module.battery.maxcharge) && power_usage > 0)
			power_usage += tesla_link.passive_charging_rate
			battery_module.battery.give(tesla_link.passive_charging_rate * CELLRATE)

	A.use_power_oneoff(power_usage, EQUIP)
	return TRUE

// Handles power-related things, such as battery interaction, recharging, shutdown when it's discharged
/datum/extension/assembly/proc/calculate_power_usage()
	var/power_usage = screen_on ? base_active_power_usage : base_idle_power_usage
	for(var/obj/item/stock_parts/computer/P in parts)
		if(P.enabled)
			power_usage += P.power_usage
	return power_usage

/datum/extension/assembly/proc/handle_power()
	last_power_usage = calculate_power_usage()

	// First tries to charge from an APC, if APC is unavailable switches to battery power. 
	// If neither works the computer fails.
	if(apc_power(last_power_usage)) return
	if(battery_power(last_power_usage)) return
	power_failure()