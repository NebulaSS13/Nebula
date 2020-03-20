/datum/design/item/mining/ModifyDesignName()
	name = "Mining equipment design ([name])"

/datum/design/item/mining/jackhammer
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/pickaxe/jackhammer

/datum/design/item/mining/drill
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/pickaxe/drill

/datum/design/item/mining/plasmacutter
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/gun/energy/plasmacutter

/datum/design/item/mining/pick_diamond
	req_tech = list(TECH_MATERIAL = 6)
	build_path = /obj/item/pickaxe/diamond

/datum/design/item/mining/drill_diamond
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/pickaxe/diamonddrill

/datum/design/item/mining/depth_scanner
	desc = "Used to check spatial depth and density of rock outcroppings."
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	build_path = /obj/item/depth_scanner
