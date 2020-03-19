/datum/design/item/beaker/AssembleDesignName()
	name = "Beaker prototype ([item_name])"

/datum/design/item/beaker/noreact
	name = "cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/chems/glass/beaker/noreact

/datum/design/item/beaker/bluespace
	name = TECH_BLUESPACE
	desc = "A bluespace beaker, which uses experimental technology to prevent its contents from reacting. Can hold up to 300 units."
	id = "bluespacebeaker"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	materials = list(MAT_STEEL = 3000, MAT_PHORON = 3000, MAT_DIAMOND = 500)
	build_path = /obj/item/chems/glass/beaker/bluespace
