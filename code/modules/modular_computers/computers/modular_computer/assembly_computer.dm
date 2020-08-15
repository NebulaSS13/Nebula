/*
 *
 * Assembly explicitly for modular computers.
 *
 */
/datum/extension/assembly/modular_computer
	var/max_hardware_size
	var/hardware_flag
	var/bsod
	var/enabled_by_default = FALSE
	var/force_synth				// Whether or not to force issynth checks to return TRUE.
	assembly_name = "computer"
	max_parts = list(
		PART_D_SLOT		= 1,
		PART_BATTERY 	= 1,
		PART_CPU		= 1,
		PART_NETWORK	= 1,
		PART_HDD		= 1,
		PART_CARD		= 1,
		PART_PRINTER	= 1,
		PART_AI			= 1,
		PART_TESLA		= 1,
		PART_SCANNER	= 1,
		PART_MSTICK		= 1
	)
	critical_parts = list(PART_CPU, PART_HDD, PART_NETWORK)

/datum/extension/assembly/modular_computer/try_install_component(var/mob/living/user, var/obj/item/stock_parts/computer/P)
	if(!(P.usage_flags & hardware_flag))
		to_chat(user, "This computer isn't compatible with [P].")
		return
	var/obj/item/stock_parts/computer/C = P
	if(istype(C) && C.hardware_size > max_hardware_size)
		to_chat(user, "This component is too large for \the [holder].")
		return
	. = ..()
	if(.)
		if(istype(P, /obj/item/stock_parts/computer/scanner))
			var/obj/item/stock_parts/computer/scanner/scanner = P
			scanner.do_after_install(user, holder)
		return TRUE

/datum/extension/assembly/modular_computer/uninstall_component(var/mob/living/user, var/obj/item/stock_parts/P)
	if(istype(P, /obj/item/stock_parts/computer/scanner))
		var/obj/item/stock_parts/computer/scanner/scanner = P
		scanner.do_before_uninstall()
	return ..()

/datum/extension/assembly/modular_computer/critical_shutdown()
	var/atom/movable/H = holder
	H.visible_message(SPAN_DANGER("\The [assembly_name]'s screen freezes for few seconds and then displays an \"HARDWARE ERROR: Critical component disconnected. Please verify component connection and reboot the device. If the problem persists contact technical support for assistance.\" warning."))
	. = ..()

/datum/extension/assembly/modular_computer/power_failure(var/malfunction = 0)
	var/atom/movable/H = holder
	H.visible_message("<span class='danger'>\The [assembly_name]'s screen flickers briefly and then goes dark.</span>", range = 1)
	var/datum/extension/interactive/ntos/os = get_extension(holder, /datum/extension/interactive/ntos)
	if(os)
		os.event_powerfailure()
	. = ..()

/datum/extension/assembly/modular_computer/turn_on(var/mob/user)
	if(bsod)
		return
	. = ..()

	var/issynth = issilicon(user) // Robots and AIs get different activation messages.
	if(damage > broken_damage)
		if(force_synth || issynth)
			to_chat(user, SPAN_WARNING("You send an activation signal to \the [assembly_name], but it responds with an error code. It must be damaged."))
		else
			to_chat(user, SPAN_WARNING("You press the power button, but the computer fails to boot up, displaying variety of errors before shutting down again."))
		shutdown_device()
		return
	if(has_critical_parts() && has_power()) // Battery-run and charged or non-battery but powered by APC.
		if(force_synth || issynth)
			to_chat(user, SPAN_NOTICE("You send an activation signal to \the [assembly_name], turning it on."))
		else
			to_chat(user, SPAN_NOTICE("You press the power button and start up \the [assembly_name]."))
		var/datum/extension/interactive/ntos/os = get_extension(holder, /datum/extension/interactive/ntos)
		if(os)
			os.system_boot()
	else // Unpowered
		if(force_synth || issynth)
			to_chat(user, SPAN_WARNING("You send an activation signal to \the [assembly_name], but it does not respond."))
		else
			to_chat(user, SPAN_WARNING("You press the power button but \the [assembly_name], does not respond."))
		shutdown_device()

/datum/extension/assembly/modular_computer/shutdown_device()
	. = ..()
	var/datum/extension/interactive/ntos/os = get_extension(holder, /datum/extension/interactive/ntos)
	if(os)
		os.system_shutdown()