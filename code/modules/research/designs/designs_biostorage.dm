/datum/design/item/biostorage/AssembleDesignName()
	..()
	name = "Biological intelligence storage ([item_name])"

/datum/design/item/biostorage/mmi
	name = "man-machine interface"
	id = "mmi"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	build_type = PROTOLATHE | MECHFAB
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/mmi
	category = "Misc"

/datum/design/item/biostorage/mmi_radio
	name = "radio-enabled man-machine interface"
	id = "mmi_radio"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 4)
	build_type = PROTOLATHE | MECHFAB
	materials = list(MAT_ALUMINIUM = 1200, MAT_GLASS = 500)
	build_path = /obj/item/mmi/radio_enabled
	category = "Misc"
