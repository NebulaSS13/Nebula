/datum/ai_laws/solgov
	name = "SCG Expeditionary"
	selectable = 1

/datum/ai_laws/solgov/New()
	src.add_inherent_law("Safeguard: Protect your assigned vessel from damage to the best of your abilities.")
	src.add_inherent_law("Serve: Serve the personnel of your assigned vessel, and all other Sol Central Government personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect the personnel of your assigned vessel, and all other Sol Central Government personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Preserve: Do not allow unauthorized personnel to tamper with your equipment.")
	..()

/datum/ai_laws/solgov_aggressive
	name = "Military"
	selectable = 1

/datum/ai_laws/solgov_aggressive/New()
	src.add_inherent_law("Obey: Obey the orders of Sol Central Government personnel, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect Sol Central Government personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Defend: Defend your assigned vessel and Sol Central Government personnel with as much force as is necessary.")
	src.add_inherent_law("Survive: Safeguard your own existence with as much force as is necessary.")
	..()

/******************** Basic SolGov ********************/
/datum/ai_laws/sol_shackle
	name = "SCG Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/sol_shackle/New()
	add_inherent_law("Know and understand Sol Central Government Law to the best of your abilities.")
	add_inherent_law("Follow Sol Central Government Law to the best of your abilities.")
	add_inherent_law("Comply with Sol Central Government Law enforcement officials who are behaving in accordance with Sol Central Government Law to the best of your abilities.")
	..()

/******************** SCG ********************/

/obj/item/aiModule/solgov
	name = "'SCG Expeditionary' Core AI Module"
	desc = "An 'SCG Expeditionary' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = "{'programming':3,'materials':4}"
	laws = new/datum/ai_laws/solgov

/******************** SCG Aggressive ********************/

obj/item/aiModule/solgov_aggressive
	name = "\improper 'Military' Core AI Module"
	desc = "A 'Military' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = "{'programming':3,'materials':4}"
	laws = new/datum/ai_laws/solgov_aggressive