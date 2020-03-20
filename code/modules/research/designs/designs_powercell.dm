/datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB
	category = "Misc"

/datum/design/item/powercell/ModifyDesignName()
	name = "Power cell model ([name])"

/datum/design/item/powercell/device/ModifyDesignName()
	name = "Device cell model ([name])"

/datum/design/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/item/powercell/Fabricate()
	var/obj/item/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	return C

/datum/design/item/powercell/basic
	name = "basic"
	req_tech = list(TECH_POWER = 1)
	build_path = /obj/item/cell

/datum/design/item/powercell/high
	name = "high-capacity"
	req_tech = list(TECH_POWER = 2)
	build_path = /obj/item/cell/high

/datum/design/item/powercell/super
	name = "super-capacity"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/cell/super

/datum/design/item/powercell/hyper
	name = "hyper-capacity"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/cell/hyper

/datum/design/item/powercell/device/standard
	name = "basic"
	req_tech = list(TECH_POWER = 1)
	build_path = /obj/item/cell/device/standard

/datum/design/item/powercell/device/high
	name = "high-capacity"
	build_type = PROTOLATHE | MECHFAB
	req_tech = list(TECH_POWER = 2)
	build_path = /obj/item/cell/device/high
