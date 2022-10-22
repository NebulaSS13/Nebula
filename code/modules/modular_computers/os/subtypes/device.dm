/datum/extension/interactive/os/device
	expected_type = /obj/item/modular_computer

/datum/extension/interactive/os/device/host_status()
	if(holder)
		var/datum/extension/assembly/assembly = get_extension(holder, /datum/extension/assembly)
		return assembly && assembly.enabled

/datum/extension/interactive/os/device/get_hardware_flag()
	if(holder)
		var/datum/extension/assembly/modular_computer/assembly = get_extension(holder, /datum/extension/assembly)
		return assembly && assembly.hardware_flag

/datum/extension/interactive/os/device/get_power_usage()
	if(holder)
		var/datum/extension/assembly/modular_computer/assembly = get_extension(holder, /datum/extension/assembly)
		return assembly && assembly.last_power_usage

/datum/extension/interactive/os/device/recalc_power_usage()
	if(holder)
		var/datum/extension/assembly/modular_computer/assembly = get_extension(holder, /datum/extension/assembly)
		return assembly && assembly.calculate_power_usage()

/datum/extension/interactive/os/device/emagged()
	var/obj/item/modular_computer/C = holder
	return C.computer_emagged

/datum/extension/interactive/os/device/system_shutdown()
	..()
	if(holder)
		var/datum/extension/assembly/modular_computer/assembly = get_extension(holder, /datum/extension/assembly)
		if(assembly && assembly.enabled)
			assembly.shutdown_device()

/datum/extension/interactive/os/device/extension_act(href, href_list, user)
	. = ..()
	var/obj/item/modular_computer/C = holder
	if(istype(C) && LAZYLEN(C.interact_sounds) && CanPhysicallyInteractWith(user, C))
		playsound(C, pick(C.interact_sounds), 40)

// Hack to make status bar work

/obj/item/modular_computer/initial_data()
	. = ..()
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		. += os.get_header_data()

/obj/item/modular_computer/check_eye(user)
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		return os.check_eye(user)
	return ..()
