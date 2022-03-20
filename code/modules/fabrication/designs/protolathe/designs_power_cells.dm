/datum/fabricator_recipe/protolathe/cell
	category = "Power Storage"
	path = /obj/item/cell
	fabricator_types = list(
		FABRICATOR_CLASS_PROTOLATHE,
		FABRICATOR_CLASS_ROBOTICS
	)

/datum/fabricator_recipe/protolathe/cell/build()
	. = ..()
	for(var/obj/item/cell/C in .)
		C.charge = 0

/datum/fabricator_recipe/protolathe/cell/get_product_name()
	. = "power cell model ([..()])"

/datum/fabricator_recipe/protolathe/cell/high
	path = /obj/item/cell/high

/datum/fabricator_recipe/protolathe/cell/super
	path = /obj/item/cell/super

/datum/fabricator_recipe/protolathe/cell/hyper
	path = /obj/item/cell/hyper

/datum/fabricator_recipe/protolathe/cell_device
	category = "Power Storage"
	path = /obj/item/cell/device/standard

/datum/fabricator_recipe/protolathe/cell_device/get_product_name()
	. = "device cell model ([..()])"

/datum/fabricator_recipe/protolathe/cell_device/high
	path = /obj/item/cell/device/high

/datum/fabricator_recipe/protolathe/cell_comp
	category = "Power Storage"
	path = /obj/item/stock_parts/computer/battery_module

/datum/fabricator_recipe/protolathe/cell_comp/get_product_name()
	. = "computer battery model ([..()])"

/datum/fabricator_recipe/protolathe/cell_comp/advanced
	path = /obj/item/stock_parts/computer/battery_module/advanced

/datum/fabricator_recipe/protolathe/cell_comp/super
	path = /obj/item/stock_parts/computer/battery_module/super

/datum/fabricator_recipe/protolathe/cell_comp/ultra
	path = /obj/item/stock_parts/computer/battery_module/ultra

/datum/fabricator_recipe/protolathe/cell_comp/nano
	path = /obj/item/stock_parts/computer/battery_module/nano

/datum/fabricator_recipe/protolathe/cell_comp/micro
	path = /obj/item/stock_parts/computer/battery_module/micro
