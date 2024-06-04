// This device is wrapper for actual power cell. I have decided to not use power cells directly as even low-end cells available on station
// have tremendeous capacity in comparsion. Higher tier cells would provide your device with nearly infinite battery life, which is something i want to avoid.
/obj/item/stock_parts/computer/battery_module
	name = "standard battery"
	desc = "A standard power cell, commonly seen in high-end portable microcomputers or low-end laptops. It's rating is 75 Wh."
	icon_state = "battery_normal"
	critical = 1
	origin_tech = @'{"powerstorage":1,"engineering":1}'
	material = /decl/material/solid/metal/steel
	var/battery_rating = 75

/obj/item/stock_parts/computer/battery_module/Initialize()
	. = ..()
	setup_power_supply()
	charge_to_full()

/obj/item/stock_parts/computer/battery_module/diagnostics()
	. = ..()
	var/obj/item/cell/battery = get_cell()
	if(battery)
		. += "Internal battery charge: [battery.charge]/[battery.maxcharge] CU"

/obj/item/stock_parts/computer/battery_module/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	loaded_cell_type = loaded_cell_type || /obj/item/cell
	. = ..(loaded_cell_type, /obj/item/cell, /datum/extension/loaded_cell/unremovable, charge_value)
	var/obj/item/cell/battery = get_cell()
	if(battery)
		battery.maxcharge = battery_rating
		battery.charge = 0

/obj/item/stock_parts/computer/battery_module/proc/charge_to_full()
	var/obj/item/cell/battery = get_cell()
	if(battery)
		battery.charge = battery.maxcharge

/obj/item/stock_parts/computer/battery_module/advanced
	name = "advanced battery"
	desc = "An advanced power cell, often used in most laptops. It is too large to be fitted into smaller devices. It's rating is 110 Wh."
	icon_state = "battery_advanced"
	origin_tech = @'{"powerstorage":2,"engineering":2}'
	hardware_size = 2
	battery_rating = 110
	material = /decl/material/solid/metal/steel

/obj/item/stock_parts/computer/battery_module/super
	name = "super battery"
	desc = "A very advanced power cell, often used in high-end devices, or as uninterruptable power supply for important consoles or servers. It's rating is 150 Wh."
	icon_state = "battery_super"
	origin_tech = @'{"powerstorage":3,"engineering":3}'
	hardware_size = 2
	battery_rating = 150
	material = /decl/material/solid/metal/steel

/obj/item/stock_parts/computer/battery_module/ultra
	name = "ultra battery"
	desc = "A very advanced large power cell. It's often used as uninterruptable power supply for critical consoles or servers. It's rating is 200 Wh."
	icon_state = "battery_ultra"
	origin_tech = @'{"powerstorage":5,"engineering":4}'
	hardware_size = 3
	battery_rating = 200
	material = /decl/material/solid/metal/steel

/obj/item/stock_parts/computer/battery_module/micro
	name = "micro battery"
	desc = "A small power cell, commonly seen in most portable microcomputers. It's rating is 50 Wh."
	icon_state = "battery_micro"
	origin_tech = @'{"powerstorage":2,"engineering":2}'
	battery_rating = 50
	material = /decl/material/solid/metal/steel

/obj/item/stock_parts/computer/battery_module/nano
	name = "nano battery"
	desc = "A tiny power cell, commonly seen in low-end portable microcomputers. It's rating is 30 Wh."
	icon_state = "battery_nano"
	battery_rating = 30
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"powerstorage":2,"engineering":1}'

// This is not intended to be obtainable in-game. Intended for adminbus and debugging purposes.
/obj/item/stock_parts/computer/battery_module/lambda
	name = "lambda coil"
	desc = "A very complex power source compatible with various computers. It is capable of providing power for nearly unlimited duration."
	icon_state = "battery_lambda"
	hardware_size = 1
	battery_rating = 3000

/obj/item/stock_parts/computer/battery_module/lambda/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	return ..(/obj/item/cell/infinite, accepted_cell_type, power_supply_extension_type, charge_value)
