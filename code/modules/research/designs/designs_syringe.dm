/datum/design/item/syringe/ModifyDesignName()
	name = "Syringe prototype ([name])"

/datum/design/item/syringe/noreactsyringe
	name = "Cryo Syringe"
	desc = "An advanced syringe that stops reagents inside from reacting. It can hold up to 20 units."
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/chems/syringe/noreact

/datum/design/item/syringe/bluespacesyringe
	name = "Bluespace Syringe"
	desc = "An advanced syringe that can hold 60 units of chemicals"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/chems/syringe/bluespace
