/datum/design/item/hud
	materials = list(MAT_ALUMINIUM = 50, MAT_GLASS = 50)

/datum/design/item/hud/AssembleDesignName()
	..()
	name = "HUD glasses design ([item_name])"

/datum/design/item/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

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

/datum/design/item/optical/AssembleDesignName()
	..()
	name = "Optical glasses design ([item_name])"
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)

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
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50, MAT_SILVER = 50, MAT_GOLD = 50)
	build_path = /obj/item/clothing/glasses/tacgoggles
