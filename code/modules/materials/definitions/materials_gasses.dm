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
	name = MATERIAL_HYDROGEN
	lore_text = "A colorless, flammable gas."
	is_fusion_fuel = TRUE

/material/gas/boron
	name = MATERIAL_BORON
	lore_text = "Boron is a chemical element with the symbol B and atomic number 5."
	is_fusion_fuel = TRUE

/material/gas/lithium
	name = MATERIAL_LITHIUM
	lore_text = "A chemical element, used as antidepressant."
	chem_products = list(/datum/reagent/lithium = 20)
	is_fusion_fuel = TRUE

/material/gas/oxygen
	name = MATERIAL_OXYGEN
	lore_text = "An ubiquitous oxidizing agent."
	chem_products = list(/datum/reagent/oxygen = 20)
	is_fusion_fuel = TRUE

/material/gas/helium
	name = MATERIAL_HELIUM
	lore_text = "A noble gas. It makes your voice squeaky."
	chem_products = list(/datum/reagent/helium = 20)
	is_fusion_fuel = TRUE

/material/gas/carbon_dioxide
	name = MATERIAL_CO2
	lore_text = "A byproduct of respiration."

/material/gas/carbon_monoxide
	name = MATERIAL_CO
	lore_text = "A highly poisonous gas."
	chem_products = list(/datum/reagent/carbon_monoxide = 20)

/material/gas/methyl_bromide
	name = MATERIAL_METHYL_BROMIDE
	lore_text = "A once-popular fumigant and weedkiller."
	chem_products = list(/datum/reagent/toxin/methyl_bromide = 20)

/material/gas/n2o
	name = MATERIAL_N2O
	lore_text = "A mild sedative. Also known as laughing gas."
	chem_products = list(/datum/reagent/nitrous_oxide = 20)

/material/gas/nitrogen
	name = MATERIAL_NITROGEN
	lore_text = "An ubiquitous noble gas."

/material/gas/no2
	name = MATERIAL_NO2
	chem_products = list(/datum/reagent/toxin = 20)

/material/gas/no
	name = MATERIAL_NO

/material/gas/methane
	name = MATERIAL_METHANE

/material/gas/alien
	name = MATERIAL_ALIEN

/material/gas/argon
	name = MATERIAL_ARGON
	lore_text = "Just when you need it, all of your supplies argon."

/material/gas/krypton
	name = MATERIAL_KRYPTON

/material/gas/neon
	name = MATERIAL_NEON

/material/gas/xenon
	name = MATERIAL_XENON
	chem_products = list(/datum/reagent/nitrous_oxide/xenon = 20)

/material/gas/ammonia
	name = MATERIAL_AMMONIA
	chem_products = list(/datum/reagent/ammonia = 20)

/material/gas/chlorine
	name = MATERIAL_CHLORINE
	chem_products = list(/datum/reagent/toxin/chlorine = 20)

/material/gas/sulfur
	name = MATERIAL_SULFUR
	chem_products = list(/datum/reagent/sulfur = 20)

/material/gas/steam
	name = MATERIAL_STEAM
	chem_products = list(/datum/reagent/water = 20)
