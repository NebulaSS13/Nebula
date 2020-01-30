// Placeholders for compile purposes.
/material/gas
	display_name = null
	icon_colour = COLOR_GRAY80
	stack_type = null
	shard_type = SHARD_NONE
	conductive = 0
	alloy_materials = null
	alloy_product = FALSE
	sale_price = null
	hidden_from_codex = TRUE
	value = 0

/material/gas/hydrogen
	display_name = "hydrogen"
	lore_text = "A colorless, flammable gas."
	is_fusion_fuel = TRUE

/material/gas/boron
	display_name = "boron"
	lore_text = "Boron is a chemical element with the symbol B and atomic number 5."
	is_fusion_fuel = TRUE

/material/gas/lithium
	display_name = "lithium"
	lore_text = "A chemical element, used as antidepressant."
	chem_products = list(/datum/reagent/lithium = 20)
	is_fusion_fuel = TRUE

/material/gas/oxygen
	display_name = "oxygen"
	lore_text = "An ubiquitous oxidizing agent."
	chem_products = list(/datum/reagent/oxygen = 20)
	is_fusion_fuel = TRUE

/material/gas/helium
	display_name = "helium"
	lore_text = "A noble gas. It makes your voice squeaky."
	chem_products = list(/datum/reagent/helium = 20)
	is_fusion_fuel = TRUE

/material/gas/carbon_dioxide
	display_name = "carbon dioxide"
	lore_text = "A byproduct of respiration."

/material/gas/carbon_monoxide
	display_name = "carbon monoxide"
	lore_text = "A highly poisonous gas."
	chem_products = list(/datum/reagent/carbon_monoxide = 20)

/material/gas/methyl_bromide
	display_name = "methyl bromide"
	lore_text = "A once-popular fumigant and weedkiller."
	chem_products = list(/datum/reagent/toxin/methyl_bromide = 20)

/material/gas/sleeping_agent
	display_name = "sleeping agent"
	lore_text = "A mild sedative. Also known as laughing gas."
	chem_products = list(/datum/reagent/nitrous_oxide = 20)

/material/gas/nitrogen
	display_name = "nitrogen"
	lore_text = "An ubiquitous noble gas."

/material/gas/nitrodioxide
	display_name = "nitrogen dioxide"
	chem_products = list(/datum/reagent/toxin = 20)

/material/gas/nitricoxide
	display_name = "nitric oxide"

/material/gas/methane
	display_name = "methane"

/material/gas/alien
	display_name = "alien gas"

/material/gas/argon
	display_name = "argon"
	lore_text = "Just when you need it, all of your supplies argon."

/material/gas/krypton
	display_name = "krypton"

/material/gas/neon
	display_name = "neon"

/material/gas/xenon
	display_name = "xenon"
	chem_products = list(/datum/reagent/nitrous_oxide/xenon = 20)

/material/gas/ammonia
	display_name = "ammonia"
	chem_products = list(/datum/reagent/ammonia = 20)

/material/gas/chlorine
	display_name = "chlorine"
	chem_products = list(/datum/reagent/toxin/chlorine = 20)

/material/gas/sulfurdioxide
	display_name = "sulfur dioxide"
	chem_products = list(/datum/reagent/sulfur = 20)

/material/gas/water
	display_name = "water vapour"
	chem_products = list(/datum/reagent/water = 20)
