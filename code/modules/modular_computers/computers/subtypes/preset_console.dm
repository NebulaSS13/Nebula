/obj/machinery/computer/modular/preset
	var/list/default_software
	var/datum/computer_file/program/autorun_program
	/// Mounts the mainframe with the corresponding key as its ID to the root directory named after the value.
	/// Ex. list("RECORDS_MAINFRAME" = "records")
	var/automount_disks
	base_type = /obj/machinery/computer/modular

/obj/machinery/computer/modular/preset/full
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/ai_slot,
		)

/obj/machinery/computer/modular/preset/aislot
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/computer/ai_slot
		)

/obj/machinery/computer/modular/preset/cardslot
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/computer/card_slot
		)

/obj/machinery/computer/modular/preset/Initialize()
	. = ..()
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		// We access the harddrive directly because the filesystem is yet to be initialized.
		var/obj/item/stock_parts/computer/hard_drive/HDD = os.get_component(PART_HDD)
		for(var/program_type in default_software)
			HDD.store_file(new program_type(), OS_PROGRAMS_DIR, create_directories = TRUE)
		if(autorun_program)
			var/datum/computer_file/data/autorun = new()
			autorun.filename = "autorun"
			autorun.stored_data = initial(autorun_program.filename)
			HDD.store_file(autorun)
		if(LAZYLEN(automount_disks))
			var/datum/computer_file/data/automount = new()
			automount.filename = "automount"
			for(var/disk in automount_disks)
				automount.stored_data += "[automount_disks[disk]]|[disk];"
			HDD.store_file(automount)

/obj/machinery/computer/modular/preset/engineering
	default_software = list(
		/datum/computer_file/program/power_monitor,
		/datum/computer_file/program/supermatter_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmos_control,
		/datum/computer_file/program/rcon_console,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/shields_monitor
	)

/obj/machinery/computer/modular/preset/engineering/power
	default_software = list(
		/datum/computer_file/program/power_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/wordprocessor
	)
	autorun_program = /datum/computer_file/program/power_monitor

/obj/machinery/computer/modular/preset/engineering/rcon
	default_software = list(
		/datum/computer_file/program/rcon_console,
		/datum/computer_file/program/wordprocessor
	)
	autorun_program = /datum/computer_file/program/rcon_console

/obj/machinery/computer/modular/preset/engineering/atmospherics
	default_software = list(
		/datum/computer_file/program/atmos_control,
		/datum/computer_file/program/shutoff_valve,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/wordprocessor
	)
	autorun_program = /datum/computer_file/program/shutoff_valve

/obj/machinery/computer/modular/preset/medical
	default_software = list(
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records,
		/datum/computer_file/program/wordprocessor
	)
	autorun_program = /datum/computer_file/program/suit_sensors

/obj/machinery/computer/modular/preset/aislot/research
	default_software = list(
		/datum/computer_file/program/network_monitor,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/aidiag,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor
	)

/obj/machinery/computer/modular/preset/aislot/sysadmin
	default_software = list(
		/datum/computer_file/program/network_monitor,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/aidiag,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/email_administration,
		/datum/computer_file/program/records,
		/datum/computer_file/program/wordprocessor
	)

/obj/machinery/computer/modular/preset/cardslot/command
	default_software = list(
		/datum/computer_file/program/comm,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/records,
		/datum/computer_file/program/docking,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/accounts
	)

/obj/machinery/computer/modular/preset/cardslot/personnel
	default_software = list(
		/datum/computer_file/program/card_mod,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/records,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/accounts
	)

/obj/machinery/computer/modular/preset/security
	default_software = list(
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records,
		/datum/computer_file/program/forceauthorization,
		/datum/computer_file/program/wordprocessor
	)

/obj/machinery/computer/modular/preset/civilian
	default_software = list(
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/supply,
		/datum/computer_file/program/wordprocessor
	)

/obj/machinery/computer/modular/preset/dock
	default_software = list(
		/datum/computer_file/program/reports,
		/datum/computer_file/program/records,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/supply,
		/datum/computer_file/program/docking
	)

/obj/machinery/computer/modular/preset/supply_public
	default_software = list(
		/datum/computer_file/program/supply
	)
	autorun_program = /datum/computer_file/program/supply

/obj/machinery/computer/modular/preset/full/ert
	default_software = list(
		/datum/computer_file/program/camera_monitor/ert,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/comm,
		/datum/computer_file/program/aidiag,
		/datum/computer_file/program/records,
		/datum/computer_file/program/wordprocessor
	)

/obj/machinery/computer/modular/preset/full/merc
	default_software = list(
		/datum/computer_file/program/camera_monitor/hacked,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/aidiag
	)

/obj/machinery/computer/modular/preset/full/merc/Initialize()
	. = ..()
	emag_act(INFINITY)

/obj/machinery/computer/modular/preset/merchant
	default_software = list(
		/datum/computer_file/program/merchant,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor
	)
