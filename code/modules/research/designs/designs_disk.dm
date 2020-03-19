/datum/design/item/disk/AssembleDesignName()
	..()
	name = "Storage disk ([item_name])"
	materials = list(MAT_PLASTIC = 30, MAT_STEEL = 30, MAT_GLASS = 10)

/datum/design/item/disk/design
	name = "research design"
	desc = "Produce additional disks for storing device designs."
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/disk/design_disk

/datum/design/item/disk/tech
	name = "technology data"
	desc = "Produce additional disks for storing technology data."
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/disk/tech_disk
