/datum/design/item/tool/ModifyDesignName()
	name = "Tool design ([name])"

/datum/design/item/tool/light_replacer
	name = "light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	build_path = /obj/item/lightreplacer

/datum/design/item/tool/airlock_brace
	name = "airlock brace"
	desc = "Special door attachment that can be used to provide extra security."
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/airlock_brace

/datum/design/item/tool/brace_jack
	name = "maintenance jack"
	desc = "A special maintenance tool that can be used to remove airlock braces."
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/crowbar/brace_jack

/datum/design/item/tool/clamp
	name = "stasis clamp"
	desc = "A magnetic clamp which can halt the flow of gas in a pipe, via a localised stasis field."
	req_tech = list(TECH_ENGINEERING = 4, TECH_MAGNET = 4)
	build_path = /obj/item/clamp

/datum/design/item/tool/inducer
	name = "inducer"
	desc = "An electromagnetic inducer that can transfer power from one cell into another."
	req_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4)
	build_path = /obj/item/inducer

/datum/design/item/tool/price_scanner
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4)
	build_path = /obj/item/scanner/price

/datum/design/item/tool/experimental_welder
	name = "experimental welding tool"
	desc = "This welding tool feels heavier in your possession than is normal. There appears to be no external fuel port."
	req_tech = list(TECH_ENGINEERING = 5, TECH_PHORON = 4)
	build_path = /obj/item/weldingtool/experimental

/datum/design/item/tool/shield_diffuser
	name = "portable shield diffuser"
	desc = "A small handheld device designed to disrupt energy barriers."
	req_tech = list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_ESOTERIC = 2)
	build_path = /obj/item/shield_diffuser

/datum/design/item/tool/rpd
	name = "rapid piping device"
	desc = "A compacted and complicated device, that relies on compressed matter to dispense piping on the move."
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6)
	build_path = /obj/item/rpd

/datum/design/item/tool/oxycandle
	name = "oxycandle"
	desc = "a device which, via a chemical reaction, can pressurise small areas."
	req_tech = list(TECH_ENGINEERING = 2)
	chemicals = list(/datum/reagent/sodiumchloride = 20, /datum/reagent/acetone = 20)
	build_path = /obj/item/oxycandle
