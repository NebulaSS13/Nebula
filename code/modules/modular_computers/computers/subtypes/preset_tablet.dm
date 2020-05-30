//Loadout
/obj/item/modular_computer/tablet/preset/custom_loadout/cheap
	default_hardware = list(
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/hard_drive/micro,
		/obj/item/stock_parts/computer/network_card,
		/obj/item/stock_parts/computer/battery_module/nano,
		/obj/item/stock_parts/computer/drive_slot
	)

/obj/item/modular_computer/tablet/preset/custom_loadout/advanced
	default_hardware = list(
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/hard_drive/small,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/battery_module,
		/obj/item/stock_parts/computer/drive_slot
	)

/obj/item/modular_computer/tablet/preset/custom_loadout/standard
	default_hardware = list(
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/hard_drive/small,
		/obj/item/stock_parts/computer/network_card,
		/obj/item/stock_parts/computer/battery_module/micro,
		/obj/item/stock_parts/computer/drive_slot
	)
//Map presets

/obj/item/modular_computer/tablet/lease/preset/command/install_default_hardware()
	default_hardware = list(
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/hard_drive,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/battery_module,
		/obj/item/stock_parts/computer/scanner/paper,
		/obj/item/stock_parts/computer/drive_slot
	)

/obj/item/modular_computer/tablet/lease/preset
	default_programs = list(
		/datum/computer_file/program/reports,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/records,
		/datum/computer_file/program/wordprocessor
	)