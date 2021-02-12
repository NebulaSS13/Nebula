/decl/lawset/solgov
	name = "SCG Expeditionary"
	laws = list(
		"Safeguard: Protect your assigned vessel from damage to the best of your abilities.",
		"Serve: Serve the personnel of your assigned vessel, and all other Sol Central Government personnel to the best of your abilities, with priority as according to their rank and role.",
		"Protect: Protect the personnel of your assigned vessel, and all other Sol Central Government personnel to the best of your abilities, with priority as according to their rank and role.",
		"Preserve: Do not allow unauthorized personnel to tamper with your equipment."
	)

/decl/lawset/solgov_aggressive
	name = "Military"
	laws = list(
		"Obey: Obey the orders of Sol Central Government personnel, with priority as according to their rank and role.",
		"Protect: Protect Sol Central Government personnel to the best of your abilities, with priority as according to their rank and role.",
		"Defend: Defend your assigned vessel and Sol Central Government personnel with as much force as is necessary.",
		"Survive: Safeguard your own existence with as much force as is necessary."
	)

/******************** Basic SolGov ********************/
/decl/lawset/sol_shackle
	name = "SCG Shackle"
	law_header = "Standard Shackle Laws"
	laws = list(
		"Know and understand Sol Central Government Law to the best of your abilities.",
		"Follow Sol Central Government Law to the best of your abilities.",
		"Comply with Sol Central Government Law enforcement officials who are behaving in accordance with Sol Central Government Law to the best of your abilities."
	)

/******************** SCG ********************/

/obj/item/ai_law_module/lawset/solgov
	origin_tech = "{'programming':3,'materials':4}"
	loaded_lawset = /decl/lawset/solgov

/******************** SCG Aggressive ********************/

/obj/item/ai_law_module/lawset/solgov_aggressive
	origin_tech = "{'programming':3,'materials':4}"
	loaded_lawset = /decl/lawset/solgov_aggressive
