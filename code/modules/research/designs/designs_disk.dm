/datum/design/item/disk/ModifyDesignName()
	name = "Storage disk ([name])"

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
