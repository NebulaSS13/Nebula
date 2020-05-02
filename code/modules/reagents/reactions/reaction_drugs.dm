/datum/chemical_reaction/antitoxins
	name = "Antitoxins"
	result = /decl/reagent/antitoxins
	required_reagents = list(/decl/reagent/silicon = 1, /decl/reagent/potassium = 1, /decl/reagent/ammonia = 1)
	result_amount = 3

/datum/chemical_reaction/painkillers
	name = "Painkillers"
	result = /decl/reagent/painkillers
	required_reagents = list(/decl/reagent/adrenaline = 1, /decl/reagent/ethanol = 1, /decl/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/antiseptic
	name = "Antiseptic"
	result = /decl/reagent/antiseptic
	required_reagents = list(/decl/reagent/ethanol = 1, /decl/reagent/antitoxins = 1, /decl/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/mutagenics
	name = "Unstable mutagen"
	result = /decl/reagent/mutagenics
	required_reagents = list(/decl/reagent/radium = 1, /decl/reagent/phosphorus = 1, /decl/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/psychoactives
	name = "Psychoactives"
	result = /decl/reagent/psychoactives
	required_reagents = list(/decl/reagent/mercury = 1, /decl/reagent/nutriment/sugar = 1, /decl/reagent/lithium = 1)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (50 CELSIUS) + 100

/datum/chemical_reaction/lube
	name = "Lubricant"
	result = /decl/reagent/lube
	required_reagents = list(/decl/reagent/water = 1, /decl/reagent/silicon = 1, /decl/reagent/acetone = 1)
	result_amount = 4
	mix_message = "The solution becomes thick and slimy."

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	result = /decl/reagent/acid/polyacid
	required_reagents = list(/decl/reagent/acid = 1, /decl/reagent/acid/hydrochloric = 1, /decl/reagent/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/antirads
	name = "Anti-Radiation Medication"
	result = /decl/reagent/antirads
	required_reagents = list(/decl/reagent/radium = 1, /decl/reagent/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/narcotics
	name = "Narcotics"
	result = /decl/reagent/narcotics
	required_reagents = list(/decl/reagent/mercury = 1, /decl/reagent/acetone = 1, /decl/reagent/nutriment/sugar = 1)
	result_amount = 2

/datum/chemical_reaction/burn_meds
	name = "Anti-Burn Medication"
	result = /decl/reagent/burn_meds
	required_reagents = list(/decl/reagent/silicon = 1, /decl/reagent/carbon = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/presyncopics
	name = "Presyncopics"
	result = /decl/reagent/presyncopics
	required_reagents = list(/decl/reagent/potassium = 1, /decl/reagent/acetone = 1, /decl/reagent/nutriment/sugar = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = 60 CELSIUS
	result_amount = 3

/datum/chemical_reaction/regenerator
	name = "Regenerative Serum"
	result = /decl/reagent/regenerator
	required_reagents = list(/decl/reagent/adrenaline = 1, /decl/reagent/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/neuroannealer
	name = "Neuroannealer"
	result = /decl/reagent/neuroannealer
	required_reagents = list(/decl/reagent/acid/hydrochloric = 1, /decl/reagent/ammonia = 1, /decl/reagent/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/oxy_meds
	name = "Oxygen Deprivation Medication"
	result = /decl/reagent/oxy_meds
	required_reagents = list(/decl/reagent/acetone = 1, /decl/reagent/water = 1, /decl/reagent/sulfur = 1)
	result_amount = 1

/datum/chemical_reaction/brute_meds
	name = "Anti-Trauma Medication"
	result = /decl/reagent/brute_meds
	required_reagents = list(/decl/reagent/adrenaline = 1, /decl/reagent/carbon = 1)
	inhibitors = list(/decl/reagent/nutriment/sugar = 1) // Messes up with adrenaline
	result_amount = 2

/datum/chemical_reaction/amphetamines
	name = "Amphetamines"
	result = /decl/reagent/amphetamines
	required_reagents = list(/decl/reagent/nutriment/sugar = 1, /decl/reagent/phosphorus = 1, /decl/reagent/sulfur = 1)
	result_amount = 3

/datum/chemical_reaction/retrovirals
	name = "Retrovirals"
	result = /decl/reagent/retrovirals
	required_reagents = list(/decl/reagent/antirads = 1, /decl/reagent/carbon = 1)
	result_amount = 2

/datum/chemical_reaction/nanitefluid
	name = "Nanite Fluid"
	result = /decl/reagent/nanitefluid
	required_reagents = list(/decl/reagent/toxin/plasticide = 1, /decl/reagent/aluminium = 1, /decl/reagent/lube = 1)
	catalysts = list(/decl/reagent/toxin/phoron = 5)
	result_amount = 3
	minimum_temperature = (-25 CELSIUS) - 100
	maximum_temperature = -25 CELSIUS
	mix_message = "The solution becomes a metallic slime."

/datum/chemical_reaction/antibiotics
	name = "Antibiotics"
	result = /decl/reagent/antibiotics
	required_reagents = list(/decl/reagent/presyncopics = 1, /decl/reagent/adrenaline = 1)
	result_amount = 2

/datum/chemical_reaction/eyedrops
	name = "Eye Drops"
	result = /decl/reagent/eyedrops
	required_reagents = list(/decl/reagent/carbon = 1, /decl/reagent/fuel/hydrazine = 1, /decl/reagent/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/sedatives
	name = "Sedatives"
	result = /decl/reagent/sedatives
	required_reagents = list(/decl/reagent/ethanol = 1, /decl/reagent/nutriment/sugar = 4)
	inhibitors = list(/decl/reagent/phosphorus) // Messes with the smoke
	result_amount = 5

/datum/chemical_reaction/paralytics
	name = "Paralytics"
	result = /decl/reagent/paralytics
	required_reagents = list(/decl/reagent/ethanol = 1, /decl/reagent/mercury = 2, /decl/reagent/fuel/hydrazine = 2)
	result_amount = 1

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	result = /decl/reagent/toxin/zombiepowder
	required_reagents = list(/decl/reagent/toxin/carpotoxin = 5, /decl/reagent/sedatives = 5, /decl/reagent/copper = 5)
	result_amount = 2
	minimum_temperature = 90 CELSIUS
	maximum_temperature = 99 CELSIUS
	mix_message = "The solution boils off to form a fine powder."

/datum/chemical_reaction/hallucinogenics
	name = "Hallucinogenics"
	result = /decl/reagent/hallucinogenics
	required_reagents = list(/decl/reagent/silicon = 1, /decl/reagent/fuel/hydrazine = 1, /decl/reagent/antitoxins = 1)
	result_amount = 3
	mix_message = "The solution takes on an iridescent sheen."
	minimum_temperature = 75 CELSIUS
	maximum_temperature = (75 CELSIUS) + 25

/datum/chemical_reaction/surfactant
	name = "Azosurfactant"
	result = /decl/reagent/surfactant
	required_reagents = list(/decl/reagent/fuel/hydrazine = 2, /decl/reagent/carbon = 2, /decl/reagent/acid = 1)
	result_amount = 5
	mix_message = "The solution begins to foam gently."

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	result = /decl/reagent/cleaner
	required_reagents = list(/decl/reagent/ammonia = 1, /decl/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	result = /decl/reagent/toxin/plantbgone
	required_reagents = list(/decl/reagent/toxin = 1, /decl/reagent/water = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	result = /decl/reagent/foaming_agent
	required_reagents = list(/decl/reagent/lithium = 1, /decl/reagent/fuel/hydrazine = 1)
	result_amount = 1
	mix_message = "The solution begins to foam vigorously."

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	result = /decl/reagent/sodiumchloride
	required_reagents = list(/decl/reagent/sodium = 1, /decl/reagent/acid/hydrochloric = 1)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	result = /decl/reagent/capsaicin/condensed
	required_reagents = list(/decl/reagent/capsaicin = 2)
	catalysts = list(/decl/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/stimulants
	name = "Stimulants"
	result = /decl/reagent/stimulants
	required_reagents = list(/decl/reagent/hallucinogenics = 1, /decl/reagent/lithium = 1)
	result_amount = 3

/datum/chemical_reaction/antidepressants
	name = "Antidepressants"
	result = /decl/reagent/antidepressants
	required_reagents = list(/decl/reagent/hallucinogenics = 1, /decl/reagent/carbon = 1)
	result_amount = 3

/datum/chemical_reaction/hair_remover
	name = "Hair Remover"
	result = /decl/reagent/toxin/hair_remover
	required_reagents = list(/decl/reagent/radium = 1, /decl/reagent/potassium = 1, /decl/reagent/acid/hydrochloric = 1)
	result_amount = 3
	mix_message = "The solution thins out and emits an acrid smell."

/datum/chemical_reaction/methyl_bromide
	name = "Methyl Bromide"
	required_reagents = list(/decl/reagent/toxin/bromide = 1, /decl/reagent/ethanol = 1, /decl/reagent/fuel/hydrazine = 1)
	result_amount = 3
	result = /decl/reagent/toxin/methyl_bromide
	mix_message = "The solution begins to bubble, emitting a dark vapor."

/datum/chemical_reaction/adrenaline
	name = "Adrenaline"
	result = /decl/reagent/adrenaline
	required_reagents = list(/decl/reagent/nutriment/sugar = 1, /decl/reagent/amphetamines = 1, /decl/reagent/oxy_meds = 1)
	result_amount = 3

/datum/chemical_reaction/gleam
	name = "Gleam"
	result = /decl/reagent/glowsap/gleam
	result_amount = 2
	mix_message = "The surface of the oily, iridescent liquid twitches like a living thing."
	minimum_temperature = 40 CELSIUS
	reaction_sound = 'sound/effects/psi/power_used.ogg'
	catalysts = list(
		/decl/reagent/enzyme = 1
	)
	required_reagents = list(
		/decl/reagent/hallucinogenics = 2,
		/decl/reagent/glowsap = 2
	)

/datum/chemical_reaction/immunobooster
	result = /decl/reagent/immunobooster
	required_reagents = list(/decl/reagent/presyncopics = 1, /decl/reagent/antitoxins = 1)
	minimum_temperature = 40 CELSIUS
	result_amount = 2
