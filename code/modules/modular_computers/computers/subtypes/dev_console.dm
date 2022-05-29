/obj/machinery/computer/modular
	name = "modular console"
	maximum_component_parts = list(/obj/item/stock_parts = 14)	//There's a lot of stuff that goes in these
	var/list/interact_sounds = list("keyboard", "keystroke")
	var/wired_connection = FALSE // Whether or not this console will start with a wired connection beneath it.

/obj/machinery/computer/modular/Initialize()
	set_extension(src, /datum/extension/interactive/os/console)
	. = ..()

/obj/machinery/computer/modular/populate_parts(full_populate)
	. = ..()
	if(full_populate && wired_connection)
		install_component(/obj/item/stock_parts/computer/lan_port, FALSE)

/obj/machinery/computer/modular/Process()
	if(stat & NOPOWER)
		return
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		os.Process()

/obj/machinery/computer/modular/power_change()
	. = ..()
	if(. && (stat & NOPOWER))
		var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
		if(os)
			os.event_powerfailure()
			os.system_shutdown()

/obj/machinery/computer/modular/interface_interact(mob/user)
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		if(!os.on)
			if(!CanInteract(user, DefaultTopicState()))
				return FALSE // Do full interactivity check before state change.
			os.system_boot()

		os.ui_interact(user)
	return TRUE

/obj/machinery/computer/modular/get_screen_overlay()
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		return os.get_screen_overlay()

/obj/machinery/computer/modular/get_keyboard_overlay()
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		return os.get_keyboard_overlay()

/obj/machinery/computer/modular/emag_act(var/remaining_charges, var/mob/user)
	var/obj/item/stock_parts/circuitboard/modular_computer/MB = get_component_of_type(/obj/item/stock_parts/circuitboard/modular_computer)
	return MB && MB.emag_act(remaining_charges, user)

/obj/machinery/computer/modular/components_are_accessible(var/path)
	. = ..()
	if(.)
		return
	if(!ispath(path, /obj/item/stock_parts/computer))
		return FALSE
	var/obj/item/stock_parts/computer/P = path
	return initial(P.external_slot)

/obj/machinery/computer/modular/CouldUseTopic(var/mob/user)
	..()
	if(LAZYLEN(interact_sounds) && CanPhysicallyInteract(user))
		playsound(src, pick(interact_sounds), 40)

/obj/machinery/computer/modular/RefreshParts()
	..()
	var/extra_power = 0
	for(var/obj/item/stock_parts/computer/part in component_parts)
		if(part.enabled)
			extra_power += part.power_usage
	change_power_consumption(initial(active_power_usage) + extra_power, POWER_USE_ACTIVE)

/obj/machinery/computer/modular/CtrlAltClick(mob/user)
	if(!CanPhysicallyInteract(user))
		return
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		os.open_terminal(user)

/obj/machinery/computer/modular/verb/emergency_shutdown()
	set name = "Forced Shutdown"
	set category = "Object"
	set src in view(1)

	if(!CanPhysicallyInteract(usr))
		return

	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os && os.on)
		to_chat(usr, "You press a hard-reset button on \the [src].")
		os.system_shutdown()