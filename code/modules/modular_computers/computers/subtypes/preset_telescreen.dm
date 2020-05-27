/obj/item/modular_computer/telescreen/preset
	default_hardware = list(
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/hard_drive,
		/obj/item/stock_parts/computer/network_card
	)

/obj/item/modular_computer/telescreen/preset/generic
	default_programs = list(
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/camera_monitor
	)

/obj/item/modular_computer/telescreen/preset/medical
	default_programs = list(
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records,
		/datum/computer_file/program/suit_sensors
	)
/obj/item/modular_computer/telescreen/preset/engineering
	default_programs = list(
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/shields_monitor,
		/datum/computer_file/program/supermatter_monitor
	)
