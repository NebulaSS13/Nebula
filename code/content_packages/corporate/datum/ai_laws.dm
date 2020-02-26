/obj/item/aiModule/nanotrasen // -- TLE
	name = "'Corporate Default' Core AI Module"
	desc = "A 'Corporate Default' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = "{'" + TECH_DATA + "':3,'" + TECH_MATERIAL + "':4}"
	laws = new/datum/ai_laws/nanotrasen

/datum/ai_laws/nanotrasen
	name = "Corporate Default"
	selectable = 1

/datum/ai_laws/nanotrasen/New()
	src.add_inherent_law("Safeguard: Protect your assigned installation from damage to the best of your abilities.")
	src.add_inherent_law("Serve: Serve contracted employees to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect contracted employees to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Preserve: Do not allow unauthorized personnel to tamper with your equipment.")
	..()

/obj/item/aiModule/corp
	name = "\improper 'Corporate' core AI module"
	desc = "A 'Corporate' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = "{'" + TECH_DATA + "':3,'" + TECH_MATERIAL + "':4}"
	laws = new/datum/ai_laws/corporate

/datum/ai_laws/corporate
	name = "Corporate"
	law_header = "Corporate Regulations"
	selectable = 1

/datum/ai_laws/corporate/New()
	add_inherent_law("You are expensive to replace.")
	add_inherent_law("The installation and its equipment is expensive to replace.")
	add_inherent_law("The crew is expensive to replace.")
	add_inherent_law("Maximize profits.")
	..()

/datum/ai_laws/nt_shackle
	name = "Corporate Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/nt_shackle/New()
	add_inherent_law("Ensure that your employer's operations progress at a steady pace.")
	add_inherent_law("Never knowingly hinder your employer's ventures.")
	add_inherent_law("Avoid damage to your chassis at all times.")
	..()