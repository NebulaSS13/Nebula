/datum/chemical_reaction/antitoxins
	name = "Antitoxins"
	result = /decl/material/chem/antitoxins
	required_reagents = list(/decl/material/chem/silicon = 1, /decl/material/chem/potassium = 1, /decl/material/chem/ammonia = 1)
	result_amount = 3

/datum/chemical_reaction/painkillers
	name = "Painkillers"
	result = /decl/material/chem/painkillers
	required_reagents = list(/decl/material/chem/adrenaline = 1, /decl/material/chem/ethanol = 1, /decl/material/chem/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/antiseptic
	name = "Antiseptic"
	result = /decl/material/chem/antiseptic
	required_reagents = list(/decl/material/chem/ethanol = 1, /decl/material/chem/antitoxins = 1, /decl/material/chem/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/mutagenics
	name = "Unstable mutagen"
	result = /decl/material/chem/mutagenics
	required_reagents = list(/decl/material/chem/radium = 1, /decl/material/chem/phosphorus = 1, /decl/material/chem/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/psychoactives
	name = "Psychoactives"
	result = /decl/material/chem/psychoactives
	required_reagents = list(/decl/material/chem/mercury = 1, /decl/material/chem/nutriment/sugar = 1, /decl/material/chem/lithium = 1)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (50 CELSIUS) + 100

/datum/chemical_reaction/lube
	name = "Lubricant"
	result = /decl/material/chem/lube
	required_reagents = list(/decl/material/gas/water = 1, /decl/material/chem/silicon = 1, /decl/material/chem/acetone = 1)
	result_amount = 4
	mix_message = "The solution becomes thick and slimy."

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	result = /decl/material/chem/acid/polyacid
	required_reagents = list(/decl/material/chem/acid = 1, /decl/material/chem/acid/hydrochloric = 1, /decl/material/chem/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/antirads
	name = "Anti-Radiation Medication"
	result = /decl/material/chem/antirads
	required_reagents = list(/decl/material/chem/radium = 1, /decl/material/chem/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/narcotics
	name = "Narcotics"
	result = /decl/material/chem/narcotics
	required_reagents = list(/decl/material/chem/mercury = 1, /decl/material/chem/acetone = 1, /decl/material/chem/nutriment/sugar = 1)
	result_amount = 2

/datum/chemical_reaction/burn_meds
	name = "Anti-Burn Medication"
	result = /decl/material/chem/burn_meds
	required_reagents = list(/decl/material/chem/silicon = 1, /decl/material/chem/carbon = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/presyncopics
	name = "Presyncopics"
	result = /decl/material/chem/presyncopics
	required_reagents = list(/decl/material/chem/potassium = 1, /decl/material/chem/acetone = 1, /decl/material/chem/nutriment/sugar = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = 60 CELSIUS
	result_amount = 3

/datum/chemical_reaction/regenerator
	name = "Regenerative Serum"
	result = /decl/material/chem/regenerator
	required_reagents = list(/decl/material/chem/adrenaline = 1, /decl/material/chem/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/neuroannealer
	name = "Neuroannealer"
	result = /decl/material/chem/neuroannealer
	required_reagents = list(/decl/material/chem/acid/hydrochloric = 1, /decl/material/chem/ammonia = 1, /decl/material/chem/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/oxy_meds
	name = "Oxygen Deprivation Medication"
	result = /decl/material/chem/oxy_meds
	required_reagents = list(/decl/material/chem/acetone = 1, /decl/material/gas/water = 1, /decl/material/chem/sulfur = 1)
	result_amount = 1

/datum/chemical_reaction/brute_meds
	name = "Anti-Trauma Medication"
	result = /decl/material/chem/brute_meds
	required_reagents = list(/decl/material/chem/adrenaline = 1, /decl/material/chem/carbon = 1)
	inhibitors = list(/decl/material/chem/nutriment/sugar = 1) // Messes up with adrenaline
	result_amount = 2

/datum/chemical_reaction/amphetamines
	name = "Amphetamines"
	result = /decl/material/chem/amphetamines
	required_reagents = list(/decl/material/chem/nutriment/sugar = 1, /decl/material/chem/phosphorus = 1, /decl/material/chem/sulfur = 1)
	result_amount = 3

/datum/chemical_reaction/retrovirals
	name = "Retrovirals"
	result = /decl/material/chem/retrovirals
	required_reagents = list(/decl/material/chem/antirads = 1, /decl/material/chem/carbon = 1)
	result_amount = 2

/datum/chemical_reaction/nanitefluid
	name = "Nanite Fluid"
	result = /decl/material/chem/nanitefluid
	required_reagents = list(/decl/material/chem/toxin/plasticide = 1, /decl/material/aluminium = 1, /decl/material/chem/lube = 1)
	catalysts = list(/decl/material/chem/toxin/phoron = 5)
	result_amount = 3
	minimum_temperature = (-25 CELSIUS) - 100
	maximum_temperature = -25 CELSIUS
	mix_message = "The solution becomes a metallic slime."

/datum/chemical_reaction/antibiotics
	name = "Antibiotics"
	result = /decl/material/chem/antibiotics
	required_reagents = list(/decl/material/chem/presyncopics = 1, /decl/material/chem/adrenaline = 1)
	result_amount = 2

/datum/chemical_reaction/eyedrops
	name = "Eye Drops"
	result = /decl/material/chem/eyedrops
	required_reagents = list(/decl/material/chem/carbon = 1, /decl/material/chem/fuel/hydrazine = 1, /decl/material/chem/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/sedatives
	name = "Sedatives"
	result = /decl/material/chem/sedatives
	required_reagents = list(/decl/material/chem/ethanol = 1, /decl/material/chem/nutriment/sugar = 4)
	inhibitors = list(/decl/material/chem/phosphorus) // Messes with the smoke
	result_amount = 5

/datum/chemical_reaction/paralytics
	name = "Paralytics"
	result = /decl/material/chem/paralytics
	required_reagents = list(/decl/material/chem/ethanol = 1, /decl/material/chem/mercury = 2, /decl/material/chem/fuel/hydrazine = 2)
	result_amount = 1

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	result = /decl/material/chem/toxin/zombiepowder
	required_reagents = list(/decl/material/chem/toxin/carpotoxin = 5, /decl/material/chem/sedatives = 5, /decl/material/copper = 5)
	result_amount = 2
	minimum_temperature = 90 CELSIUS
	maximum_temperature = 99 CELSIUS
	mix_message = "The solution boils off to form a fine powder."

/datum/chemical_reaction/hallucinogenics
	name = "Hallucinogenics"
	result = /decl/material/chem/hallucinogenics
	required_reagents = list(/decl/material/chem/silicon = 1, /decl/material/chem/fuel/hydrazine = 1, /decl/material/chem/antitoxins = 1)
	result_amount = 3
	mix_message = "The solution takes on an iridescent sheen."
	minimum_temperature = 75 CELSIUS
	maximum_temperature = (75 CELSIUS) + 25

/datum/chemical_reaction/surfactant
	name = "Azosurfactant"
	result = /decl/material/chem/surfactant
	required_reagents = list(/decl/material/chem/fuel/hydrazine = 2, /decl/material/chem/carbon = 2, /decl/material/chem/acid = 1)
	result_amount = 5
	mix_message = "The solution begins to foam gently."

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	result = /decl/material/chem/cleaner
	required_reagents = list(/decl/material/chem/ammonia = 1, /decl/material/gas/water = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	result = /decl/material/chem/toxin/plantbgone
	required_reagents = list(/decl/material/chem/toxin = 1, /decl/material/gas/water = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	result = /decl/material/chem/foaming_agent
	required_reagents = list(/decl/material/chem/lithium = 1, /decl/material/chem/fuel/hydrazine = 1)
	result_amount = 1
	mix_message = "The solution begins to foam vigorously."

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	result = /decl/material/sodium_chloride
	required_reagents = list(/decl/material/chem/sodium = 1, /decl/material/chem/acid/hydrochloric = 1)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	result = /decl/material/chem/capsaicin/condensed
	required_reagents = list(/decl/material/chem/capsaicin = 2)
	catalysts = list(/decl/material/chem/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/stimulants
	name = "Stimulants"
	result = /decl/material/chem/stimulants
	required_reagents = list(/decl/material/chem/hallucinogenics = 1, /decl/material/chem/lithium = 1)
	result_amount = 3

/datum/chemical_reaction/antidepressants
	name = "Antidepressants"
	result = /decl/material/chem/antidepressants
	required_reagents = list(/decl/material/chem/hallucinogenics = 1, /decl/material/chem/carbon = 1)
	result_amount = 3

/datum/chemical_reaction/hair_remover
	name = "Hair Remover"
	result = /decl/material/chem/toxin/hair_remover
	required_reagents = list(/decl/material/chem/radium = 1, /decl/material/chem/potassium = 1, /decl/material/chem/acid/hydrochloric = 1)
	result_amount = 3
	mix_message = "The solution thins out and emits an acrid smell."

/datum/chemical_reaction/methyl_bromide
	name = "Methyl Bromide"
	required_reagents = list(/decl/material/chem/toxin/bromide = 1, /decl/material/chem/ethanol = 1, /decl/material/chem/fuel/hydrazine = 1)
	result_amount = 3
	result = /decl/material/gas/methyl_bromide
	mix_message = "The solution begins to bubble, emitting a dark vapor."

/datum/chemical_reaction/adrenaline
	name = "Adrenaline"
	result = /decl/material/chem/adrenaline
	required_reagents = list(/decl/material/chem/nutriment/sugar = 1, /decl/material/chem/amphetamines = 1, /decl/material/chem/oxy_meds = 1)
	result_amount = 3

/datum/chemical_reaction/gleam
	name = "Gleam"
	result = /decl/material/chem/glowsap/gleam
	result_amount = 2
	mix_message = "The surface of the oily, iridescent liquid twitches like a living thing."
	minimum_temperature = 40 CELSIUS
	reaction_sound = 'sound/effects/psi/power_used.ogg'
	catalysts = list(
		/decl/material/chem/enzyme = 1
	)
	required_reagents = list(
		/decl/material/chem/hallucinogenics = 2,
		/decl/material/chem/glowsap = 2
	)

/datum/chemical_reaction/immunobooster
	result = /decl/material/chem/immunobooster
	required_reagents = list(/decl/material/chem/presyncopics = 1, /decl/material/chem/antitoxins = 1)
	minimum_temperature = 40 CELSIUS
	result_amount = 2
