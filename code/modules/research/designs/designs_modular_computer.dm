// Drives
/datum/design/item/modularcomponent/disk/ModifyDesignName()
	name = "Hard drive design ([name])"

/datum/design/item/modularcomponent/disk/normal
	name = "basic hard drive"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/hard_drive/

/datum/design/item/modularcomponent/disk/advanced
	name = "advanced hard drive"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/hard_drive/advanced

/datum/design/item/modularcomponent/disk/super
	name = "super hard drive"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/hard_drive/super

/datum/design/item/modularcomponent/disk/cluster
	name = "cluster hard drive"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/hard_drive/cluster

/datum/design/item/modularcomponent/disk/micro
	name = "micro hard drive"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/hard_drive/micro

/datum/design/item/modularcomponent/disk/small
	name = "small hard drive"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/hard_drive/small

// Network cards
/datum/design/item/modularcomponent/netcard/ModifyDesignName()
	name = "Network card design ([name])"

/datum/design/item/modularcomponent/netcard/basic
	name = "basic network card"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = IMPRINTER
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/network_card

/datum/design/item/modularcomponent/netcard/advanced
	name = "advanced network card"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/network_card/advanced

/datum/design/item/modularcomponent/netcard/wired
	name = "wired network card"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/network_card/wired

// Data crystals (USB flash drives)
/datum/design/item/modularcomponent/portabledrive/ModifyDesignName()
	name = "Portable drive design ([name])"

/datum/design/item/modularcomponent/portabledrive/basic
	name = "basic data crystal"
	req_tech = list(TECH_DATA = 1)
	build_type = IMPRINTER
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/hard_drive/portable

/datum/design/item/modularcomponent/portabledrive/advanced
	name = "advanced data crystal"
	req_tech = list(TECH_DATA = 2)
	build_type = IMPRINTER
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/hard_drive/portable/advanced

/datum/design/item/modularcomponent/portabledrive/super
	name = "super data crystal"
	req_tech = list(TECH_DATA = 4)
	build_type = IMPRINTER
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/hard_drive/portable/super

// Card slot
/datum/design/item/modularcomponent/accessory/ModifyDesignName()
	name = "Computer accessory ([name])"

/datum/design/item/modularcomponent/accessory/cardslot
	name = "RFID card slot"
	req_tech = list(TECH_DATA = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/card_slot

// Card Broadcaster
/datum/design/item/modularcomponent/accessory/cardbroadcaster
	name = "RFID card broadcaster"
	req_tech = list(TECH_DATA = 3)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/card_slot/broadcaster

// inteliCard Slot
/datum/design/item/modularcomponent/accessory/aislot
	name = "inteliCard slot"
	req_tech = list(TECH_POWER = 2, TECH_DATA = 3)
	build_type = IMPRINTER
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/ai_slot

// Nano printer
/datum/design/item/modularcomponent/accessory/nanoprinter
	name = "nano printer"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/nano_printer

// Tesla Link
/datum/design/item/modularcomponent/accessory/teslalink
	name = "tesla link"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/tesla_link

//Scanners
/datum/design/item/modularcomponent/accessory/reagent_scanner
	name = "reagent scanner module"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2, TECH_BIO = 2, TECH_MAGNET = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/scanner/reagent

/datum/design/item/modularcomponent/accessory/paper_scanner
	name = "paper scanner module"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/scanner/paper

/datum/design/item/modularcomponent/accessory/atmos_scanner
	name = "atmospheric scanner module"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2, TECH_MAGNET = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/scanner/atmos

/datum/design/item/modularcomponent/accessory/medical_scanner
	name = "medical scanner module"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2, TECH_MAGNET = 2, TECH_BIO = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/scanner/medical

// Batteries
/datum/design/item/modularcomponent/battery/ModifyDesignName()
	name = "Battery design ([name])"

/datum/design/item/modularcomponent/battery/normal
	name = "standard battery module"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/battery_module

/datum/design/item/modularcomponent/battery/advanced
	name = "advanced battery module"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/battery_module/advanced

/datum/design/item/modularcomponent/battery/super
	name = "super battery module"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/battery_module/super

/datum/design/item/modularcomponent/battery/ultra
	name = "ultra battery module"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/battery_module/ultra

/datum/design/item/modularcomponent/battery/nano
	name = "nano battery module"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/battery_module/nano

/datum/design/item/modularcomponent/battery/micro
	name = "micro battery module"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/stock_parts/computer/battery_module/micro

// Processor unit
/datum/design/item/modularcomponent/cpu/ModifyDesignName()
	name = "CPU design ([name])"

/datum/design/item/modularcomponent/cpu/
	name = "computer processor unit"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/processor_unit

/datum/design/item/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/processor_unit/small

/datum/design/item/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	chemicals = list(/datum/reagent/acid = 40)
	build_path = /obj/item/stock_parts/computer/processor_unit/photonic

/datum/design/item/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/processor_unit/photonic/small
