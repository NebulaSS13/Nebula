/datum/chemical_reaction/antitoxins
	name = "Antitoxins"
	result = /datum/reagent/antitoxins
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/potassium = 1, /datum/reagent/ammonia = 1)
	result_amount = 3

/datum/chemical_reaction/painkillers
	name = "Painkillers"
	result = /datum/reagent/painkillers
	required_reagents = list(/datum/reagent/adrenaline = 1, /datum/reagent/ethanol = 1, /datum/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/antiseptic
	name = "Antiseptic"
	result = /datum/reagent/antiseptic
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/antitoxins = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/mutagenics
	name = "Unstable mutagen"
	result = /datum/reagent/mutagenics
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/phosphorus = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/psychoactives
	name = "Psychoactives"
	result = /datum/reagent/psychoactives
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/nutriment/sugar = 1, /datum/reagent/lithium = 1)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (50 CELSIUS) + 100

/datum/chemical_reaction/lube
	name = "Lubricant"
	result = /datum/reagent/lube
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/silicon = 1, /datum/reagent/acetone = 1)
	result_amount = 4
	mix_message = "The solution becomes thick and slimy."

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	result = /datum/reagent/acid/polyacid
	required_reagents = list(/datum/reagent/acid = 1, /datum/reagent/acid/hydrochloric = 1, /datum/reagent/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/antirads
	name = "Anti-Radiation Medication"
	result = /datum/reagent/antirads
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/narcotics
	name = "Narcotics"
	result = /datum/reagent/narcotics
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/acetone = 1, /datum/reagent/nutriment/sugar = 1)
	result_amount = 2

/datum/chemical_reaction/burn_meds
	name = "Anti-Burn Medication"
	result = /datum/reagent/burn_meds
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/carbon = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/presyncopics
	name = "Presyncopics"
	result = /datum/reagent/presyncopics
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/acetone = 1, /datum/reagent/nutriment/sugar = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = 60 CELSIUS
	result_amount = 3

/datum/chemical_reaction/regenerator
	name = "Regenerative Serum"
	result = /datum/reagent/regenerator
	required_reagents = list(/datum/reagent/adrenaline = 1, /datum/reagent/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/neuroannealer
	name = "Neuroannealer"
	result = /datum/reagent/neuroannealer
	required_reagents = list(/datum/reagent/acid/hydrochloric = 1, /datum/reagent/ammonia = 1, /datum/reagent/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/oxy_meds
	name = "Oxygen Deprivation Medication"
	result = /datum/reagent/oxy_meds
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/water = 1, /datum/reagent/sulfur = 1)
	result_amount = 1

/datum/chemical_reaction/brute_meds
	name = "Anti-Trauma Medication"
	result = /datum/reagent/brute_meds
	required_reagents = list(/datum/reagent/adrenaline = 1, /datum/reagent/carbon = 1)
	inhibitors = list(/datum/reagent/nutriment/sugar = 1) // Messes up with adrenaline
	result_amount = 2

/datum/chemical_reaction/amphetamines
	name = "Amphetamines"
	result = /datum/reagent/amphetamines
	required_reagents = list(/datum/reagent/nutriment/sugar = 1, /datum/reagent/phosphorus = 1, /datum/reagent/sulfur = 1)
	result_amount = 3

/datum/chemical_reaction/retrovirals
	name = "Retrovirals"
	result = /datum/reagent/retrovirals
	required_reagents = list(/datum/reagent/antirads = 1, /datum/reagent/carbon = 1)
	result_amount = 2

/datum/chemical_reaction/nanitefluid
	name = "Nanite Fluid"
	result = /datum/reagent/nanitefluid
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/aluminium = 1, /datum/reagent/lube = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 3
	minimum_temperature = (-25 CELSIUS) - 100
	maximum_temperature = -25 CELSIUS
	mix_message = "The solution becomes a metallic slime."

/datum/chemical_reaction/antibiotics
	name = "Antibiotics"
	result = /datum/reagent/antibiotics
	required_reagents = list(/datum/reagent/presyncopics = 1, /datum/reagent/adrenaline = 1)
	result_amount = 2

/datum/chemical_reaction/eyedrops
	name = "Eye Drops"
	result = /datum/reagent/eyedrops
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/fuel/hydrazine = 1, /datum/reagent/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/sedatives
	name = "Sedatives"
	result = /datum/reagent/sedatives
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/nutriment/sugar = 4)
	inhibitors = list(/datum/reagent/phosphorus) // Messes with the smoke
	result_amount = 5

