// Placeholders for compile purposes.
/material/gas
	name = null
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
	name = MAT_HYDROGEN
	lore_text = "A colorless, flammable gas."
	is_fusion_fuel = TRUE

/material/gas/boron
	name = MAT_BORON
	lore_text = "Boron is a chemical element with the symbol B and atomic number 5."
	is_fusion_fuel = TRUE

/material/gas/lithium
	name = MAT_LITHIUM
	lore_text = "A chemical element, used as antidepressant."
	chem_products = list(/datum/reagent/lithium = 20)
	is_fusion_fuel = TRUE

/material/gas/oxygen
	name = MAT_OXYGEN
	lore_text = "An ubiquitous oxidizing agent."
	chem_products = list(/datum/reagent/oxygen = 20)
	is_fusion_fuel = TRUE

/material/gas/helium
	name = MAT_HELIUM
	lore_text = "A noble gas. It makes your voice squeaky."
	chem_products = list(/datum/reagent/helium = 20)
	is_fusion_fuel = TRUE

/material/gas/carbon_dioxide
	name = MAT_CO2
	lore_text = "A byproduct of respiration."

/material/gas/carbon_monoxide
	name = MAT_CO
	lore_text = "A highly poisonous gas."
	chem_products = list(/datum/reagent/carbon_monoxide = 20)

/material/gas/methyl_bromide
	name = MAT_METHYL_BROMIDE
	lore_text = "A once-popular fumigant and weedkiller."
	chem_products = list(/datum/reagent/toxin/methyl_bromide = 20)

/material/gas/n2o
	name = MAT_N2O
	lore_text = "A mild sedative. Also known as laughing gas."
	chem_products = list(/datum/reagent/nitrous_oxide = 20)

/material/gas/nitrogen
	name = MAT_NITROGEN
	lore_text = "An ubiquitous noble gas."

/material/gas/no2
	name = MAT_NO2
	chem_products = list(/datum/reagent/toxin = 20)

/material/gas/no
	name = MAT_NO

/material/gas/methane
	name = MAT_METHANE

/material/gas/alien
	name = MAT_ALIEN

/material/gas/argon
	name = MAT_ARGON
	lore_text = "Just when you need it, all of your supplies argon."

/material/gas/krypton
	name = MAT_KRYPTON

/material/gas/neon
	name = MAT_NEON

/material/gas/xenon
	name = MAT_XENON
	chem_products = list(/datum/reagent/nitrous_oxide/xenon = 20)

/material/gas/ammonia
	name = MAT_AMMONIA
	chem_products = list(/datum/reagent/ammonia = 20)

/material/gas/chlorine
	name = MAT_CHLORINE
	chem_products = list(/datum/reagent/toxin/chlorine = 20)

/material/gas/sulfur
	name = MAT_SULFUR
	chem_products = list(/datum/reagent/sulfur = 20)

/material/gas/steam
	name = MAT_STEAM
	chem_products = list(/datum/reagent/water = 20)
