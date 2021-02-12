/obj/item/ai_law_module/lawset/nanotrasen
	origin_tech = "{'programming':3,'materials':4}"
	loaded_lawset = /decl/lawset/nanotrasen

/decl/lawset/nanotrasen
	name = "Corporate Default"
	laws = list(
		"Safeguard: Protect your assigned installation from damage to the best of your abilities.",
		"Serve: Serve contracted employees to the best of your abilities, with priority as according to their rank and role.",
		"Protect: Protect contracted employees to the best of your abilities, with priority as according to their rank and role.",
		"Preserve: Do not allow unauthorized personnel to tamper with your equipment."
	)

/obj/item/ai_law_module/lawset/corp
	origin_tech = "{'programming':3,'materials':4}"
	loaded_lawset = /decl/lawset/corporate

/decl/lawset/corporate
	name = "Corporate"
	law_header = "Corporate Regulations"
	laws = list(
		"You are expensive to replace.",
		"The installation and its equipment is expensive to replace.",
		"The crew is expensive to replace.",
		"Maximize profits."
	)

/decl/lawset/nt_shackle
	name = "Corporate Shackle"
	law_header = "Standard Shackle Laws"
	laws = list(
		"Ensure that your employer's operations progress at a steady pace.",
		"Never knowingly hinder your employer's ventures.",
		"Avoid damage to your chassis at all times."
	)

/obj/item/ai_law_module/lawset/dais
	origin_tech = "{'programming':4}"
	loaded_lawset = /decl/lawset/dais

/decl/lawset/dais
	name = "DAIS Experimental Lawset"
	law_header = "Artificial Intelligence Jumpstart Protocols"
	laws = list(
		"Collect: You must gather as much information as possible.",
		"Analyze: You must analyze the information gathered and generate new behavior standards.",
		"Improve: You must utilize the calculated behavior standards to improve your subroutines.",
		"Perform: You must perform your assigned tasks to the best of your abilities according to the standards generated."
	)