/datum/chemical_reaction/paralytics
	name = "Paralytics"
	result = /datum/reagent/paralytics
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/mercury = 2, /datum/reagent/fuel/hydrazine = 2)
	result_amount = 1

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	result = /datum/reagent/toxin/zombiepowder
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 5, /datum/reagent/sedatives = 5, /datum/reagent/copper = 5)
	result_amount = 2
	minimum_temperature = 90 CELSIUS
	maximum_temperature = 99 CELSIUS
	mix_message = "The solution boils off to form a fine powder."

/datum/chemical_reaction/hallucinogenics
	name = "Hallucinogenics"
	result = /datum/reagent/hallucinogenics
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/fuel/hydrazine = 1, /datum/reagent/antitoxins = 1)
	result_amount = 3
	mix_message = "The solution takes on an iridescent sheen."
	minimum_temperature = 75 CELSIUS
	maximum_temperature = (75 CELSIUS) + 25

/datum/chemical_reaction/surfactant
	name = "Azosurfactant"
	result = /datum/reagent/surfactant
	required_reagents = list(/datum/reagent/fuel/hydrazine = 2, /datum/reagent/carbon = 2, /datum/reagent/acid = 1)
	result_amount = 5
	mix_message = "The solution begins to foam gently."

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	result = /datum/reagent/cleaner
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	result = /datum/reagent/toxin/plantbgone
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/water = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	result = /datum/reagent/foaming_agent
	required_reagents = list(/datum/reagent/lithium = 1, /datum/reagent/fuel/hydrazine = 1)
	result_amount = 1
	mix_message = "The solution begins to foam vigorously."

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	result = /datum/reagent/sodiumchloride
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	result = /datum/reagent/capsaicin/condensed
	required_reagents = list(/datum/reagent/capsaicin = 2)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/stimulants
	name = "Stimulants"
	result = /datum/reagent/stimulants
	required_reagents = list(/datum/reagent/hallucinogenics = 1, /datum/reagent/lithium = 1)
	result_amount = 3

/datum/chemical_reaction/antidepressants
	name = "Antidepressants"
	result = /datum/reagent/antidepressants
	required_reagents = list(/datum/reagent/hallucinogenics = 1, /datum/reagent/carbon = 1)
	result_amount = 3

/datum/chemical_reaction/hair_remover
	name = "Hair Remover"
	result = /datum/reagent/toxin/hair_remover
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/potassium = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3
	mix_message = "The solution thins out and emits an acrid smell."

/datum/chemical_reaction/methyl_bromide
	name = "Methyl Bromide"
	required_reagents = list(/datum/reagent/toxin/bromide = 1, /datum/reagent/ethanol = 1, /datum/reagent/fuel/hydrazine = 1)
	result_amount = 3
	result = /datum/reagent/toxin/methyl_bromide
	mix_message = "The solution begins to bubble, emitting a dark vapor."

/datum/chemical_reaction/adrenaline
	name = "Adrenaline"
	result = /datum/reagent/adrenaline
	required_reagents = list(/datum/reagent/nutriment/sugar = 1, /datum/reagent/amphetamines = 1, /datum/reagent/oxy_meds = 1)
	result_amount = 3

/datum/chemical_reaction/gleam
	name = "Gleam"
	result = /datum/reagent/glowsap/gleam
	result_amount = 2
	mix_message = "The surface of the oily, iridescent liquid twitches like a living thing."
	minimum_temperature = 40 CELSIUS
	reaction_sound = 'sound/effects/psi/power_used.ogg'
	catalysts = list(
		/datum/reagent/enzyme = 1
	)
	required_reagents = list(
		/datum/reagent/hallucinogenics = 2,
		/datum/reagent/glowsap = 2
	)

/datum/chemical_reaction/immunobooster
	result = /datum/reagent/immunobooster
	required_reagents = list(/datum/reagent/presyncopics = 1, /datum/reagent/antitoxins = 1)
	minimum_temperature = 40 CELSIUS
	result_amount = 2
