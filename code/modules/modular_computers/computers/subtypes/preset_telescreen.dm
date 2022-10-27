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
		for(var/program_type in default_software)
			os.store_file(new program_type())
		if(autorun_program)
			os.set_autorun(initial(autorun_program.filename))

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