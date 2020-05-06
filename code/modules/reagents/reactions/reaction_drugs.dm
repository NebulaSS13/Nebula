/datum/chemical_reaction/antitoxins
	name = "Antitoxins"
	result = /decl/material/antitoxins
	required_reagents = list(/decl/material/silicon = 1, /decl/material/potassium = 1, MAT_AMMONIA = 1)
	result_amount = 3

/datum/chemical_reaction/painkillers
	name = "Painkillers"
	result = /decl/material/painkillers
	required_reagents = list(/decl/material/adrenaline = 1, /decl/material/ethanol = 1, /decl/material/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/antiseptic
	name = "Antiseptic"
	result = /decl/material/antiseptic
	required_reagents = list(
		/decl/material/ethanol = 1, 
		/decl/material/antitoxins = 1, 
		MAT_ACID_HYDROCHLORIC = 1
	)
	result_amount = 3

/datum/chemical_reaction/mutagenics
	name = "Unstable mutagen"
	result = /decl/material/mutagenics
	required_reagents = list(
		/decl/material/radium = 1, 
		/decl/material/phosphorus = 1, 
		MAT_ACID_HYDROCHLORIC = 1
	)
	result_amount = 3

/datum/chemical_reaction/psychoactives
	name = "Psychoactives"
	result = /decl/material/psychoactives
	required_reagents = list(/decl/material/mercury = 1, /decl/material/nutriment/sugar = 1, /decl/material/lithium = 1)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (50 CELSIUS) + 100

/datum/chemical_reaction/lube
	name = "Lubricant"
	result = /decl/material/lube
	required_reagents = list(
		MAT_WATER = 1, 
		/decl/material/silicon = 1, 
		/decl/material/acetone = 1
	)
	result_amount = 4
	mix_message = "The solution becomes thick and slimy."

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	result = MAT_ACID_POLYTRINIC
	required_reagents = list(
		MAT_ACID_SULPHURIC = 1, 
		MAT_ACID_HYDROCHLORIC = 1, 
		/decl/material/potassium = 1
	)
	result_amount = 3

/datum/chemical_reaction/antirads
	name = "Anti-Radiation Medication"
	result = /decl/material/antirads
	required_reagents = list(/decl/material/radium = 1, /decl/material/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/narcotics
	name = "Narcotics"
	result = /decl/material/narcotics
	required_reagents = list(/decl/material/mercury = 1, /decl/material/acetone = 1, /decl/material/nutriment/sugar = 1)
	result_amount = 2

/datum/chemical_reaction/burn_meds
	name = "Anti-Burn Medication"
	result = /decl/material/burn_meds
	required_reagents = list(
		/decl/material/silicon = 1, 
		MAT_GRAPHITE = 1
	)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/presyncopics
	name = "Presyncopics"
	result = /decl/material/presyncopics
	required_reagents = list(/decl/material/potassium = 1, /decl/material/acetone = 1, /decl/material/nutriment/sugar = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = 60 CELSIUS
	result_amount = 3

/datum/chemical_reaction/regenerator
	name = "Regenerative Serum"
	result = /decl/material/regenerator
	required_reagents = list(/decl/material/adrenaline = 1, /decl/material/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/neuroannealer
	name = "Neuroannealer"
	result = /decl/material/neuroannealer
	required_reagents = list(
		MAT_ACID_HYDROCHLORIC = 1, 
		MAT_AMMONIA = 1, 
		/decl/material/antitoxins = 1
	)
	result_amount = 2

/datum/chemical_reaction/oxy_meds
	name = "Oxygen Deprivation Medication"
	result = /decl/material/oxy_meds
	required_reagents = list(
		/decl/material/acetone = 1, 
		MAT_WATER = 1, 
		/decl/material/sulfur = 1
	)
	result_amount = 1

/datum/chemical_reaction/brute_meds
	name = "Anti-Trauma Medication"
	result = /decl/material/brute_meds
	required_reagents = list(
		/decl/material/adrenaline = 1, 
		MAT_GRAPHITE = 1
	)
	inhibitors = list(/decl/material/nutriment/sugar = 1) // Messes up with adrenaline
	result_amount = 2

/datum/chemical_reaction/amphetamines
	name = "Amphetamines"
	result = /decl/material/amphetamines
	required_reagents = list(/decl/material/nutriment/sugar = 1, /decl/material/phosphorus = 1, /decl/material/sulfur = 1)
	result_amount = 3

/datum/chemical_reaction/retrovirals
	name = "Retrovirals"
	result = /decl/material/retrovirals
	required_reagents = list(
		/decl/material/antirads = 1, 
		MAT_GRAPHITE = 1
	)
	result_amount = 2

/datum/chemical_reaction/nanitefluid
	name = "Nanite Fluid"
	result = /decl/material/nanitefluid
	required_reagents = list(
		/decl/material/toxin/plasticide = 1, 
		MAT_ALUMINIUM = 1, 
		/decl/material/lube = 1
	)
	catalysts = list(MAT_PHORON = 5)
	result_amount = 3
	minimum_temperature = (-25 CELSIUS) - 100
	maximum_temperature = -25 CELSIUS
	mix_message = "The solution becomes a metallic slime."

/datum/chemical_reaction/antibiotics
	name = "Antibiotics"
	result = /decl/material/antibiotics
	required_reagents = list(/decl/material/presyncopics = 1, /decl/material/adrenaline = 1)
	result_amount = 2

/datum/chemical_reaction/eyedrops
	name = "Eye Drops"
	result = /decl/material/eyedrops
	required_reagents = list(
		MAT_GRAPHITE = 1, 
		MAT_HYDRAZINE = 1, 
		/decl/material/antitoxins = 1
	)
	result_amount = 2

/datum/chemical_reaction/sedatives
	name = "Sedatives"
	result = /decl/material/sedatives
	required_reagents = list(/decl/material/ethanol = 1, /decl/material/nutriment/sugar = 4)
	inhibitors = list(/decl/material/phosphorus) // Messes with the smoke
	result_amount = 5

/datum/chemical_reaction/paralytics
	name = "Paralytics"
	result = /decl/material/paralytics
	required_reagents = list(
		/decl/material/ethanol = 1, 
		/decl/material/mercury = 2, 
		MAT_HYDRAZINE = 2
	)
	result_amount = 1

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	result = /decl/material/toxin/zombiepowder
	required_reagents = list(
		/decl/material/toxin/carpotoxin = 5, 
		/decl/material/sedatives = 5, 
		MAT_COPPER = 5
	)
	result_amount = 2
	minimum_temperature = 90 CELSIUS
	maximum_temperature = 99 CELSIUS
	mix_message = "The solution boils off to form a fine powder."

/datum/chemical_reaction/hallucinogenics
	name = "Hallucinogenics"
	result = /decl/material/hallucinogenics
	required_reagents = list(
		/decl/material/silicon = 1, 
		MAT_HYDRAZINE = 1, 
		/decl/material/antitoxins = 1
	)
	result_amount = 3
	mix_message = "The solution takes on an iridescent sheen."
	minimum_temperature = 75 CELSIUS
	maximum_temperature = (75 CELSIUS) + 25

/datum/chemical_reaction/surfactant
	name = "Azosurfactant"
	result = /decl/material/surfactant
	required_reagents = list(
		MAT_HYDRAZINE = 2, 
		MAT_GRAPHITE = 2, 
		MAT_ACID_SULPHURIC = 1
	)
	result_amount = 5
	mix_message = "The solution begins to foam gently."

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	result = /decl/material/cleaner
	required_reagents = list(
		MAT_AMMONIA = 1, 
		MAT_WATER = 1
	)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	result = /decl/material/toxin/plantbgone
	required_reagents = list(
		/decl/material/toxin = 1,
		MAT_WATER = 4
	)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	result = /decl/material/foaming_agent
	required_reagents = list(
		/decl/material/lithium = 1, 
		MAT_HYDRAZINE = 1
	)
	result_amount = 1
	mix_message = "The solution begins to foam vigorously."

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	result = /decl/material/sodiumchloride
	required_reagents = list(
		/decl/material/sodium = 1, 
		MAT_ACID_HYDROCHLORIC = 1
	)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	result = /decl/material/capsaicin/condensed
	required_reagents = list(/decl/material/capsaicin = 2)
	catalysts = list(MAT_PHORON = 5)
	result_amount = 1

/datum/chemical_reaction/stimulants
	name = "Stimulants"
	result = /decl/material/stimulants
	required_reagents = list(/decl/material/hallucinogenics = 1, /decl/material/lithium = 1)
	result_amount = 3

/datum/chemical_reaction/antidepressants
	name = "Antidepressants"
	result = /decl/material/antidepressants
	required_reagents = list(
		/decl/material/hallucinogenics = 1, 
		MAT_GRAPHITE = 1
	)
	result_amount = 3

/datum/chemical_reaction/hair_remover
	name = "Hair Remover"
	result = /decl/material/toxin/hair_remover
	required_reagents = list(
		/decl/material/radium = 1, 
		/decl/material/potassium = 1, 
		MAT_ACID_HYDROCHLORIC = 1
	)
	result_amount = 3
	mix_message = "The solution thins out and emits an acrid smell."

/datum/chemical_reaction/methyl_bromide
	name = "Methyl Bromide"
	required_reagents = list(
		/decl/material/toxin/bromide = 1, 
		/decl/material/ethanol = 1, 
		MAT_HYDRAZINE = 1
	)
	result_amount = 3
	result = MAT_METHYL_BROMIDE
	mix_message = "The solution begins to bubble, emitting a dark vapor."

/datum/chemical_reaction/adrenaline
	name = "Adrenaline"
	result = /decl/material/adrenaline
	required_reagents = list(/decl/material/nutriment/sugar = 1, /decl/material/amphetamines = 1, /decl/material/oxy_meds = 1)
	result_amount = 3

/datum/chemical_reaction/gleam
	name = "Gleam"
	result = /decl/material/glowsap/gleam
	result_amount = 2
	mix_message = "The surface of the oily, iridescent liquid twitches like a living thing."
	minimum_temperature = 40 CELSIUS
	reaction_sound = 'sound/effects/psi/power_used.ogg'
	catalysts = list(
		/decl/material/enzyme = 1
	)
	required_reagents = list(
		/decl/material/hallucinogenics = 2,
		/decl/material/glowsap = 2
	)

/datum/chemical_reaction/immunobooster
	result = /decl/material/immunobooster
	required_reagents = list(/decl/material/presyncopics = 1, /decl/material/antitoxins = 1)
	minimum_temperature = 40 CELSIUS
	result_amount = 2
