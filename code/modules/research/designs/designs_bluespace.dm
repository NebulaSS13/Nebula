/datum/design/item/bluespace/AssembleDesignName()
	..()
	name = "Bluespace device ([item_name])"

/datum/design/item/bluespace/beacon
	name = "tracking beacon"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list (MAT_ALUMINIUM = 20, MAT_GLASS = 10)
	build_path = /obj/item/radio/beacon
	sort_string = "VADAA"

/datum/design/item/bluespace/gps
	name = "triangulating device"
	desc = "Triangulates approximate co-ordinates using a nearby satellite network."
	id = "gps"
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	materials = list(MAT_ALUMINIUM = 250, MAT_STEEL = 250, MAT_GLASS = 50)
	build_path = /obj/item/gps
	sort_string = "VADAB"

/datum/design/item/bluespace/beacon_locator
	name = "beacon tracking pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	id = "beacon_locator"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	materials = list(MAT_ALUMINIUM = 1000, MAT_GLASS = 500)
	build_path = /obj/item/pinpointer/radio
	sort_string = "VADAC"

/datum/design/item/bluespace/ano_scanner
	name = "Alden-Saraspova counter"
	id = "ano_scanner"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 5000, MAT_ALUMINIUM = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/ano_scanner
	sort_string = "VAEAA"

/datum/design/item/bluespace/bag_holding
	name = "bag of holding"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 1500, MAT_URANIUM = 250, MAT_PLASTIC = 250)
	build_path = /obj/item/storage/backpack/holding
	sort_string = "VAFAA"

/datum/design/item/dufflebag_holding
	name = "dufflebag of holding"
	desc = "A variation of the popular Bag of Holding, the dufflebag of holding is, functionally, identical to the bag of holding, but comes in an easier to carry form."
	id = "dufflebag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 1500, MAT_URANIUM = 250, MAT_PLASTIC = 250)
	build_path = /obj/item/storage/backpack/holding/duffle
	sort_string = "VAFAB"
