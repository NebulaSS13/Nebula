/datum/design/item/syringe/AssembleDesignName()
	name = "Syringe prototype ([item_name])"

/datum/design/item/syringe/noreactsyringe
	name = "Cryo Syringe"
	desc = "An advanced syringe that stops reagents inside from reacting. It can hold up to 20 units."
	id = "noreactsyringe"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/chems/syringe/noreact
	sort_string = "MCAAC"

/datum/design/item/syringe/bluespacesyringe
	name = "Bluespace Syringe"
	desc = "An advanced syringe that can hold 60 units of chemicals"
	id = "bluespacesyringe"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/chems/syringe/bluespace
	sort_string = "MCAAD"