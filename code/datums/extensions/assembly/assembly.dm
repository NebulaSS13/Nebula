/*
 * Friendly class for managing component-level construction for /obj/items.
 *
 * Handles power, installation, and some processing.
 * Basic usage:
 *	1. Have Processing enabled on your item/machine. Call Process() on the assembly datum.
 *	2. Call attackby on the assembly datum to handle tool interactions.
 *	3. Recommended to also hook into ex_act, and any of the assembly_damage functions on base level for assembly to handle damage.
 */

/datum/extension/assembly
	base_type = /datum/extension/assembly
	var/assembly_name = "assembly"
	var/list/parts = list()					// List of all components.
	var/list/max_parts						// Max parts allowed. Dict, key is type, value is max number allowed.
	var/list/critical_parts					// Parts that are required for the device to function. Normal list.

	// Some stateful variables.
	var/apc_powered				= FALSE		// Power is coming from APC.
	var/enabled					= FALSE		// Device is active/turned on.
	var/base_active_power_usage	= 50
	var/base_idle_power_usage	= 5
	var/last_power_usage		= 0

	var/steel_sheet_cost = 5				// Amount of steel sheets refunded when disassembling an empty assembly.

	var/damage = 0				// Current damage level
	var/broken_damage = 50		// Damage level at which the assembly ceases to operate
	var/max_damage = 100		// Damage level at which the assembly breaks apart.

	var/screen_on				= TRUE

/datum/extension/assembly/proc/try_install_component(var/mob/living/user, var/obj/item/stock_parts/P)
	for(var/max_part_type in max_parts)
		if(istype(P, max_part_type))
			var/existing_parts = get_components_by_type(max_part_type)
			if(length(existing_parts) >= max_parts[max_part_type])
				if(user)
					to_chat(user, "This [assembly_name]'s does not have room for additional [P].")
				return
	parts += P
	if(user)
		user.try_unequip(P, holder)
		to_chat(user, "You install \the [P] into \the [assembly_name].")
	return TRUE

/datum/extension/assembly/proc/uninstall_component(var/mob/living/user, var/obj/item/stock_parts/P)
	parts -= P
	if(user)
		to_chat(user, "You remove \the [P] from \the [assembly_name].")
		user.put_in_hands(P)
	else
		var/atom/movable/H = holder
		P.dropInto(H.loc)
	if(enabled && (P.type in critical_parts))
		critical_shutdown()

/datum/extension/assembly/proc/add_replace_component(var/mob/living/user, var/part_type, var/obj/item/stock_parts/P)
	var/existing_component = get_component(part_type)
	if(existing_component)
		uninstall_component(user, existing_component)
	try_install_component(user, P)

/datum/extension/assembly/proc/get_component(var/type)
	for(var/part in parts)
		if(istype(part, type))
			return part

/datum/extension/assembly/proc/get_components_by_type(var/type)
	var/list/found_parts = list()
	for(var/part in parts)
		if(istype(part, type))
			found_parts += part
	return found_parts

/datum/extension/assembly/proc/find_component_by_name(var/name)
	for(var/obj/item/P in parts)
		if(P.name == name)
			return P

/datum/extension/assembly/proc/get_all_components()
	return parts?.Copy()


/datum/extension/assembly/proc/shutdown_device()
	enabled = FALSE
	for(var/obj/item/stock_parts/computer/P in parts)
		P.enabled = FALSE

/datum/extension/assembly/proc/critical_shutdown()
	shutdown_device()

/datum/extension/assembly/proc/turn_on(var/mob/user)
	enabled = TRUE
	for(var/obj/item/stock_parts/computer/P in parts)
		P.enabled = TRUE

/datum/extension/assembly/Process()
	if(!enabled) // The computer is turned off
		last_power_usage = 0
		return

	if(damage > broken_damage)
		critical_shutdown()
		return

	handle_power()

/datum/extension/assembly/proc/has_critical_parts()
	for(var/crit_type in critical_parts)
		var/found_part = FALSE
		for(var/part in parts)
			found_part = istype(part, crit_type)
			if(found_part)
				break
		if(!found_part)
			return FALSE
	return TRUE

/datum/extension/assembly/Destroy()
	QDEL_NULL_LIST(parts)
	return ..()