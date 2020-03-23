/datum/design/circuit/exosuit/ModifyDesignName()
	name = "Exosuit software design ([name])"

/datum/design/circuit/exosuit/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] module."

/datum/design/circuit/exosuit/engineering
	name = "engineering system control"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/exosystem/engineering

/datum/design/circuit/exosuit/utility
	name = "utility system control"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/exosystem/utility

/datum/design/circuit/exosuit/medical
	name = "medical system control"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/exosystem/medical

/datum/design/circuit/exosuit/weapons
	name = "basic weapon control"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/exosystem/weapons

/datum/design/circuit/exosuit/advweapons
	name = "advanced weapon control"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/exosystem/advweapons
