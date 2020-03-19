/datum/design/item/syringe/AssembleDesignName()
	name = "Syringe prototype ([item_name])"

/datum/design/item/syringe/noreactsyringe
	name = "Cryo Syringe"
	desc = "An advanced syringe that stops reagents inside from reacting. It can hold up to 20 units."
	id = "noreactsyringe"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4)
	materials = list(MAT_GLASS = 2000, MAT_GOLD = 1000, MAT_PLASTIC = 500)
	build_path = /obj/item/chems/syringe/noreact

/datum/design/item/syringe/bluespacesyringe
	name = "Bluespace Syringe"
	desc = "An advanced syringe that can hold 60 units of chemicals"
	id = "bluespacesyringe"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_GLASS = 2000, MAT_PHORON = 1000, MAT_DIAMOND = 1000)
	build_path = /obj/item/chems/syringe/bluespace
