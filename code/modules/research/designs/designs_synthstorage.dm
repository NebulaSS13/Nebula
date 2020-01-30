/datum/design/item/synthstorage/AssembleDesignName()
	..()
	name = "Synthetic intelligence storage ([item_name])"

/datum/design/item/synthstorage/paicard
	name = "pAI"
	desc = "Personal Artificial Intelligence device."
	id = "paicard"
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_GLASS = 500, MAT_STEEL = 500)
	build_path = /obj/item/paicard
	sort_string = "VABAI"

/datum/design/item/synthstorage/intelicard
	name = "inteliCard"
	desc = "AI preservation and transportation system."
	id = "intelicard"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	materials = list(MAT_GLASS = 1000, MAT_GOLD = 200)
	build_path = /obj/item/aicard
	sort_string = "VACAA"

/datum/design/item/synthstorage/posibrain
	name = "Positronic brain"
	id = "posibrain"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 6, TECH_BLUESPACE = 2, TECH_DATA = 4)
	build_type = PROTOLATHE | MECHFAB
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 500, MAT_PHORON = 500, MAT_DIAMOND = 100)
	build_path = /obj/item/organ/internal/posibrain
	category = "Misc"
	sort_string = "VACAB"