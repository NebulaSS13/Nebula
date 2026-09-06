/decl/chemical_reaction/drug
	abstract_type = /decl/chemical_reaction/drug
	reaction_category = REACTION_TYPE_PHARMACEUTICAL

/decl/chemical_reaction/drug/antitoxins
	name = "Antitoxins"
	result = /decl/material/liquid/antitoxins
	required_reagents = list(/decl/material/solid/silicon = 1, /decl/material/solid/potassium = 1, /decl/material/gas/ammonia = 1)
	result_amount = 3

/decl/chemical_reaction/drug/painkillers
	name = "Mild Painkillers"
	result = /decl/material/liquid/painkillers
	required_reagents = list(
		/decl/material/liquid/painkillers/strong = 1,
		/decl/material/liquid/water = 1,
		/decl/material/liquid/nutriment/sugar = 1
	)
	result_amount = 3

/decl/chemical_reaction/drug/strong_painkillers
	name = "Strong Painkillers"
	result = /decl/material/liquid/painkillers/strong
	required_reagents = list(
		/decl/material/liquid/stabilizer      = 1,
		/decl/material/liquid/alcohol/ethanol = 1,
		/decl/material/liquid/acetone         = 1
	)
	result_amount = 3

/decl/chemical_reaction/drug/antiseptic
	name = "Antiseptic"
	result = /decl/material/liquid/antiseptic
	required_reagents = list(/decl/material/liquid/alcohol/ethanol = 1, /decl/material/liquid/antitoxins = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 3

/decl/chemical_reaction/drug/mutagenics
	name = "Unstable mutagen"
	result = /decl/material/liquid/mutagenics
	required_reagents = list(/decl/material/solid/metal/radium = 1, /decl/material/solid/phosphorus = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 3

/decl/chemical_reaction/drug/psychoactives
	name = "Psychoactives"
	result = /decl/material/liquid/psychoactives
	required_reagents = list(/decl/material/liquid/mercury = 1, /decl/material/liquid/nutriment/sugar = 1, /decl/material/solid/lithium = 1)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (50 CELSIUS) + 100

/decl/chemical_reaction/drug/antirads
	name = "Anti-Radiation Medication"
	result = /decl/material/liquid/antirads
	required_reagents = list(/decl/material/solid/metal/radium = 1, /decl/material/liquid/antitoxins = 1)
	result_amount = 2

/decl/chemical_reaction/drug/narcotics
	name = "Narcotics"
	result = /decl/material/liquid/narcotics
	required_reagents = list(/decl/material/liquid/mercury = 1, /decl/material/liquid/acetone = 1, /decl/material/liquid/nutriment/sugar = 1)
	result_amount = 2

/decl/chemical_reaction/drug/burn_meds
	name = "Anti-Burn Medication"
	result = /decl/material/liquid/burn_meds
	required_reagents = list(/decl/material/solid/silicon = 1, /decl/material/solid/carbon = 1)
	result_amount = 2

/decl/chemical_reaction/drug/presyncopics
	name = "Presyncopics"
	result = /decl/material/liquid/presyncopics
	required_reagents = list(/decl/material/solid/potassium = 1, /decl/material/liquid/acetone = 1, /decl/material/liquid/nutriment/sugar = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = 60 CELSIUS
	result_amount = 3

/decl/chemical_reaction/drug/regenerator
	name = "Regenerative Serum"
	result = /decl/material/liquid/regenerator
	required_reagents = list(/decl/material/liquid/stabilizer = 1, /decl/material/liquid/antitoxins = 1)
	result_amount = 2

/decl/chemical_reaction/drug/neuroannealer
	name = "Neuroannealer"
	result = /decl/material/liquid/neuroannealer
	required_reagents = list(/decl/material/liquid/acid/hydrochloric = 1, /decl/material/gas/ammonia = 1, /decl/material/liquid/antitoxins = 1)
	result_amount = 2

/decl/chemical_reaction/drug/oxy_meds
	name = "Oxygen Deprivation Medication"
	result = /decl/material/liquid/oxy_meds
	required_reagents = list(/decl/material/liquid/acetone = 1, /decl/material/liquid/water = 1, /decl/material/solid/sulfur = 1)
	result_amount = 1

/decl/chemical_reaction/drug/brute_meds
	name = "Anti-Trauma Medication"
	result = /decl/material/liquid/brute_meds
	required_reagents = list(/decl/material/liquid/stabilizer = 1, /decl/material/solid/carbon = 1)
	inhibitors = list(/decl/material/liquid/nutriment/sugar = 1) // Messes up with adrenaline
	result_amount = 2

/decl/chemical_reaction/drug/amphetamines
	name = "Amphetamines"
	result = /decl/material/liquid/amphetamines
	required_reagents = list(/decl/material/liquid/nutriment/sugar = 1, /decl/material/solid/phosphorus = 1, /decl/material/solid/sulfur = 1)
	result_amount = 3

/decl/chemical_reaction/drug/retrovirals
	name = "Retrovirals"
	result = /decl/material/liquid/retrovirals
	required_reagents = list(/decl/material/liquid/antirads = 1, /decl/material/solid/carbon = 1)
	result_amount = 2

/decl/chemical_reaction/drug/antibiotics
	name = "Antibiotics"
	result = /decl/material/liquid/antibiotics
	required_reagents = list(/decl/material/liquid/presyncopics = 1, /decl/material/liquid/stabilizer = 1)
	result_amount = 2

/decl/chemical_reaction/drug/eyedrops
	name = "Eye Drops"
	result = /decl/material/liquid/eyedrops
	required_reagents = list(/decl/material/solid/carbon = 1, /decl/material/liquid/fuel/hydrazine = 1, /decl/material/liquid/antitoxins = 1)
	result_amount = 2

/decl/chemical_reaction/drug/sedatives
	name = "Sedatives"
	result = /decl/material/liquid/sedatives
	required_reagents = list(/decl/material/liquid/alcohol/ethanol = 1, /decl/material/liquid/nutriment/sugar = 4
	)
	inhibitors = list(
		/decl/material/solid/phosphorus
	) // Messes with the smoke
	result_amount = 5

/decl/chemical_reaction/drug/paralytics
	name = "Paralytics"
	result = /decl/material/liquid/paralytics
	required_reagents = list(/decl/material/liquid/alcohol/ethanol = 1, /decl/material/liquid/mercury = 2, /decl/material/liquid/fuel/hydrazine = 2)
	result_amount = 1

/decl/chemical_reaction/drug/zombiepowder
	name = "Zombie Powder"
	result = /decl/material/liquid/zombiepowder
	required_reagents = list(/decl/material/liquid/carpotoxin = 5, /decl/material/liquid/sedatives = 5, /decl/material/solid/metal/copper = 5)
	result_amount = 2
	minimum_temperature = 90 CELSIUS
	maximum_temperature = 99 CELSIUS
	mix_message = "The solution boils off to form a fine powder."

/decl/chemical_reaction/drug/hallucinogenics
	name = "Hallucinogenics"
	result = /decl/material/liquid/hallucinogenics
	required_reagents = list(/decl/material/solid/silicon = 1, /decl/material/liquid/fuel/hydrazine = 1, /decl/material/liquid/antitoxins = 1)
	result_amount = 3
	mix_message = "The solution takes on an iridescent sheen."
	minimum_temperature = 75 CELSIUS
	maximum_temperature = (75 CELSIUS) + 25

/decl/chemical_reaction/drug/stimulants
	name = "Stimulants"
	result = /decl/material/liquid/accumulated/stimulants
	required_reagents = list(/decl/material/liquid/hallucinogenics = 1, /decl/material/solid/lithium = 1)
	result_amount = 3

/decl/chemical_reaction/drug/antidepressants
	name = "Antidepressants"
	result = /decl/material/liquid/accumulated/antidepressants
	required_reagents = list(/decl/material/liquid/hallucinogenics = 1, /decl/material/solid/carbon = 1)
	result_amount = 3

/decl/chemical_reaction/drug/adrenaline
	name = "Adrenaline"
	result = /decl/material/liquid/adrenaline
	required_reagents = list(/decl/material/liquid/nutriment/sugar = 1, /decl/material/liquid/amphetamines = 1, /decl/material/liquid/oxy_meds = 1)
	result_amount = 3

/decl/chemical_reaction/drug/stabilizer
	name = "Stabilizer"
	result = /decl/material/liquid/stabilizer
	required_reagents = list(/decl/material/liquid/nutriment/sugar = 1, /decl/material/solid/carbon = 1, /decl/material/liquid/acetone = 1)
	result_amount = 3

/decl/chemical_reaction/drug/gleam
	name = "Gleam"
	result = /decl/material/liquid/glowsap/gleam
	result_amount = 2
	mix_message = "The surface of the oily, iridescent liquid twitches like a living thing."
	minimum_temperature = 40 CELSIUS
	reaction_sound = 'sound/effects/psi/power_used.ogg'
	catalysts = list(
		/decl/material/liquid/enzyme = 1
	)
	required_reagents = list(
		/decl/material/liquid/hallucinogenics = 2,
		/decl/material/liquid/glowsap = 2
	)

/decl/chemical_reaction/drug/immunobooster
	name = "Immunobooster"
	result = /decl/material/liquid/immunobooster
	required_reagents = list(/decl/material/liquid/presyncopics = 1, /decl/material/liquid/antitoxins = 1)
	minimum_temperature = 40 CELSIUS
	result_amount = 2

/decl/chemical_reaction/drug/clotting_agent
	name = "Clotting Agent"
	result = /decl/material/liquid/clotting_agent
	required_reagents = list(
		/decl/material/liquid/brute_meds = 1,
		/decl/material/solid/metal/iron = 2,
		/decl/material/liquid/carpotoxin = 1
	)
	result_amount = 2

/decl/chemical_reaction/drug/nanoblood
	name = "Nanoblood"
	result = /decl/material/liquid/nanoblood
	required_reagents = list(/decl/material/liquid/nanitefluid = 1, /decl/material/solid/metal/iron = 1, /decl/material/liquid/blood = 1)
	result_amount = 3
	mix_message = "The solution thickens slowly into a glossy liquid."
