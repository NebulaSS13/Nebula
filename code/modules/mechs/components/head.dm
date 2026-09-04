/obj/item/mech_component/sensors
	name = "head"
	icon_state = "loader_head"
	gender = NEUTER
	has_hardpoints = list(HARDPOINT_HEAD)
	power_use = 15

	var/vision_flags = 0
	var/see_invisible = 0
	var/obj/item/robot_parts/robot_component/radio/radio
	var/obj/item/robot_parts/robot_component/camera
	var/obj/item/mech_component/control_module/software
	var/active_sensors = 0

/obj/item/mech_component/sensors/Destroy()
	QDEL_NULL(camera)
	QDEL_NULL(radio)
	QDEL_NULL(software)
	. = ..()

/obj/item/mech_component/sensors/show_missing_parts(var/mob/user)
	. = list()
	if(!radio)
		. += SPAN_WARNING("It is missing a radio.")
	if(!camera)
		. += SPAN_WARNING("It is missing a camera.")
	if(!software)
		. += SPAN_WARNING("It is missing a software control module.")

/obj/item/mech_component/sensors/prebuild()
	radio = new(src)
	camera = new(src)

/obj/item/mech_component/sensors/update_components()
	radio = locate() in src
	camera = locate() in src
	software = locate() in src

/obj/item/mech_component/sensors/proc/get_sight(powered)
	var/flags = 0
	if(total_damage >= 0.8 * max_damage || !powered)
		flags |= BLIND
	else if(active_sensors && powered)
		flags |= vision_flags

	return flags

/obj/item/mech_component/sensors/proc/get_invisible(powered)
	var/invisible = 0
	if((total_damage <= 0.8 * max_damage) && active_sensors && powered)
		invisible = see_invisible
	return invisible



/obj/item/mech_component/sensors/ready_to_install()
	return (radio && camera)

/obj/item/mech_component/sensors/attackby(var/obj/item/used_item, var/mob/user)
	if(istype(used_item, /obj/item/mech_component/control_module))
		if(software)
			to_chat(user, SPAN_WARNING("\The [src] already has a control modules installed."))
			return TRUE
		if(install_component(used_item, user))
			software = used_item
			return TRUE
		return FALSE
	else if(istype(used_item,/obj/item/robot_parts/robot_component/radio))
		if(radio)
			to_chat(user, SPAN_WARNING("\The [src] already has a radio installed."))
			return TRUE
		if(install_component(used_item, user))
			radio = used_item
			return TRUE
		return FALSE
	else if(istype(used_item,/obj/item/robot_parts/robot_component/camera))
		if(camera)
			to_chat(user, SPAN_WARNING("\The [src] already has a camera installed."))
			return TRUE
		if(install_component(used_item, user))
			camera = used_item
			return TRUE
		return FALSE
	else
		return ..()

/obj/item/mech_component/sensors/return_diagnostics(mob/user)
	..()
	if(software)
		to_chat(user, SPAN_NOTICE(" Installed Software"))
		for(var/exosystem_software in software.installed_software)
			to_chat(user, SPAN_NOTICE(" - <b>[capitalize(exosystem_software)]</b>"))
	else
		to_chat(user, SPAN_WARNING(" Control Module Missing or Non-functional."))
	if(radio)
		to_chat(user, SPAN_NOTICE(" Radio Integrity: <b>[round(radio.get_percent_health())]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Radio Missing or Non-functional."))
	if(camera)
		to_chat(user, SPAN_NOTICE(" Camera Integrity: <b>[round(camera.get_percent_health())]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Camera Missing or Non-functional."))

/obj/item/mech_component/control_module
	name = "exosuit control module"
	desc = "A clump of circuitry and software chip docks, used to program exosuits."
	icon_state = "control"
	icon = 'icons/mecha/mech_equipment.dmi'
	gender = NEUTER
	color = COLOR_WHITE
	material = /decl/material/solid/metal/steel
	var/list/installed_software = list()
	var/max_installed_software = 2

/obj/item/mech_component/control_module/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	. += SPAN_NOTICE("It has [max_installed_software - LAZYLEN(installed_software)] empty slot\s remaining out of [max_installed_software].")

/obj/item/mech_component/control_module/attackby(var/obj/item/used_item, var/mob/user)
	if(istype(used_item, /obj/item/stock_parts/circuitboard/exosystem))
		install_software(used_item, user)
		return TRUE

	if(IS_SCREWDRIVER(used_item))
		. = ..()
		update_software()
		return
	else
		return ..()

/obj/item/mech_component/control_module/proc/install_software(var/obj/item/stock_parts/circuitboard/exosystem/software, var/mob/user)
	if(installed_software.len >= max_installed_software)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] can only hold [max_installed_software] software modules."))
		return
	if(user && !user.try_unequip(software))
		return

	if(user)
		to_chat(user, SPAN_NOTICE("You load \the [software] into \the [src]'s memory."))

	software.forceMove(src)
	update_software()

/obj/item/mech_component/control_module/proc/update_software()
	installed_software = list()
	for(var/obj/item/stock_parts/circuitboard/exosystem/program in contents)
		installed_software |= program.contains_software
