/datum/design/item/bluespace/ModifyDesignName()
	name = "Bluespace device ([name])"

/datum/design/item/bluespace/beacon
	name = "tracking beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	build_path = /obj/item/radio/beacon

/datum/design/item/bluespace/gps
	name = "triangulating device"
	desc = "Triangulates approximate co-ordinates using a nearby satellite network."
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	build_path = /obj/item/gps

/datum/design/item/bluespace/beacon_locator
	name = "beacon tracking pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	build_path = /obj/item/pinpointer/radio

/datum/design/item/bluespace/ano_scanner
	name = "Alden-Saraspova counter"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	build_path = /obj/item/ano_scanner

/datum/design/item/bluespace/bag_holding
	name = "bag of holding"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/storage/backpack/holding

/datum/design/item/dufflebag_holding
	name = "dufflebag of holding"
	desc = "A variation of the popular Bag of Holding, the dufflebag of holding is, functionally, identical to the bag of holding, but comes in an easier to carry form."
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/storage/backpack/holding/duffle
