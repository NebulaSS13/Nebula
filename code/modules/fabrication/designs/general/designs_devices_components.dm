/datum/fabricator_recipe/device_component
	path = /obj/item/stock_parts/console_screen
	category = "Devices and Components"

/datum/fabricator_recipe/device_component/keyboard
	path = /obj/item/stock_parts/keyboard

/datum/fabricator_recipe/device_component/tesla_component
	path = /obj/item/stock_parts/power/apc/buildable

/datum/fabricator_recipe/device_component/radio_transmitter
	path = /obj/item/stock_parts/radio/transmitter/basic/buildable

/datum/fabricator_recipe/device_component/radio_transmitter_event
	path = /obj/item/stock_parts/radio/transmitter/on_event/buildable

/datum/fabricator_recipe/device_component/radio_receiver
	path = /obj/item/stock_parts/radio/receiver/buildable

/datum/fabricator_recipe/device_component/battery_backup_crap
	name = "battery backup (weak)"
	path = /obj/item/stock_parts/power/battery/buildable/crap

/datum/fabricator_recipe/device_component/battery_backup_stock
	name = "battery backup (standard)"
	path = /obj/item/stock_parts/power/battery/buildable/stock

/datum/fabricator_recipe/device_component/battery_backup_turbo
	name = "battery backup (rapid)"
	path = /obj/item/stock_parts/power/battery/buildable/turbo

/datum/fabricator_recipe/device_component/battery_backup_responsive
	name = "battery backup (responsive)"
	path = /obj/item/stock_parts/power/battery/buildable/responsive

/datum/fabricator_recipe/device_component/terminal
	path = /obj/item/stock_parts/power/terminal/buildable

/datum/fabricator_recipe/device_component/access_lock
	path = /obj/item/stock_parts/access_lock/buildable

/datum/fabricator_recipe/device_component/igniter
	path = /obj/item/assembly/igniter

/datum/fabricator_recipe/device_component/signaler
	path = /obj/item/assembly/signaler

/datum/fabricator_recipe/device_component/sensor_infra
	path = /obj/item/assembly/infra

/datum/fabricator_recipe/device_component/timer
	path = /obj/item/assembly/timer

/datum/fabricator_recipe/device_component/sensor_prox
	path = /obj/item/assembly/prox_sensor

/datum/fabricator_recipe/device_component/cable_coil
	path = /obj/item/stack/cable_coil/single

/datum/fabricator_recipe/device_component/beartrap
	path = /obj/item/beartrap
	hidden = TRUE

/datum/fabricator_recipe/device_component/cell_device
	path = /obj/item/cell/device/standard

/datum/fabricator_recipe/device_component/ecigcartridge
	path = /obj/item/chems/ecig_cartridge/blank

/datum/fabricator_recipe/device_component/conveyor_construct
	path = /obj/item/conveyor_construct

/datum/fabricator_recipe/device_component/conveyor_switch_construct
	path = /obj/item/conveyor_switch_construct

/datum/fabricator_recipe/device_component/conveyor_switch_oneway_construct
	path = /obj/item/conveyor_switch_construct/oneway

/datum/fabricator_recipe/device_component/fusebox
	path = /obj/item/stock_parts/shielding/electric

/datum/fabricator_recipe/device_component/armor
	path = /obj/item/stock_parts/shielding/kinetic

/datum/fabricator_recipe/device_component/heatsink
	path = /obj/item/stock_parts/shielding/heat

/datum/fabricator_recipe/device_component/comp_accessory
	category = "Computer Components"
	path = /obj/item/stock_parts/computer/ai_slot

/datum/fabricator_recipe/device_component/comp_accessory/get_product_name()
	. = "computer accessory ([..()])"

/datum/fabricator_recipe/device_component/comp_accessory/comp_cpu
	category = "CPU Designs"
	path = /obj/item/stock_parts/computer/processor_unit

/datum/fabricator_recipe/device_component/comp_accessory/comp_cpu/get_product_name()
	. = "CPU design ([..()])"

/datum/fabricator_recipe/device_component/comp_accessory/comp_cpu/small
	path = /obj/item/stock_parts/computer/processor_unit/small

/datum/fabricator_recipe/device_component/comp_accessory/comp_cpu/photonic
	path = /obj/item/stock_parts/computer/processor_unit/photonic

/datum/fabricator_recipe/device_component/comp_accessory/comp_cpu/photonic/small
	path = /obj/item/stock_parts/computer/processor_unit/photonic/small