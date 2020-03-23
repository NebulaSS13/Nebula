/datum/design/item/hud/ModifyDesignName()
	name = "HUD glasses design ([name])"

/datum/design/item/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] HUD glasses."

/datum/design/item/hud/health
	name = "health scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health

/datum/design/item/hud/security
	name = "security records"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security

/datum/design/item/hud/janitor
	name = "filth scanner"
	req_tech = list(TECH_BIO = 1, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/janitor

/datum/design/item/optical/ModifyDesignName()
	name = "Optical glasses design ([name])"

/datum/design/item/optical/mesons
	name = "mesons"
	desc = "Using the meson-scanning technology those glasses allow you to see through walls, floor or anything else."
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/clothing/glasses/meson

/datum/design/item/optical/material
	name = "material"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/clothing/glasses/material

/datum/design/item/optical/tactical
	name = "tactical"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 5)
	build_path = /obj/item/clothing/glasses/tacgoggles
