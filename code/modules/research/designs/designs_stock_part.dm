/datum/design/item/stock_part
	build_type = PROTOLATHE

/datum/design/item/stock_part/ModifyDesignName()
	name = "Component design ([name])"

/datum/design/item/stock_part/AssembleDesignDesc()
	if(!desc)
		desc = "A stock part used in the construction of various devices."

/datum/design/item/stock_part/basic_capacitor
	req_tech = list(TECH_POWER = 1)
	build_path = /obj/item/stock_parts/capacitor

/datum/design/item/stock_part/adv_capacitor
	req_tech = list(TECH_POWER = 3)
	build_path = /obj/item/stock_parts/capacitor/adv

/datum/design/item/stock_part/super_capacitor
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/stock_parts/capacitor/super

/datum/design/item/stock_part/micro_mani
	req_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	build_path = /obj/item/stock_parts/manipulator

/datum/design/item/stock_part/nano_mani
	req_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	build_path = /obj/item/stock_parts/manipulator/nano

/datum/design/item/stock_part/pico_mani
	req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	build_path = /obj/item/stock_parts/manipulator/pico

/datum/design/item/stock_part/basic_matter_bin
	req_tech = list(TECH_MATERIAL = 1)
	build_path = /obj/item/stock_parts/matter_bin

/datum/design/item/stock_part/adv_matter_bin
	req_tech = list(TECH_MATERIAL = 3)
	build_path = /obj/item/stock_parts/matter_bin/adv

/datum/design/item/stock_part/super_matter_bin
	req_tech = list(TECH_MATERIAL = 5)
	build_path = /obj/item/stock_parts/matter_bin/super

/datum/design/item/stock_part/basic_micro_laser
	req_tech = list(TECH_MAGNET = 1)
	build_path = /obj/item/stock_parts/micro_laser

/datum/design/item/stock_part/high_micro_laser
	req_tech = list(TECH_MAGNET = 3)
	build_path = /obj/item/stock_parts/micro_laser/high

/datum/design/item/stock_part/ultra_micro_laser
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	build_path = /obj/item/stock_parts/micro_laser/ultra

/datum/design/item/stock_part/basic_sensor
	req_tech = list(TECH_MAGNET = 1)
	build_path = /obj/item/stock_parts/scanning_module

/datum/design/item/stock_part/adv_sensor
	req_tech = list(TECH_MAGNET = 3)
	build_path = /obj/item/stock_parts/scanning_module/adv

/datum/design/item/stock_part/phasic_sensor
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	build_path = /obj/item/stock_parts/scanning_module/phasic

/datum/design/item/stock_part/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/storage/part_replacer

/datum/design/item/stock_part/RPED_BS
	name = "bluespace Rapid Part Exchange Device"
	desc = "Powered by bluespace technology, this RPED variant can upgrade buildings from a distance, without needing to remove the panel first."
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 4)
	build_path = /obj/item/storage/part_replacer/bluespace

/datum/design/item/stock_part/subspace_ansible
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/stock_parts/subspace/ansible

/datum/design/item/stock_part/hyperwave_filter
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3)
	build_path = /obj/item/stock_parts/subspace/filter

/datum/design/item/stock_part/subspace_amplifier
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/stock_parts/subspace/amplifier

/datum/design/item/stock_part/subspace_treatment
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/stock_parts/subspace/treatment

/datum/design/item/stock_part/subspace_analyzer
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/stock_parts/subspace/analyzer

/datum/design/item/stock_part/subspace_crystal
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/stock_parts/subspace/crystal

/datum/design/item/stock_part/subspace_transmitter
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	build_path = /obj/item/stock_parts/subspace/transmitter
