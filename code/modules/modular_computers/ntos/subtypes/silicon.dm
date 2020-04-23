/datum/extension/interactive/ntos/silicon
	expected_type = /mob/living/silicon

/datum/extension/interactive/ntos/silicon/update_host_icon()
	return

/datum/extension/interactive/ntos/silicon/get_hardware_flag()
	return PROGRAM_CONSOLE

/datum/extension/interactive/ntos/silicon/get_component(var/part_type)
	var/mob/living/silicon/M = holder
	return locate(part_type) in M.stock_parts

/datum/extension/interactive/ntos/silicon/get_all_components()
	var/mob/living/silicon/M = holder
	return M.stock_parts.Copy()

/datum/extension/interactive/ntos/silicon/emagged()
	var/mob/living/silicon/robot/R = holder
	if(istype(R))
		return R.emagged
	return FALSE

/datum/extension/interactive/ntos/silicon/host_status()
	var/mob/living/silicon/M = holder
	return !M.stat

// Hack to make status bar work

/mob/living/silicon/initial_data()
	. = ..()
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		. += os.get_header_data()

/mob/living/silicon/check_eye()
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		return os.check_eye()
	else 
		return ..()

/datum/extension/interactive/ntos/silicon/small/get_hardware_flag()
	return PROGRAM_TABLET
