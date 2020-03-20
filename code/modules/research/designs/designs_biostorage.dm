/datum/design/item/biostorage/ModifyDesignName()
	name = "Biological intelligence storage ([name])"

/datum/design/item/biostorage/mmi
	name = "man-machine interface"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	build_type = PROTOLATHE | MECHFAB
	build_path = /obj/item/mmi
	category = "Misc"

/datum/design/item/biostorage/mmi_radio
	name = "radio-enabled man-machine interface"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 4)
	build_type = PROTOLATHE | MECHFAB
	build_path = /obj/item/mmi/radio_enabled
	category = "Misc"
