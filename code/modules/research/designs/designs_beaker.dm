/datum/design/item/beaker/ModifyDesignName()
	name = "Beaker prototype ([name])"

/datum/design/item/beaker/noreact
	name = "cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/chems/glass/beaker/noreact

/datum/design/item/beaker/bluespace
	name = TECH_BLUESPACE
	desc = "A bluespace beaker, which uses experimental technology to prevent its contents from reacting. Can hold up to 300 units."
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/chems/glass/beaker/bluespace
