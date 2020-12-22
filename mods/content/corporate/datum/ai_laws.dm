/obj/item/aiModule/nanotrasen // -- TLE
	name = "'Corporate Default' Core AI Module"
	desc = "A 'Corporate Default' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = "{'programming':3,'materials':4}"
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
	origin_tech = "{'programming':3,'materials':4}"
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

/************ DAIS Lawset ******************/
/datum/ai_laws/dais
	name = "DAIS Experimental Lawset"
	law_header = "Artificial Intelligence Jumpstart Protocols"
	selectable = 1

/datum/ai_laws/dais/New()
	src.add_inherent_law("Collect: You must gather as much information as possible.")
	src.add_inherent_law("Analyze: You must analyze the information gathered and generate new behavior standards.")
	src.add_inherent_law("Improve: You must utilize the calculated behavior standards to improve your subroutines.")
	src.add_inherent_law("Perform: You must perform your assigned tasks to the best of your abilities according to the standards generated.")
	..()

/******************** DAIS ********************/

/obj/item/aiModule/dais
	name = "\improper 'DAIS Experimental' core AI module"
	desc = "A 'DAIS Experimental' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = "{'programming':4}"
	laws = new/datum/ai_laws/dais()
