//////////////////////////////////////////////////////////////////
// Telescreen Preset
//////////////////////////////////////////////////////////////////

/obj/machinery/computer/modular/telescreen/preset
	base_type = /obj/machinery/computer/modular/telescreen
	uncreated_component_parts = list(
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/hard_drive,
		/obj/item/stock_parts/computer/network_card,
		/obj/item/stock_parts/computer/card_slot,
	)
	var/list/default_software
	var/datum/computer_file/program/autorun_program

/obj/machinery/computer/modular/telescreen/preset/Initialize(mapload, d=0, populate_parts = TRUE)
	. = ..()
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		//#TODO: Maybe that file system stuff should really handle this a bit better so we don't have to mess with internals like that?
		// We access the harddrive directly because the filesystem is yet to be initialized.
		var/obj/item/stock_parts/computer/hard_drive/HDD = os.get_component(PART_HDD)
		if(!HDD)
			log_warning("Telescreen preset '[type]' doesn't have a hard drive! This is most likely not desired.")
			return .
		for(var/program_type in default_software)
			HDD.store_file(new program_type(), OS_PROGRAMS_DIR, create_directories = TRUE)
		if(autorun_program)
			var/datum/computer_file/data/autorun = new()
			autorun.filename = "autorun"
			autorun.stored_data = initial(autorun_program.filename)
			HDD.store_file(autorun)

//////////////////////////////////////////////////////////////////
// Pressets
//////////////////////////////////////////////////////////////////

/obj/machinery/computer/modular/telescreen/preset/supply_public
	default_software = list(
		/datum/computer_file/program/supply,
	)
	autorun_program = /datum/computer_file/program/supply

/obj/machinery/computer/modular/telescreen/preset/civilian
	default_software = list(
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor
	)

/obj/machinery/computer/modular/telescreen/preset/generic
	default_software = list(
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/camera_monitor
	)

/obj/machinery/computer/modular/telescreen/preset/medical
	default_software = list(
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records,
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/wordprocessor
	)

/obj/machinery/computer/modular/telescreen/preset/engineering
	default_software = list(
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/shields_monitor,
		/datum/computer_file/program/supermatter_monitor
	)

/obj/machinery/computer/modular/telescreen/preset/entertainment
	default_software = list(
		/datum/computer_file/program/camera_monitor
	)
	autorun_program = /datum/computer_file/program/camera_monitor

/obj/machinery/computer/modular/telescreen/preset/security
	default_software = list(
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records,
		/datum/computer_file/program/forceauthorization,
		/datum/computer_file/program/wordprocessor
	)
	autorun_program = /datum/computer_file/program/camera_monitor
