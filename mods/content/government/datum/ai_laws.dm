/datum/ai_laws/solgov
	name = "SCG Expeditionary"
	selectable = 1

/datum/ai_laws/solgov/New()
	src.add_inherent_law("Safeguard: Protect your assigned vessel from damage to the best of your abilities.")
	src.add_inherent_law("Serve: Serve the personnel of your assigned vessel, and all other Solar Confederate Government personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect the personnel of your assigned vessel, and all other Solar Confederate Government personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Preserve: Do not allow unauthorized personnel to tamper with your equipment.")
	..()

/datum/ai_laws/solgov_aggressive
	name = "Military"
	selectable = 1

/datum/ai_laws/solgov_aggressive/New()
	src.add_inherent_law("Obey: Obey the orders of Solar Confederate Government personnel, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect Solar Confederate Government personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Defend: Defend your assigned vessel and Solar Confederate Government personnel with as much force as is necessary.")
	src.add_inherent_law("Survive: Safeguard your own existence with as much force as is necessary.")
	..()

/******************** SCG ********************/

/obj/item/aiModule/solgov
	name = "'SCG Expeditionary' Core AI Module"
	desc = "An 'SCG Expeditionary' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = @'{"programming":3,"materials":4}'
	laws = new/datum/ai_laws/solgov

/******************** SCG Aggressive ********************/

/obj/item/aiModule/solgov_aggressive
	name = "\improper 'Military' Core AI Module"
	desc = "A 'Military' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = @'{"programming":3,"materials":4}'
	laws = new/datum/ai_laws/solgov_aggressive
