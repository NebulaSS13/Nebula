/decl/chemical_reaction/antitoxins
	name = "Antitoxins"
	result = /decl/material/liquid/antitoxins
	required_reagents = list(/decl/material/solid/silicon = 1, /decl/material/solid/potassium = 1, /decl/material/gas/ammonia = 1)
	result_amount = 3

/decl/chemical_reaction/painkillers
	name = "Mild Painkillers"
	result = /decl/material/liquid/painkillers
	required_reagents = list(
		/decl/material/liquid/painkillers/strong = 1,
		/decl/material/liquid/water = 1,
		/decl/material/liquid/nutriment/sugar = 1
	)
	result_amount = 3

/decl/chemical_reaction/strong_painkillers
	name = "Strong Painkillers"
	result = /decl/material/liquid/painkillers/strong
	required_reagents = list(
		/decl/material/liquid/stabilizer = 1,
		/decl/material/liquid/ethanol = 1,
		/decl/material/liquid/acetone = 1
	)
	result_amount = 3

/decl/chemical_reaction/antiseptic
	name = "Antiseptic"
	result = /decl/material/liquid/antiseptic
	required_reagents = list(/decl/material/liquid/ethanol = 1, /decl/material/liquid/antitoxins = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 3

/decl/chemical_reaction/mutagenics
	name = "Unstable mutagen"
	result = /decl/material/liquid/mutagenics
	required_reagents = list(/decl/material/solid/metal/radium = 1, /decl/material/solid/phosphorus = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 3

/decl/chemical_reaction/psychoactives
	name = "Psychoactives"
	result = /decl/material/liquid/psychoactives
	required_reagents = list(/decl/material/liquid/mercury = 1, /decl/material/liquid/nutriment/sugar = 1, /decl/material/solid/lithium = 1)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (50 CELSIUS) + 100

/decl/chemical_reaction/lube
	name = "Lubricant"
	result = /decl/material/liquid/lube
	required_reagents = list(/decl/material/liquid/water = 1, /decl/material/solid/silicon = 1, /decl/material/liquid/acetone = 1)
	result_amount = 3
	mix_message = "The solution becomes thick and slimy."

/decl/chemical_reaction/pacid
	name = "Polytrinic acid"
	result = /decl/material/liquid/acid/polyacid
	required_reagents = list(/decl/material/liquid/acid = 1, /decl/material/liquid/acid/hydrochloric = 1, /decl/material/solid/potassium = 1)
	result_amount = 3

/decl/chemical_reaction/antirads
	name = "Anti-Radiation Medication"
	result = /decl/material/liquid/antirads
	required_reagents = list(/decl/material/solid/metal/radium = 1, /decl/material/liquid/antitoxins = 1)
	result_amount = 2

/decl/chemical_reaction/narcotics
	name = "Narcotics"
	result = /decl/material/liquid/narcotics
	required_reagents = list(/decl/material/liquid/mercury = 1, /decl/material/liquid/acetone = 1, /decl/material/liquid/nutriment/sugar = 1)
	result_amount = 2

/decl/chemical_reaction/burn_meds
	name = "Anti-Burn Medication"
	result = /decl/material/liquid/burn_meds
	required_reagents = list(/decl/material/solid/silicon = 1, /decl/material/solid/carbon = 1)
	result_amount = 2
	log_is_important = 1

/decl/chemical_reaction/presyncopics
	name = "Presyncopics"
	result = /decl/material/liquid/presyncopics
	required_reagents = list(/decl/material/solid/potassium = 1, /decl/material/liquid/acetone = 1, /decl/material/liquid/nutriment/sugar = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = 60 CELSIUS
	result_amount = 3

/decl/chemical_reaction/regenerator
	name = "Regenerative Serum"
	result = /decl/material/liquid/regenerator
	required_reagents = list(/decl/material/liquid/stabilizer = 1, /decl/material/liquid/antitoxins = 1)
	result_amount = 2

/decl/chemical_reaction/neuroannealer
	name = "Neuroannealer"
	result = /decl/material/liquid/neuroannealer
	required_reagents = list(/decl/material/liquid/acid/hydrochloric = 1, /decl/material/gas/ammonia = 1, /decl/material/liquid/antitoxins = 1)
	result_amount = 2

/decl/chemical_reaction/oxy_meds
	name = "Oxygen Deprivation Medication"
	result = /decl/material/liquid/oxy_meds
	required_reagents = list(/decl/material/liquid/acetone = 1, /decl/material/liquid/water = 1, /decl/material/solid/sulfur = 1)
	result_amount = 1

/decl/chemical_reaction/brute_meds
	name = "Anti-Trauma Medication"
	result = /decl/material/liquid/brute_meds
	required_reagents = list(/decl/material/liquid/stabilizer = 1, /decl/material/solid/carbon = 1)
	inhibitors = list(/decl/material/liquid/nutriment/sugar = 1) // Messes up with adrenaline
	result_amount = 2

/decl/chemical_reaction/amphetamines
	name = "Amphetamines"
	result = /decl/material/liquid/amphetamines
	required_reagents = list(/decl/material/liquid/nutriment/sugar = 1, /decl/material/solid/phosphorus = 1, /decl/material/solid/sulfur = 1)
	result_amount = 3

/decl/chemical_reaction/retrovirals
	name = "Retrovirals"
	result = /decl/material/liquid/retrovirals
	required_reagents = list(/decl/material/liquid/antirads = 1, /decl/material/solid/carbon = 1)
	result_amount = 2

/decl/chemical_reaction/nanitefluid
	name = "Nanite Fluid"
	result = /decl/material/liquid/nanitefluid
	required_reagents = list(/decl/material/liquid/plasticide = 1, /decl/material/solid/metal/aluminium = 1, /decl/material/liquid/lube = 1)
	catalysts = list(/decl/material/liquid/crystal_agent = 1)
	result_amount = 3
	minimum_temperature = (-25 CELSIUS) - 100
	maximum_temperature = -25 CELSIUS
	mix_message = "The solution becomes a metallic slime."

/decl/chemical_reaction/antibiotics
	name = "Antibiotics"
	result = /decl/material/liquid/antibiotics
	required_reagents = list(/decl/material/liquid/presyncopics = 1, /decl/material/liquid/stabilizer = 1)
	result_amount = 2

/decl/chemical_reaction/eyedrops
	name = "Eye Drops"
	result = /decl/material/liquid/eyedrops
	required_reagents = list(/decl/material/solid/carbon = 1, /decl/material/liquid/fuel/hydrazine = 1, /decl/material/liquid/antitoxins = 1)
	result_amount = 2

/decl/chemical_reaction/sedatives
	name = "Sedatives"
	result = /decl/material/liquid/sedatives
	required_reagents = list(/decl/material/liquid/ethanol = 1, /decl/material/liquid/nutriment/sugar = 4
	)
	inhibitors = list(
		/decl/material/solid/phosphorus
	) // Messes with the smoke
	result_amount = 5

/decl/chemical_reaction/paralytics
	name = "Paralytics"
	result = /decl/material/liquid/paralytics
	required_reagents = list(/decl/material/liquid/ethanol = 1, /decl/material/liquid/mercury = 2, /decl/material/liquid/fuel/hydrazine = 2)
	result_amount = 1

/decl/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	result = /decl/material/liquid/zombiepowder
	required_reagents = list(/decl/material/liquid/carpotoxin = 5, /decl/material/liquid/sedatives = 5, /decl/material/solid/metal/copper = 5)
	result_amount = 2
	minimum_temperature = 90 CELSIUS
	maximum_temperature = 99 CELSIUS
	mix_message = "The solution boils off to form a fine powder."

/decl/chemical_reaction/hallucinogenics
	name = "Hallucinogenics"
	result = /decl/material/liquid/hallucinogenics
	required_reagents = list(/decl/material/solid/silicon = 1, /decl/material/liquid/fuel/hydrazine = 1, /decl/material/liquid/antitoxins = 1)
	result_amount = 3
	mix_message = "The solution takes on an iridescent sheen."
	minimum_temperature = 75 CELSIUS
	maximum_temperature = (75 CELSIUS) + 25

/decl/chemical_reaction/surfactant
	name = "Azosurfactant"
	result = /decl/material/liquid/surfactant
	required_reagents = list(/decl/material/liquid/fuel/hydrazine = 2, /decl/material/solid/carbon = 2, /decl/material/liquid/acid = 1)
	result_amount = 5
	mix_message = "The solution begins to foam gently."

/decl/chemical_reaction/space_cleaner
	name = "Space cleaner"
	result = /decl/material/liquid/cleaner
	required_reagents = list(/decl/material/gas/ammonia = 1, /decl/material/liquid/water = 1)
	mix_message = "The solution becomes slick and soapy."
	result_amount = 2

/decl/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	result = /decl/material/liquid/weedkiller
	required_reagents = list(
		/decl/material/liquid/bromide = 1,
		/decl/material/liquid/water = 4
	)
	result_amount = 5

/decl/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	result = /decl/material/liquid/foaming_agent
	required_reagents = list(/decl/material/solid/lithium = 1, /decl/material/liquid/fuel/hydrazine = 1)
	result_amount = 1
	mix_message = "The solution begins to foam vigorously."

/decl/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	result = /decl/material/solid/sodiumchloride
	required_reagents = list(/decl/material/solid/sodium = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 2

/decl/chemical_reaction/stimulants
	name = "Stimulants"
	result = /decl/material/liquid/stimulants
	required_reagents = list(/decl/material/liquid/hallucinogenics = 1, /decl/material/solid/lithium = 1)
	result_amount = 3

/decl/chemical_reaction/antidepressants
	name = "Antidepressants"
	result = /decl/material/liquid/antidepressants
	required_reagents = list(/decl/material/liquid/hallucinogenics = 1, /decl/material/solid/carbon = 1)
	result_amount = 3

/decl/chemical_reaction/hair_remover
	name = "Hair Remover"
	result = /decl/material/liquid/hair_remover
	required_reagents = list(/decl/material/solid/metal/radium = 1, /decl/material/solid/potassium = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 3
	mix_message = "The solution thins out and emits an acrid smell."

/decl/chemical_reaction/methyl_bromide
	name = "Methyl Bromide"
	required_reagents = list(
		/decl/material/liquid/bromide = 1,
		/decl/material/liquid/ethanol = 1,
		/decl/material/liquid/fuel/hydrazine = 1
	)
	result_amount = 3
	result = /decl/material/gas/methyl_bromide
	mix_message = "The solution begins to bubble, emitting a dark vapor."

/decl/chemical_reaction/adrenaline
	name = "Adrenaline"
	result = /decl/material/liquid/adrenaline
	required_reagents = list(/decl/material/liquid/nutriment/sugar = 1, /decl/material/liquid/amphetamines = 1, /decl/material/liquid/oxy_meds = 1)
	result_amount = 3

/decl/chemical_reaction/stabilizer
	name = "Stabilizer"
	result = /decl/material/liquid/stabilizer
	required_reagents = list(/decl/material/liquid/nutriment/sugar = 1, /decl/material/solid/carbon = 1, /decl/material/liquid/acetone = 1)
	result_amount = 3

/decl/chemical_reaction/gleam
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

/decl/chemical_reaction/immunobooster
	name = "Immunobooster"
	result = /decl/material/liquid/immunobooster
	required_reagents = list(/decl/material/liquid/presyncopics = 1, /decl/material/liquid/antitoxins = 1)
	minimum_temperature = 40 CELSIUS
	result_amount = 2

/decl/chemical_reaction/clotting_agent
	name = "Clotting Agent"
	result = /decl/material/liquid/clotting_agent
	required_reagents = list(
		/decl/material/liquid/brute_meds = 1,
		/decl/material/solid/metal/iron = 2,
		/decl/material/liquid/carpotoxin = 1
	)
	result_amount = 2
