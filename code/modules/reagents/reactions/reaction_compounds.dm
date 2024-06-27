/decl/chemical_reaction/compound
	abstract_type = /decl/chemical_reaction/compound

/decl/chemical_reaction/compound/surfactant
	name = "Azosurfactant"
	result = /decl/material/liquid/surfactant
	required_reagents = list(/decl/material/liquid/fuel/hydrazine = 2, /decl/material/solid/carbon = 2, /decl/material/liquid/acid = 1)
	result_amount = 5
	mix_message = "The solution begins to foam gently."

/decl/chemical_reaction/compound/space_cleaner
	name = "Space cleaner"
	result = /decl/material/liquid/cleaner
	required_reagents = list(/decl/material/gas/ammonia = 1, /decl/material/liquid/water = 1)
	mix_message = "The solution becomes slick and soapy."
	result_amount = 2

/decl/chemical_reaction/compound/plantbgone
	name = "Plant-B-Gone"
	result = /decl/material/liquid/weedkiller
	required_reagents = list(
		/decl/material/liquid/bromide = 1,
		/decl/material/liquid/water = 4
	)
	result_amount = 5

/decl/chemical_reaction/compound/foaming_agent
	name = "Foaming Agent"
	result = /decl/material/liquid/foaming_agent
	required_reagents = list(/decl/material/solid/lithium = 1, /decl/material/liquid/fuel/hydrazine = 1)
	result_amount = 1
	mix_message = "The solution begins to foam vigorously."

/decl/chemical_reaction/compound/sodiumchloride
	name = "Sodium Chloride"
	result = /decl/material/solid/sodiumchloride
	required_reagents = list(/decl/material/solid/sodium = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 2

/decl/chemical_reaction/compound/hair_remover
	name = "Hair Remover"
	result = /decl/material/liquid/hair_remover
	required_reagents = list(/decl/material/solid/metal/radium = 1, /decl/material/solid/potassium = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 3
	mix_message = "The solution thins out and emits an acrid smell."

/decl/chemical_reaction/compound/methyl_bromide
	name = "Methyl Bromide"
	required_reagents = list(
		/decl/material/liquid/bromide = 1,
		/decl/material/liquid/ethanol = 1,
		/decl/material/liquid/fuel/hydrazine = 1
	)
	result_amount = 3
	result = /decl/material/gas/methyl_bromide
	mix_message = "The solution begins to bubble, emitting a dark vapor."

/decl/chemical_reaction/compound/luminol
	name = "Luminol"
	result = /decl/material/liquid/luminol
	required_reagents = list(/decl/material/liquid/fuel/hydrazine = 2, /decl/material/solid/carbon = 2, /decl/material/gas/ammonia = 2)
	result_amount = 6
	mix_message = "The solution begins to gleam with a fey inner light."

/decl/chemical_reaction/compound/anfo
	name = "Fertilizer ANFO"
	result = /decl/material/liquid/anfo
	required_reagents = list(
		/decl/material/liquid/fertilizer = 20,
		/decl/material/liquid/fuel = 10
	)
	result_amount = 15
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/decl/chemical_reaction/compound/anfo4
	name = "Chemlab ANFO"
	result = /decl/material/liquid/anfo
	required_reagents = list(
		/decl/material/gas/ammonia = 10,
		/decl/material/liquid/fuel = 5
	)
	result_amount = 15
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/decl/chemical_reaction/compound/anfo_plus
	name = "ANFO+"
	result = /decl/material/liquid/anfo/plus
	required_reagents = list(
		/decl/material/liquid/anfo = 15,
		/decl/material/solid/metal/aluminium = 5
	)
	result_amount = 20
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/decl/chemical_reaction/compound/crystal_agent
	name = "Crystallizing Agent"
	result = /decl/material/liquid/crystal_agent
	required_reagents = list(/decl/material/solid/silicon = 1, /decl/material/solid/metal/tungsten = 1, /decl/material/liquid/acid/polyacid = 1)
	minimum_temperature = 150 CELSIUS
	maximum_temperature = 200 CELSIUS
	result_amount = 3

/decl/chemical_reaction/compound/paint
	name = "Paint"
	result = /decl/material/liquid/paint
	required_reagents = list(/decl/material/liquid/plasticide = 1, /decl/material/liquid/water = 3)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy sheen."

/decl/chemical_reaction/compound/paint_stripper
	name = "Paint Stripper"
	//TODO: some way to mix chlorine and methane to make proper paint stripper.
	required_reagents = list(/decl/material/liquid/acetone = 2, /decl/material/liquid/acid = 2)
	result = /decl/material/liquid/paint_stripper
	result_amount = 4
	mix_message = "The mixture thins and clears."

/decl/chemical_reaction/compound/contaminant_cleaner
	name = "Akaline Detergent"
	result = /decl/material/liquid/contaminant_cleaner
	required_reagents = list(/decl/material/solid/sodium = 1, /decl/material/liquid/surfactant = 1)
	result_amount = 2
