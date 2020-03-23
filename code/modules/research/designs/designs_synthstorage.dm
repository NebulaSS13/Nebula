/datum/design/item/synthstorage/ModifyDesignName()
	name = "Synthetic intelligence storage ([name])"

/datum/design/item/synthstorage/paicard
	name = "pAI"
	desc = "Personal Artificial Intelligence device."
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/paicard

/datum/design/item/synthstorage/intelicard
	name = "inteliCard"
	desc = "AI preservation and transportation system."
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/aicard

/datum/design/item/synthstorage/posibrain
	name = "Positronic brain"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 6, TECH_BLUESPACE = 2, TECH_DATA = 4)
	build_type = PROTOLATHE | MECHFAB
	build_path = /obj/item/organ/internal/posibrain
	category = "Misc"
