/datum/design/item/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"

/datum/design/item/mining/jackhammer
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_SILVER = 500)
	build_path = /obj/item/pickaxe/jackhammer

/datum/design/item/mining/drill
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill

/datum/design/item/mining/plasmacutter
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 1500, MAT_GLASS = 500, MAT_GOLD = 500, MAT_PHORON = 500)
	build_path = /obj/item/gun/energy/plasmacutter

/datum/design/item/mining/pick_diamond
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MAT_DIAMOND = 3000)
	build_path = /obj/item/pickaxe/diamond

/datum/design/item/mining/drill_diamond
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/pickaxe/diamonddrill

/datum/design/item/mining/depth_scanner
	desc = "Used to check spatial depth and density of rock outcroppings."
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_ALUMINIUM = 150)
	build_path = /obj/item/depth_scanner
