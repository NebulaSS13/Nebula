/datum/extension/interactive/ntos/device
	expected_type = /obj/item/modular_computer

/datum/extension/interactive/ntos/device/host_status()
	if(holder)
		var/datum/extension/assembly/assembly = get_extension(holder, /datum/extension/assembly)
		return assembly && assembly.enabled

/datum/extension/interactive/ntos/device/get_hardware_flag()
	if(holder)
		var/datum/extension/assembly/modular_computer/assembly = get_extension(holder, /datum/extension/assembly)
		return assembly && assembly.hardware_flag

/datum/extension/interactive/ntos/device/get_power_usage()
	if(holder)
		var/datum/extension/assembly/modular_computer/assembly = get_extension(holder, /datum/extension/assembly)
		return assembly && assembly.last_power_usage

/datum/extension/interactive/ntos/device/recalc_power_usage()
	if(holder)
		var/datum/extension/assembly/modular_computer/assembly = get_extension(holder, /datum/extension/assembly)
		return assembly && assembly.calculate_power_usage()

/datum/extension/interactive/ntos/device/emagged()
	var/obj/item/modular_computer/C = holder
	return C.computer_emagged

/datum/extension/interactive/ntos/device/system_shutdown()
	..()
	if(holder)
		var/datum/extension/assembly/modular_computer/assembly = get_extension(holder, /datum/extension/assembly)
		if(assembly && assembly.enabled) 
			assembly.shutdown_device()

/datum/extension/interactive/ntos/device/system_boot()
	..()
	if(holder)
		var/datum/extension/assembly/modular_computer/assembly = get_extension(holder, /datum/extension/assembly)
		return assembly && assembly.turn_on()

/datum/extension/interactive/ntos/device/extension_act(href, href_list, user)
	. = ..()
	var/obj/item/modular_computer/C = holder
	if(istype(C) && LAZYLEN(C.interact_sounds) && CanPhysicallyInteractWith(user, C))
		playsound(C, pick(C.interact_sounds), 40)

// Hack to make status bar work

/obj/item/modular_computer/initial_data()
	. = ..()
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		. += os.get_header_data()

/obj/item/modular_computer/check_eye()
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		return os.check_eye()
	else
		return ..()
