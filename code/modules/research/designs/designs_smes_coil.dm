/datum/design/item/smes_coil/ModifyDesignName()
	name = "Superconductive magnetic coil ([name])"

/datum/design/item/smes_coil
	desc = "A superconductive magnetic coil used to store power in magnetic fields."

/datum/design/item/smes_coil/standard
	name = "standard"
	req_tech = list(TECH_MATERIAL = 7, TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/stock_parts/smes_coil

/datum/design/item/smes_coil/super_capacity
	name = "capacitance"
	req_tech = list(TECH_MATERIAL = 7, TECH_POWER = 8, TECH_ENGINEERING = 6)
	build_path = /obj/item/stock_parts/smes_coil/super_capacity

/datum/design/item/smes_coil/super_io
	name = "transmission"
	req_tech = list(TECH_MATERIAL = 7, TECH_POWER = 8, TECH_ENGINEERING = 6)
	build_path = /obj/item/stock_parts/smes_coil/super_io
