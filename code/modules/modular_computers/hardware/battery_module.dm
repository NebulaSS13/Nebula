// This device is wrapper for actual power cell. I have decided to not use power cells directly as even low-end cells available on station
// have tremendeous capacity in comparsion. Higher tier cells would provide your device with nearly infinite battery life, which is something i want to avoid.
/obj/item/stock_parts/computer/battery_module
	name = "standard battery"
	desc = "A standard power cell, commonly seen in high-end portable microcomputers or low-end laptops. It's rating is 75 Wh."
	icon_state = "battery_normal"
	critical = 1
	origin_tech = "{'" + TECH_POWER + "':1,'" + TECH_ENGINEERING + "':1}"
	matter = list(MAT_STEEL = 400)

	var/battery_rating = 75
	var/obj/item/cell/battery = /obj/item/cell

/obj/item/stock_parts/computer/battery_module/advanced
	name = "advanced battery"
	desc = "An advanced power cell, often used in most laptops. It is too large to be fitted into smaller devices. It's rating is 110 Wh."
	icon_state = "battery_advanced"
	origin_tech = "{'" + TECH_POWER + "':2,'" + TECH_ENGINEERING + "':2}"
	hardware_size = 2
	battery_rating = 110
	matter = list(MAT_STEEL = 800)

/obj/item/stock_parts/computer/battery_module/super
	name = "super battery"
	desc = "A very advanced power cell, often used in high-end devices, or as uninterruptable power supply for important consoles or servers. It's rating is 150 Wh."
	icon_state = "battery_super"
	origin_tech = "{'" + TECH_POWER + "':3,'" + TECH_ENGINEERING + "':3}"
	hardware_size = 2
	battery_rating = 150
	matter = list(MAT_STEEL = 1600)

/obj/item/stock_parts/computer/battery_module/ultra
	name = "ultra battery"
	desc = "A very advanced large power cell. It's often used as uninterruptable power supply for critical consoles or servers. It's rating is 200 Wh."
	icon_state = "battery_ultra"
	origin_tech = "{'" + TECH_POWER + "':5,'" + TECH_ENGINEERING + "':4}"
	hardware_size = 3
	battery_rating = 200
	matter = list(MAT_STEEL = 3200)

/obj/item/stock_parts/computer/battery_module/micro
	name = "micro battery"
	desc = "A small power cell, commonly seen in most portable microcomputers. It's rating is 50 Wh."
	icon_state = "battery_micro"
	origin_tech = "{'" + TECH_POWER + "':2,'" + TECH_ENGINEERING + "':2}"
	battery_rating = 50
	matter = list(MAT_STEEL = 400)

/obj/item/stock_parts/computer/battery_module/nano
	name = "nano battery"
	desc = "A tiny power cell, commonly seen in low-end portable microcomputers. It's rating is 30 Wh."
	icon_state = "battery_nano"
	origin_tech = "{'" + TECH_POWER + "':1,'" + TECH_ENGINEERING + "':1}"
	battery_rating = 30
	matter = list(MAT_STEEL = 200)

// This is not intended to be obtainable in-game. Intended for adminbus and debugging purposes.
/obj/item/stock_parts/computer/battery_module/lambda
	name = "lambda coil"
	desc = "A very complex power source compatible with various computers. It is capable of providing power for nearly unlimited duration."
	icon_state = "battery_lambda"
	hardware_size = 1
	battery_rating = 3000
	battery = /obj/item/cell/infinite

/obj/item/stock_parts/computer/battery_module/diagnostics()
	. = ..()
	. += "Internal battery charge: [battery.charge]/[battery.maxcharge] CU"

/obj/item/stock_parts/computer/battery_module/Initialize()
	. = ..()
	battery = new battery(src)
	battery.maxcharge = battery_rating
	battery.charge = 0

/obj/item/stock_parts/computer/battery_module/Destroy()
	QDEL_NULL(battery)
	return ..()

/obj/item/stock_parts/computer/battery_module/proc/charge_to_full()
	if(battery)
		battery.charge = battery.maxcharge

/obj/item/stock_parts/computer/battery_module/get_cell()
	return battery
