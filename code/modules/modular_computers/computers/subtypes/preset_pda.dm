/obj/item/modular_computer/pda
	default_hardware = list(
		/obj/item/stock_parts/computer/network_card,
		/obj/item/stock_parts/computer/hard_drive/small,
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/card_slot/broadcaster,
		/obj/item/stock_parts/computer/charge_stick_slot/broadcaster,
		/obj/item/stock_parts/computer/battery_module,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/drive_slot
	)

	default_programs = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/records
	)

/obj/item/modular_computer/pda/install_default_programs()
	if(prob(50)) //harmless tax software
		default_programs |= /datum/computer_file/program/uplink
	return ..()

/obj/item/modular_computer/pda/medical/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/medical
	return ..()

/obj/item/modular_computer/pda/chemistry/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/reagent
	return ..()

/obj/item/modular_computer/pda/engineering/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/atmos
	return ..()

/obj/item/modular_computer/pda/science/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/reagent
	return ..()

/obj/item/modular_computer/pda/forensics/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/reagent
	return ..()

/obj/item/modular_computer/pda/heads/install_default_programs()
	default_programs |= /datum/computer_file/program/reports
	return ..()

/obj/item/modular_computer/pda/heads/hop/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/paper
	return ..()

/obj/item/modular_computer/pda/heads/hos/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/paper
	return ..()

/obj/item/modular_computer/pda/heads/ce/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/atmos
	return ..()

/obj/item/modular_computer/pda/heads/cmo/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/medical
	return ..()

/obj/item/modular_computer/pda/heads/rd/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/paper
	return ..()

/obj/item/modular_computer/pda/cargo/install_default_programs()
	default_programs |= /datum/computer_file/program/reports
	return ..()

/obj/item/modular_computer/pda/cargo/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/paper
	return ..()

/obj/item/modular_computer/pda/mining/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/atmos
	return ..()

/obj/item/modular_computer/pda/explorer/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/atmos
	return ..()

/obj/item/modular_computer/pda/captain/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/paper
	return ..()