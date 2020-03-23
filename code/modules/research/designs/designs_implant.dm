/datum/design/item/implant/ModifyDesignName()
	name = "Implantable biocircuit design ([name])"

/datum/design/item/implant/chemical
	name = "chemical"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/chem

/datum/design/item/implant/death_alarm
	name = "death alarm"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_DATA = 2)
	build_path = /obj/item/implantcase/death_alarm

/datum/design/item/implant/tracking
	name = "tracking"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_BLUESPACE = 3)
	build_path = /obj/item/implantcase/tracking

/datum/design/item/implant/imprinting
	name = "imprinting"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_DATA = 4)
	build_path = /obj/item/implantcase/imprinting

/datum/design/item/implant/adrenaline
	name = "adrenaline"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ESOTERIC = 3)
	build_path = /obj/item/implantcase/adrenalin

/datum/design/item/implant/freedom
	name = "freedom"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ESOTERIC = 3)
	build_path = /obj/item/implantcase/freedom

/datum/design/item/implant/explosive
	name = "explosive"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ESOTERIC = 4)
	build_path = /obj/item/implantcase/explosive
