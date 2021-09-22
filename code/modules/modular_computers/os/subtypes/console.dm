/datum/extension/interactive/os/console
	expected_type = /obj/machinery
	screen_icon_file = 'icons/obj/modular_computers/modular_console.dmi'

/datum/extension/interactive/os/console/get_hardware_flag()
	return PROGRAM_CONSOLE

/datum/extension/interactive/os/console/get_component(var/part_type)
	var/obj/machinery/M = holder
	if(ispath(part_type, PART_DRIVE))
		return ..()	//special handling for removable disks
	return M.get_component_of_type(part_type)

/datum/extension/interactive/os/console/get_all_components()
	var/obj/machinery/M = holder
	return M.component_parts.Copy()

/datum/extension/interactive/os/console/get_power_usage()
	var/obj/machinery/M = holder
	return M.get_power_usage()

/datum/extension/interactive/os/console/recalc_power_usage()
	var/obj/machinery/M = holder
	M.RefreshParts()

/datum/extension/interactive/os/console/emagged()
	var/obj/machinery/M = holder
	var/obj/item/stock_parts/circuitboard/modular_computer/MB = M.get_component_of_type(/obj/item/stock_parts/circuitboard/modular_computer)
	return MB && MB.emagged

/datum/extension/interactive/os/console/system_boot()
	..()
	var/obj/machinery/M = holder
	M.update_use_power(POWER_USE_ACTIVE)

/datum/extension/interactive/os/console/system_shutdown()
	..()
	var/obj/machinery/M = holder
	M.update_use_power(POWER_USE_IDLE)

/datum/extension/interactive/os/console/host_status()
	var/obj/machinery/M = holder
	return !(M.stat & NOPOWER)

/datum/extension/interactive/os/console/extension_act(href, href_list, user)
	. = ..()
	var/obj/machinery/M = holder
	if(istype(M) && M.clicksound && CanPhysicallyInteractWith(user, M))
		playsound(M, M.clicksound, 40)

// Hack to make status bar work

/obj/machinery/initial_data()
	. = ..()
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		. += os.get_header_data()

/obj/machinery/check_eye(user)
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		return os.check_eye(user)
	else
		return ..()