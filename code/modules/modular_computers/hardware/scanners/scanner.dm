//This is the generic parent class, which doesn't actually do anything.

/obj/item/stock_parts/computer/scanner
	name = "scanner module"
	desc = "A generic scanner module. This one doesn't seem to do anything."
	power_usage = 50
	icon_state = "printer"
	hardware_size = 1
	critical = 0
	origin_tech = @'{"programming":2,"engineering":2}'

	var/datum/computer_file/program/scanner/driver_type = /datum/computer_file/program/scanner		// A program type that the scanner interfaces with and attempts to install on insertion.
	var/datum/computer_file/program/scanner/driver		 		// A driver program which has been set up to interface with the scanner.
	var/can_run_scan = 0	//Whether scans can be run from the program directly.
	var/can_view_scan = 1	//Whether the scan output can be viewed in the program.
	var/can_save_scan = 1	//Whether the scan output can be saved to disk.

/obj/item/stock_parts/computer/scanner/Destroy()
	do_before_uninstall()
	. = ..()

/obj/item/stock_parts/computer/scanner/do_after_install(atom/device, loud)
	var/datum/extension/interactive/os/os = get_extension(device, /datum/extension/interactive/os)
	if(!driver_type || !device || !os)
		return 0
	if(!os.has_component(PART_HDD))
		if(loud)
			device.visible_message(SPAN_WARNING("\The [device] flashes an error: Driver installation for \the [src] failed. Could not locate hard drive."))
		return 0
	var/datum/computer_file/program/scanner/old_driver = os.get_file(initial(driver_type.filename), OS_PROGRAMS_DIR)
	if(istype(old_driver))
		if(loud)
			device.visible_message(SPAN_NOTICE("\The [device] pings: Drivers located for \the [src]. Installation complete."))
		old_driver.connect_scanner()
		return 1
	var/datum/computer_file/program/scanner/driver_file = new driver_type
	if(!os.store_file(driver_file, OS_PROGRAMS_DIR, create_directories = TRUE))
		if(loud)
			device.visible_message(SPAN_WARNING("\The [device] flashes an error: Driver installation for \the [src] failed. Could not write to the hard drive."))
		return 0
	driver_file.computer = os
	driver_file.connect_scanner()
	if(loud)
		device.visible_message(SPAN_NOTICE("\The [device] pings: Driver installation for \the [src] complete."))
	return 1

/obj/item/stock_parts/computer/scanner/do_before_uninstall(atom/device, loud)
	if(driver)
		driver.disconnect_scanner()
	if(driver)	//In case the driver doesn't find it.
		driver = null

/obj/item/stock_parts/computer/scanner/proc/run_scan(mob/user, datum/computer_file/program/scanner/program) //For scans done from the software.

/obj/item/stock_parts/computer/scanner/proc/do_on_afterattack(mob/user, atom/target, proximity)

/obj/item/stock_parts/computer/scanner/attackby(obj/used_item, mob/user)
	return do_on_attackby(user, used_item)

/// Returns TRUE if the attackby chain should be stopped.
/obj/item/stock_parts/computer/scanner/proc/do_on_attackby(mob/user, atom/target)
	return FALSE

/obj/item/stock_parts/computer/scanner/proc/can_use_scanner(mob/user, atom/target, proximity = TRUE)
	if(!check_functionality())
		return 0
	if(user.incapacitated())
		return 0
	if(!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS))
		return 0
	if(!proximity)
		return 0
	return 1