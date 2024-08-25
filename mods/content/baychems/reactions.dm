/decl/chemical_reaction/drug/arithrazine
	name = "Arithrazine"
	result = /decl/material/liquid/antirads/arithrazine
	required_reagents = list(/decl/material/liquid/antirads = 1, /decl/material/liquid/fuel/hydrazine = 1)
	result_amount = 2

/decl/chemical_reaction/drug/dermaline
	name = "Dermaline"
	result = /decl/material/liquid/burn_meds/dermaline
	required_reagents = list(/decl/material/liquid/acetone = 1, /decl/material/solid/phosphorus = 1, /decl/material/liquid/burn_meds = 1)
	result_amount = 3

/decl/chemical_reaction/drug/oxy_meds
	name = "Dexalin"
	result_amount = 1
	required_reagents = list(
		/decl/material/liquid/acetone = 1,
		/decl/material/solid/phoron = 0.1
	)
	catalysts = list(/decl/material/solid/phoron = 5)

/decl/chemical_reaction/drug/dexalinp
	name = "Dexalin Plus"
	result = /decl/material/liquid/oxy_meds/dexalinp
	required_reagents = list(/decl/material/liquid/oxy_meds = 1, /decl/material/solid/carbon = 1, /decl/material/solid/metal/iron = 1)
	result_amount = 3

/decl/chemical_reaction/drug/paracetamol
	name = "Paracetamol"
	result = /decl/material/liquid/painkillers
	required_reagents = list(
		/decl/material/liquid/stabilizer = 1,
		/decl/material/gas/ammonia = 1,
		/decl/material/liquid/water = 1
	)
	result_amount = 3

/decl/chemical_reaction/drug/strong_painkillers
	name = "Tramadol"
	result = /decl/material/liquid/painkillers/strong
	required_reagents = list(
		/decl/material/liquid/painkillers = 1,
		/decl/material/liquid/ethanol = 1,
		/decl/material/liquid/acetone = 1
	)
	result_amount = 3

/decl/chemical_reaction/drug/oxycodone
	name = "Oxycodone"
	result = /decl/material/liquid/painkillers/oxycodone
	required_reagents = list(/decl/material/liquid/ethanol = 1, /decl/material/liquid/painkillers/strong = 1)
	catalysts = list(/decl/material/solid/phoron = 5)
	result_amount = 1

/decl/chemical_reaction/drug/fentanyl
	name = "Fentanyl"
	result = /decl/material/liquid/painkillers/fentanyl
	required_reagents = list(/decl/material/liquid/painkillers/oxycodone = 2, /decl/material/liquid/sedatives = 1, /decl/material/liquid/hallucinogenics = 1)
	result_amount = 2

/decl/chemical_reaction/drug/paroxetine
	name = "Paroxetine"
	result = /decl/material/liquid/antidepressants/paroxetine
	required_reagents = list(/decl/material/liquid/hallucinogenics = 1, /decl/material/liquid/acetone = 1, /decl/material/liquid/stabilizer = 1)
	result_amount = 3

/decl/chemical_reaction/drug/hallucinogenics
	name = "Mindbreaker Toxin"
	required_reagents = list(/decl/material/solid/silicon = 1, /decl/material/gas/ammonia = 1, /decl/material/liquid/antitoxins = 1)
	minimum_temperature = 0
	maximum_temperature = INFINITY

/decl/chemical_reaction/drug/psychoactives
	name = "Space Drugs"
	minimum_temperature = 0
	maximum_temperature = INFINITY