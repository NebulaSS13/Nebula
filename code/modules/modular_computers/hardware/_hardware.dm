/obj/item/stock_parts/computer/
	name = "Hardware"
	desc = "Unknown Hardware."
	icon = 'icons/obj/items/stock_parts/modular_components.dmi'
	part_flags = PART_FLAG_HAND_REMOVE
	var/power_usage = 0 			// If the hardware uses extra power, change this.
	var/enabled = 1					// If the hardware is turned off set this to 0.
	var/critical = 1				// Prevent disabling for important component, like the HDD.
	var/hardware_size = 1			// Limits which devices can contain this component. 1: Tablets/Laptops/Consoles, 2: Laptops/Consoles, 3: Consoles only
	var/usage_flags = PROGRAM_ALL
	var/external_slot				// Whether attackby will be passed on it even with a closed panel

/obj/item/stock_parts/computer/attackby(var/obj/item/W, var/mob/user)
	// Multitool. Runs diagnostics
	if(IS_MULTITOOL(W))
		to_chat(user, "***** DIAGNOSTICS REPORT *****")
		to_chat(user, jointext(diagnostics(), "\n"))
		to_chat(user, "******************************")
		return 1
	return ..()

/obj/item/stock_parts/computer/on_install(obj/machinery/machine)
	. = ..()
	do_after_install(machine, TRUE)

/obj/item/stock_parts/computer/on_uninstall(obj/machinery/machine, temporary)
	do_before_uninstall(machine, TRUE)
	. = ..()

// Called on multitool click, prints diagnostic information to the user.
/obj/item/stock_parts/computer/proc/diagnostics()
	return list("Hardware Integrity Test... (Corruption: [get_percent_damages()]%)")

/obj/item/stock_parts/computer/Initialize()
	. = ..()
	w_class = hardware_size

/obj/item/stock_parts/computer/Destroy()
	if(istype(loc, /obj/item/modular_computer))
		var/datum/extension/assembly/modular_computer/assembly = get_extension(loc, /datum/extension/assembly)
		if(assembly)
			assembly.uninstall_component(null, src)
	return ..()

// Handles damage checks
/obj/item/stock_parts/computer/proc/check_functionality()
	// Turned off
	if(!enabled)
		return 0
	return is_functional()

// Called when component is disabled/enabled by the OS
/obj/item/stock_parts/computer/proc/on_disable()
/obj/item/stock_parts/computer/proc/on_enable(var/datum/extension/interactive/os/os)

/obj/item/stock_parts/computer/proc/update_power_usage()
	var/datum/extension/interactive/os/os = get_extension(loc, /datum/extension/interactive/os)
	if(os)
		os.recalc_power_usage()

/obj/item/stock_parts/computer/proc/do_after_install(atom/device, loud)

/obj/item/stock_parts/computer/proc/do_before_uninstall(atom/device, loud)