/datum/fabricator_recipe/protolathe/cell
	category = "Power Storage"
	path = /obj/item/cell
	fabricator_types = list(
		FABRICATOR_CLASS_PROTOLATHE,
		FABRICATOR_CLASS_ROBOTICS
	)

/datum/fabricator_recipe/protolathe/cell/get_product_name()
	. = "power cell model ([..()])"

/datum/fabricator_recipe/protolathe/cell/apc
	path = /obj/item/cell/apc

/datum/fabricator_recipe/protolathe/cell/gun
	path = /obj/item/cell/gun

/datum/fabricator_recipe/protolathe/cell/high
	path = /obj/item/cell/high

/datum/fabricator_recipe/protolathe/cell/exosuit
	path = /obj/item/cell/exosuit

/datum/fabricator_recipe/protolathe/cell/super
	path = /obj/item/cell/super

/datum/fabricator_recipe/protolathe/cell/hyper
	path = /obj/item/cell/hyper

//Fuel cells

/datum/fabricator_recipe/protolathe/fuel_cell
	category = "Power Storage"
	path = /obj/item/cell/fuel
	fabricator_types = list(
		FABRICATOR_CLASS_PROTOLATHE,
		FABRICATOR_CLASS_ROBOTICS
	)

/datum/fabricator_recipe/protolathe/fuel_cell/get_product_name()
	. = "fuel cell model ([..()])"

/datum/fabricator_recipe/protolathe/fuel_cell/high
	path = /obj/item/cell/fuel/high

/datum/fabricator_recipe/protolathe/fuel_cell/nuclear
	path = /obj/item/cell/fuel/nuclear

/datum/fabricator_recipe/protolathe/fuel_cell/nuclear_high
	path = /obj/item/cell/fuel/nuclear/high

/datum/fabricator_recipe/protolathe/fuel_cell/fusion
	path = /obj/item/cell/fuel/fusion

/datum/fabricator_recipe/protolathe/fuel_cell/fusion_high
	path = /obj/item/cell/fuel/fusion/high

//Device cells

/datum/fabricator_recipe/protolathe/device_cell/get_product_name()
	. = "device cell model ([..()])"

/datum/fabricator_recipe/protolathe/device_cell
	category = "Power Storage"
	fabricator_types = list(FABRICATOR_CLASS_PROTOLATHE)
	path = /obj/item/cell/device

/datum/fabricator_recipe/protolathe/device_cell/high
	path = /obj/item/cell/device/high

/datum/fabricator_recipe/protolathe/device_cell/super
	path = /obj/item/cell/device/super

//Fuel device cells

/datum/fabricator_recipe/protolathe/device_cell_fuel/get_product_name()
	. = "fuel device cell model ([..()])"

/datum/fabricator_recipe/protolathe/device_cell_fuel
	category = "Power Storage"
	fabricator_types = list(FABRICATOR_CLASS_PROTOLATHE)
	path = /obj/item/cell/device/fuel

/datum/fabricator_recipe/protolathe/device_cell_fuel/high
	path = /obj/item/cell/device/fuel/high